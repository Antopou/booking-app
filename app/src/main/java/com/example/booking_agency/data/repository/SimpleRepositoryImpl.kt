package com.example.booking_agency.data.repository

import com.example.booking_agency.data.datasource.local.LocalDataSource
import com.example.booking_agency.data.datasource.local.entity.toDomain
import com.example.booking_agency.data.datasource.local.entity.toEntity
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
 * Simple Repository implementation using only local data source
 * This is a lightweight version for offline-first functionality
 */
class SimpleRoomRepositoryImpl(
    private val localDataSource: LocalDataSource
) : RoomRepository {

    override suspend fun getAllRooms(): Flow<List<RoomDomain>> {
        return localDataSource.getAllRooms().map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override suspend fun getRoomById(roomId: String): RoomDomain? {
        return localDataSource.getRoomById(roomId)?.toDomain()
    }

    override suspend fun getRoomsByType(type: RoomType): Flow<List<RoomDomain>> {
        return localDataSource.getRoomsByType(type).map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override suspend fun searchRooms(query: String): Flow<List<RoomDomain>> {
        return localDataSource.searchRooms(query).map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override suspend fun getRoomsByPriceRange(minPrice: Double, maxPrice: Double): Flow<List<RoomDomain>> {
        return localDataSource.getRoomsByPriceRange(minPrice, maxPrice).map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override suspend fun refreshRooms(): Result<Unit> {
        // For now, just return success - no API integration yet
        return Result.success(Unit)
    }
}

/**
 * Simple Booking Repository implementation using only local data source
 */
class SimpleBookingRepositoryImpl(
    private val localDataSource: LocalDataSource
) : BookingRepository {

    override suspend fun getAllBookings(): Flow<List<BookingDomain>> {
        return localDataSource.getAllBookings().map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override suspend fun getBookingsByUserId(userId: String): Flow<List<BookingDomain>> {
        return localDataSource.getBookingsByUserId(userId).map { entities ->
            entities.map { it.toDomain() }
        }
    }

    override suspend fun getBookingById(bookingId: String): BookingDomain? {
        return localDataSource.getBookingById(bookingId)?.toDomain()
    }

    override suspend fun createBooking(booking: BookingDomain): Result<String> {
        return try {
            localDataSource.saveBooking(booking)
            Result.success(booking.id)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun updateBooking(booking: BookingDomain): Result<Unit> {
        return try {
            // Convert domain to entity and update
            val entity = com.example.booking_agency.data.datasource.local.entity.BookingEntity(
                id = booking.id,
                userId = booking.userId,
                roomId = booking.roomId,
                roomName = booking.roomName,
                hotelName = booking.hotelName,
                roomType = booking.roomType.name,
                checkInDate = booking.checkInDate,
                checkOutDate = booking.checkOutDate,
                guests = booking.guests,
                totalPrice = booking.totalPrice,
                status = booking.status.name,
                bookingDate = booking.bookingDate,
                specialRequests = booking.specialRequests,
                roomImage = booking.roomImage
            )
            localDataSource.updateBooking(entity)
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun cancelBooking(bookingId: String): Result<Unit> {
        return try {
            localDataSource.cancelBooking(bookingId)
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun refreshBookings(): Result<Unit> {
        return Result.success(Unit)
    }
}

/**
 * Simple User Repository implementation using only local data source
 * Provides basic user management functionality for offline scenarios
 */
class SimpleUserRepositoryImpl(
    private val localDataSource: LocalDataSource
) : UserRepository {

    override suspend fun getCurrentUser(): Flow<UserDomain?> {
        return localDataSource.getCurrentUser()
    }

    override suspend fun getUserById(userId: String): UserDomain? {
        return localDataSource.getUserById(userId)
    }

    override suspend fun createUser(user: UserDomain): Result<String> {
        return try {
            localDataSource.saveUser(user)
            Result.success(user.id)
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
        // For demo purposes, just return the first user if email matches
        return try {
            val user = localDataSource.getUserByEmail(email)
            if (user != null) {
                Result.success(user)
            } else {
                Result.failure(Exception("User not found"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun registerUser(name: String, email: String, password: String): Result<UserDomain> {
        return try {
            val user = UserDomain(
                id = "user_${System.currentTimeMillis()}",
                name = name,
                email = email,
                phone = "",
                memberSince = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
                    .format(java.util.Date())
            )
            localDataSource.saveUser(user)
            Result.success(user)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun logoutUser(): Result<Unit> {
        return try {
            localDataSource.clearUserSession()
            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    override suspend fun refreshUserProfile(): Result<Unit> {
        return Result.success(Unit)
    }
}
