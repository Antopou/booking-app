package com.example.booking_agency.utils

import com.example.booking_agency.data.datasource.local.LocalDataSource
import com.example.booking_agency.data.datasource.remote.NetworkResult
import com.example.booking_agency.data.datasource.remote.RoomBookerApiService
import com.example.booking_agency.domain.model.*
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Sync manager for offline-first data synchronization
 */
class SyncManager(
    private val apiService: RoomBookerApiService,
    private val localDataSource: LocalDataSource,
    private val networkManager: NetworkManager
) {

    private val syncScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val isSyncing = AtomicBoolean(false)

    /**
     * Sync state flow
     */
    private val _syncState = MutableStateFlow<SyncState>(SyncState.Idle)
    val syncState: StateFlow<SyncState> = _syncState

    /**
     * Pending operations that need to be synced when online
     */
    private val pendingOperations = MutableSharedFlow<SyncOperation>(extraBufferCapacity = 100)

    init {
        // Observe network state and trigger sync when coming online
        syncScope.launch {
            networkManager.networkState.collect { networkState ->
                when (networkState) {
                    NetworkState.Available -> {
                        syncPendingOperations()
                    }
                    NetworkState.Unavailable -> {
                        _syncState.value = SyncState.Offline
                    }
                    is NetworkState.Error -> {
                        _syncState.value = SyncState.Error("Network error")
                    }
                }
            }
        }

        // Process pending operations
        syncScope.launch {
            pendingOperations.collect { operation ->
                when (operation) {
                    is SyncOperation.CreateBooking -> syncBookingCreation(operation.booking)
                    is SyncOperation.UpdateBooking -> syncBookingUpdate(operation.booking)
                    is SyncOperation.CancelBooking -> syncBookingCancellation(operation.bookingId)
                }
            }
        }
    }

    /**
     * Sync all data when coming online
     */
    private suspend fun syncPendingOperations() {
        if (isSyncing.getAndSet(true)) return

        try {
            _syncState.value = SyncState.Syncing("Syncing pending operations...")

            // Collect all pending operations
            val operations = mutableListOf<SyncOperation>()
            pendingOperations.replayCache.forEach { operations.add(it) }
            pendingOperations.resetReplayCache()

            // Process operations sequentially
            operations.forEach { operation ->
                try {
                    when (operation) {
                        is SyncOperation.CreateBooking -> syncBookingCreation(operation.booking)
                        is SyncOperation.UpdateBooking -> syncBookingUpdate(operation.booking)
                        is SyncOperation.CancelBooking -> syncBookingCancellation(operation.bookingId)
                    }
                } catch (e: Exception) {
                    // Log error but continue with other operations
                    println("Sync operation failed: ${e.message}")
                }
            }

            // Sync fresh data from server
            syncFromServer()

            _syncState.value = SyncState.Success("Sync completed successfully")
        } catch (e: Exception) {
            _syncState.value = SyncState.Error("Sync failed: ${e.message}")
        } finally {
            isSyncing.set(false)
        }
    }

    /**
     * Sync fresh data from server
     */
    private suspend fun syncFromServer() {
        try {
            // Sync rooms
            when (val result = fetchRoomsFromApi()) {
                is NetworkResult.Success -> {
                    localDataSource.saveRooms(result.data.map { it.toDomain() })
                }
                else -> {
                    // Keep existing data if sync fails
                }
            }

            // Sync user profile if available
            try {
                when (val result = fetchUserProfileFromApi()) {
                    is NetworkResult.Success -> {
                        result.data?.let { user ->
                            localDataSource.saveUser(user.toDomain())
                        }
                    }
                    else -> {
                        // Keep existing user data
                    }
                }
            } catch (e: Exception) {
                // User sync is optional
            }
        } catch (e: Exception) {
            throw e
        }
    }

    /**
     * Queue booking creation for sync
     */
    suspend fun queueBookingCreation(booking: BookingDomain) {
        pendingOperations.emit(SyncOperation.CreateBooking(booking))
        if (networkManager.isOnline()) {
            syncBookingCreation(booking)
        }
    }

    /**
     * Queue booking update for sync
     */
    suspend fun queueBookingUpdate(booking: BookingDomain) {
        pendingOperations.emit(SyncOperation.UpdateBooking(booking))
        if (networkManager.isOnline()) {
            syncBookingUpdate(booking)
        }
    }

    /**
     * Queue booking cancellation for sync
     */
    suspend fun queueBookingCancellation(bookingId: String) {
        pendingOperations.emit(SyncOperation.CancelBooking(bookingId))
        if (networkManager.isOnline()) {
            syncBookingCancellation(bookingId)
        }
    }

    /**
     * Sync booking creation with server
     */
    private suspend fun syncBookingCreation(booking: BookingDomain): Result<String> {
        return try {
            val request = com.example.booking_agency.data.model.CreateBookingRequest(
                roomId = booking.roomId,
                checkInDate = booking.checkInDate,
                checkOutDate = booking.checkOutDate,
                guests = booking.guests,
                specialRequests = booking.specialRequests
            )

            val response = apiService.createBooking(request)
            if (response.isSuccessful) {
                response.body()?.let { apiResponse ->
                    if (apiResponse.success) {
                        // Update local booking with server ID
                        val updatedBooking = booking.copy(id = apiResponse.data ?: booking.id)
                        localDataSource.saveBooking(updatedBooking)
                        Result.success(apiResponse.data ?: booking.id)
                    } else {
                        Result.failure(Exception(apiResponse.message))
                    }
                } ?: Result.failure(Exception("Empty response"))
            } else {
                Result.failure(Exception("HTTP ${response.code()}: ${response.message()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    /**
     * Sync booking update with server
     */
    private suspend fun syncBookingUpdate(booking: BookingDomain): Result<Unit> {
        return try {
            val response = apiService.updateBooking(booking.id, booking.toApiModel())
            if (response.isSuccessful) {
                response.body()?.let { apiResponse ->
                    if (apiResponse.success) {
                        localDataSource.updateBooking(booking.toEntity())
                        Result.success(Unit)
                    } else {
                        Result.failure(Exception(apiResponse.message))
                    }
                } ?: Result.failure(Exception("Empty response"))
            } else {
                Result.failure(Exception("HTTP ${response.code()}: ${response.message()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    /**
     * Sync booking cancellation with server
     */
    private suspend fun syncBookingCancellation(bookingId: String): Result<Unit> {
        return try {
            val response = apiService.cancelBooking(bookingId)
            if (response.isSuccessful) {
                response.body()?.let { apiResponse ->
                    if (apiResponse.success) {
                        localDataSource.cancelBooking(bookingId)
                        Result.success(Unit)
                    } else {
                        Result.failure(Exception(apiResponse.message))
                    }
                } ?: Result.failure(Exception("Empty response"))
            } else {
                Result.failure(Exception("HTTP ${response.code()}: ${response.message()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    /**
     * Fetch rooms from API
     */
    private suspend fun fetchRoomsFromApi(): NetworkResult<List<com.example.booking_agency.data.model.RoomApiModel>> {
        return try {
            val response = apiService.getAllRooms()
            if (response.isSuccessful) {
                response.body()?.let { apiResponse ->
                    if (apiResponse.success && apiResponse.data != null) {
                        NetworkResult.Success(apiResponse.data)
                    } else {
                        NetworkResult.Error(apiResponse.message ?: "Unknown error")
                    }
                } ?: NetworkResult.Error("Empty response")
            } else {
                NetworkResult.Error("HTTP ${response.code()}: ${response.message()}")
            }
        } catch (e: Exception) {
            NetworkResult.Error("Network error: ${e.message}")
        }
    }

    /**
     * Fetch user profile from API
     */
    private suspend fun fetchUserProfileFromApi(): NetworkResult<com.example.booking_agency.data.model.UserApiModel?> {
        return try {
            val response = apiService.getCurrentUser()
            if (response.isSuccessful) {
                response.body()?.let { apiResponse ->
                    if (apiResponse.success) {
                        NetworkResult.Success(apiResponse.data)
                    } else {
                        NetworkResult.Error(apiResponse.message ?: "Unknown error")
                    }
                } ?: NetworkResult.Error("Empty response")
            } else {
                NetworkResult.Error("HTTP ${response.code()}: ${response.message()}")
            }
        } catch (e: Exception) {
            NetworkResult.Error("Network error: ${e.message}")
        }
    }

    /**
     * Manual sync trigger
     */
    fun syncNow() {
        syncScope.launch {
            syncPendingOperations()
        }
    }

    /**
     * Cleanup resources
     */
    fun cleanup() {
        syncScope.cancel()
    }
}

/**
 * Sync operation types
 */
sealed class SyncOperation {
    data class CreateBooking(val booking: BookingDomain) : SyncOperation()
    data class UpdateBooking(val booking: BookingDomain) : SyncOperation()
    data class CancelBooking(val bookingId: String) : SyncOperation()
}

/**
 * Sync state for UI feedback
 */
sealed class SyncState {
    data object Idle : SyncState()
    data object Offline : SyncState()
    data class Syncing(val message: String) : SyncState()
    data class Success(val message: String) : SyncState()
    data class Error(val message: String) : SyncState()
}
