package com.example.booking_agency.data.repository

import com.example.booking_agency.data.datasource.local.LocalDataSource
import com.example.booking_agency.data.datasource.local.entity.toDomain
import com.example.booking_agency.data.datasource.local.entity.toEntity
import com.example.booking_agency.data.model.toApiModel
import com.example.booking_agency.data.model.toDomain as apiToDomain // keep this alias only if both have the same name
import com.example.booking_agency.data.datasource.remote.NetworkResult
import com.example.booking_agency.data.datasource.remote.RoomBookerApiService
import com.example.booking_agency.domain.model.*
import com.example.booking_agency.domain.repository.BookingRepository
import com.example.booking_agency.domain.repository.RoomRepository
import com.example.booking_agency.domain.repository.UserRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map

/**
 * Room Repository Implementation with API support
 * Handles room data from both local and remote sources
 */
class RoomRepositoryWithApiImpl(
    private val apiService: RoomBookerApiService,
    private val localDataSource: LocalDataSource
) : RoomRepository {

    override suspend fun getAllRooms(): Flow<List<RoomDomain>> {
        return try {
            when (val result = fetchRoomsFromApi()) {
                is NetworkResult.Success -> {
                    // Cache to local storage (convert API -> Domain; adjust toEntity() here if your DAO expects entities)
                    val domains = result.data.map { it.apiToDomain() }
                    localDataSource.saveRooms(domains)
                    flow { emit(domains) }
                }
                is NetworkResult.Error -> {
                    // Fallback to local data
                    localDataSource.getAllRooms().map { list -> list.map { it.toDomain() } }
                }
                is NetworkResult.Loading -> {
                    localDataSource.getAllRooms().map { list -> list.map { it.toDomain() } }
                }
            }
        } catch (_: Exception) {
            // Fallback to local data on any error
            localDataSource.getAllRooms().map { list -> list.map { it.toDomain() } }
        }
    }

    override suspend fun getRoomById(roomId: String): RoomDomain? {
        return try {
            // First try to get from local data source for quick response
            localDataSource.getRoomById(roomId)?.toDomain()?.let { localRoom ->
                // In parallel, try to fetch from API to ensure we have the latest data
                try {
                    when (val result = fetchRoomFromApi(roomId)) {
                        is NetworkResult.Success -> result.data?.apiToDomain() ?: localRoom
                        else -> localRoom
                    }
                } catch (e: Exception) {
                    localRoom
                }
            } ?: run {
                // If not found locally, try to fetch from API
                when (val result = fetchRoomFromApi(roomId)) {
                    is NetworkResult.Success -> result.data?.apiToDomain()
                    else -> null
                }
            }
        } catch (e: Exception) {
            null
        }
    }

    private suspend fun fetchRoomFromApi(roomId: String): NetworkResult<com.example.booking_agency.data.model.RoomApiModel> {
        return try {
            val response = apiService.getRoomById(roomId)
            val responseBody = response.body()
            
            if (response.isSuccessful && responseBody != null) {
                if (responseBody.success) {
                    responseBody.data?.let { room ->
                        NetworkResult.Success(room)
                    } ?: NetworkResult.Error("Room data not found")
                } else {
                    val errorMessage = responseBody.message ?: responseBody.error ?: "Unknown error occurred"
                    NetworkResult.Error(errorMessage)
                }
            } else {
                val errorMessage = when (response.code()) {
                    404 -> "Room not found"
                    401 -> "Unauthorized access"
                    500 -> "Internal server error"
                    else -> "HTTP ${response.code()} - ${response.message()}"
                }
                NetworkResult.Error(errorMessage)
            }
        } catch (e: Exception) {
            NetworkResult.Error("Failed to fetch room: ${e.message ?: "Unknown error"}")
        }
    }

    override suspend fun getRoomsByType(type: RoomType): Flow<List<RoomDomain>> {
        return localDataSource.getRoomsByType(type).map { list -> list.map { it.toDomain() } }
    }

    override suspend fun searchRooms(query: String): Flow<List<RoomDomain>> {
        return localDataSource.searchRooms(query).map { list -> list.map { it.toDomain() } }
    }

    override suspend fun getRoomsByPriceRange(minPrice: Double, maxPrice: Double): Flow<List<RoomDomain>> {
        return localDataSource.getRoomsByPriceRange(minPrice, maxPrice)
            .map { list -> list.map { it.toDomain() } }
    }

    override suspend fun refreshRooms(): Result<Unit> {
        return try {
            when (val result = fetchRoomsFromApi()) {
                is NetworkResult.Success -> {
                    val domains = result.data.map { it.apiToDomain() }
                    localDataSource.saveRooms(domains)
                    Result.success(Unit)
                }
                is NetworkResult.Error -> Result.failure(Exception(result.message))
                is NetworkResult.Loading -> Result.failure(Exception("Still loading"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

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

    private suspend fun fetchRoomFromApi(roomId: String): NetworkResult<com.example.booking_agency.data.model.RoomApiModel?> {
        return try {
            val response = apiService.getRoomById(roomId)
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
}

/**
 * Booking Repository Implementation
 */
class BookingRepositoryWithApiImpl(
    private val apiService: RoomBookerApiService,
    private val localDataSource: LocalDataSource
) : BookingRepository {

    override suspend fun getAllBookings(): Flow<List<BookingDomain>> {
        return localDataSource.getAllBookings().map { list -> list.map { it.toDomain() } }
    }

    override suspend fun getBookingsByUserId(userId: String): Flow<List<BookingDomain>> {
        return localDataSource.getBookingsByUserId(userId).map { list -> list.map { it.toDomain() } }
    }

    override suspend fun getBookingById(bookingId: String): BookingDomain? {
        return localDataSource.getBookingById(bookingId)?.toDomain()
    }

    override suspend fun createBooking(booking: BookingDomain): Result<String> {
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
                        // Save to local storage (adjust toEntity() if your DAO expects entities)
                        localDataSource.saveBooking(booking)
                        Result.success(apiResponse.data ?: "")
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

    override suspend fun updateBooking(booking: BookingDomain): Result<Unit> {
        return try {
            localDataSource.updateBooking(booking.toEntity())
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun cancelBooking(bookingId: String): Result<Unit> {
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

    override suspend fun refreshBookings(): Result<Unit> {
        // Optional: implement sync from API to local
        return Result.success(Unit)
    }
}

/**
 * User Repository Implementation
 */
class UserRepositoryWithApiImpl(
    private val apiService: RoomBookerApiService,
    private val localDataSource: LocalDataSource
) : UserRepository {

    override suspend fun getCurrentUser(): Flow<UserDomain?> {
        return localDataSource.getCurrentUser().map { it?.toDomain() }
    }

    override suspend fun getUserById(userId: String): UserDomain? {
        return localDataSource.getUserById(userId)?.toDomain()
    }

    override suspend fun createUser(user: UserDomain): Result<String> {
        return try {
            val id = localDataSource.saveUser(user)
            Result.success(id.toString())
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun updateUser(user: UserDomain): Result<Unit> {
        return try {
            localDataSource.updateUser(user)
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun loginUser(email: String, password: String): Result<UserDomain> {
        return try {
            val request = com.example.booking_agency.data.model.LoginRequest(email, password)
            val response = apiService.loginUser(request)

            if (response.isSuccessful) {
                response.body()?.let { apiResponse ->
                    if (apiResponse.success && apiResponse.data != null) {
                        val user = apiResponse.data.apiToDomain()
                        localDataSource.saveUser(user.toEntity())
                        Result.success(user)
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

    override suspend fun registerUser(name: String, email: String, password: String): Result<UserDomain> {
        return try {
            val request = com.example.booking_agency.data.model.RegisterRequest(name, email, password)
            val response = apiService.registerUser(request)

            if (response.isSuccessful) {
                response.body()?.let { apiResponse ->
                    if (apiResponse.success && apiResponse.data != null) {
                        val user = apiResponse.data.apiToDomain()
                        localDataSource.saveUser(user.toEntity())
                        Result.success(user)
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

    override suspend fun logoutUser(): Result<Unit> {
        return try {
            val response = apiService.logoutUser()
            if (response.isSuccessful) {
                localDataSource.clearUserSession()
                Result.success(Unit)
            } else {
                Result.failure(Exception("Logout failed"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun refreshUserProfile(): Result<Unit> {
        return try {
            val response = apiService.getCurrentUser()
            if (response.isSuccessful) {
                response.body()?.let { apiResponse ->
                    if (apiResponse.success && apiResponse.data != null) {
                        localDataSource.saveUser(apiResponse.data.apiToDomain().toEntity())
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
}
