package com.example.booking_agency.utils

import com.example.booking_agency.data.datasource.local.LocalDataSource
import com.example.booking_agency.data.datasource.local.entity.toDomain
import com.example.booking_agency.data.datasource.local.entity.toEntity
import com.example.booking_agency.domain.model.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.map

/**
 * Offline-first data manager
 * Handles data operations with offline support and sync capabilities
 */
class OfflineDataManager(
    private val localDataSource: LocalDataSource,
    private val syncManager: SyncManager,
    private val networkManager: NetworkManager
) {

    /**
     * Get all rooms with offline support
     */
    fun getAllRooms(): Flow<DataState<List<RoomDomain>>> {
        return combine(
            localDataSource.getAllRooms().map { entities ->
                entities.map { it.toDomain() }
            },
            networkManager.networkState,
            syncManager.syncState
        ) { rooms, networkState, syncState ->
            when {
                syncState is SyncState.Syncing -> DataState.Loading(rooms, "Syncing data...")
                syncState is SyncState.Error -> DataState.Error(syncState.message, rooms)
                networkState is NetworkState.Unavailable -> DataState.Offline(rooms)
                else -> DataState.Success(rooms)
            }
        }
    }

    /**
     * Get room by ID with offline support
     */
    suspend fun getRoomById(roomId: String): DataState<RoomDomain?> {
        return try {
            val room = localDataSource.getRoomById(roomId)?.toDomain()
            if (networkManager.isOnline()) {
                DataState.Success(room)
            } else {
                DataState.Offline(room)
            }
        } catch (e: Exception) {
            DataState.Error("Failed to load room: ${e.message}", null)
        }
    }

    /**
     * Create booking with offline support
     */
    suspend fun createBooking(booking: BookingDomain): DataState<String> {
        return try {
            // Save locally first (offline-first)
            localDataSource.saveBooking(booking)

            // Try to sync with server if online
            if (networkManager.isOnline()) {
                syncManager.queueBookingCreation(booking)
                DataState.Success(booking.id)
            } else {
                DataState.Offline(booking.id, "Booking saved offline. Will sync when online.")
            }
        } catch (e: Exception) {
            DataState.Error("Failed to create booking: ${e.message}", null)
        }
    }

    /**
     * Update booking with offline support
     */
    suspend fun updateBooking(booking: BookingDomain): DataState<Unit> {
        return try {
            // Save locally first
            localDataSource.updateBooking(booking.toEntity())

            // Try to sync if online
            if (networkManager.isOnline()) {
                syncManager.queueBookingUpdate(booking)
                DataState.Success(Unit)
            } else {
                DataState.Offline(Unit, "Booking updated offline. Will sync when online.")
            }
        } catch (e: Exception) {
            DataState.Error("Failed to update booking: ${e.message}", Unit)
        }
    }

    /**
     * Cancel booking with offline support
     */
    suspend fun cancelBooking(bookingId: String): DataState<Unit> {
        return try {
            // Update locally first
            localDataSource.cancelBooking(bookingId)

            // Try to sync if online
            if (networkManager.isOnline()) {
                syncManager.queueBookingCancellation(bookingId)
                DataState.Success(Unit)
            } else {
                DataState.Offline(Unit, "Booking cancelled offline. Will sync when online.")
            }
        } catch (e: Exception) {
            DataState.Error("Failed to cancel booking: ${e.message}", Unit)
        }
    }

    /**
     * Get user bookings with offline support
     */
    fun getUserBookings(userId: String): Flow<DataState<List<BookingDomain>>> {
        return combine(
            localDataSource.getBookingsByUserId(userId).map { entities ->
                entities.map { it.toDomain() }
            },
            networkManager.networkState,
            syncManager.syncState
        ) { bookings, networkState, syncState ->
            when {
                syncState is SyncState.Syncing -> DataState.Loading(bookings, "Syncing bookings...")
                syncState is SyncState.Error -> DataState.Error(syncState.message, bookings)
                networkState is NetworkState.Unavailable -> DataState.Offline(bookings)
                else -> DataState.Success(bookings)
            }
        }
    }

    /**
     * Search rooms with offline support
     */
    fun searchRooms(query: String): Flow<DataState<List<RoomDomain>>> {
        return combine(
            localDataSource.searchRooms(query).map { entities ->
                entities.map { it.toDomain() }
            },
            networkManager.networkState
        ) { rooms, networkState ->
            when (networkState) {
                NetworkState.Unavailable -> DataState.Offline(rooms)
                else -> DataState.Success(rooms)
            }
        }
    }

    /**
     * Get rooms by type with offline support
     */
    fun getRoomsByType(type: RoomType): Flow<DataState<List<RoomDomain>>> {
        return combine(
            localDataSource.getRoomsByType(type).map { entities ->
                entities.map { it.toDomain() }
            },
            networkManager.networkState
        ) { rooms, networkState ->
            when (networkState) {
                NetworkState.Unavailable -> DataState.Offline(rooms)
                else -> DataState.Success(rooms)
            }
        }
    }

    /**
     * Sync data manually
     */
    fun syncNow() {
        syncManager.syncNow()
    }

    /**
     * Check if currently online
     */
    fun isOnline(): Boolean = networkManager.isOnline()

    /**
     * Get current sync state
     */
    val syncState: Flow<SyncState> = syncManager.syncState

    /**
     * Get current network state
     */
    val networkState: Flow<NetworkState> = networkManager.networkState
}

/**
 * Data state for offline-first operations
 */
sealed class DataState<T> {
    data class Success<T>(val data: T) : DataState<T>()
    data class Loading<T>(val data: T? = null, val message: String = "Loading...") : DataState<T>()
    data class Error<T>(val message: String, val data: T? = null) : DataState<T>()
    data class Offline<T>(val data: T? = null, val message: String = "Offline mode") : DataState<T>()
}
