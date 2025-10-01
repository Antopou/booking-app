package com.example.booking_agency.domain.repository

import com.example.booking_agency.domain.model.BookingDomain
import com.example.booking_agency.domain.model.RoomDomain
import com.example.booking_agency.domain.model.UserDomain
import kotlinx.coroutines.flow.Flow

/**
 * Repository interface for Room operations
 * This interface defines the contract for room data access
 */
interface RoomRepository {
    suspend fun getAllRooms(): Flow<List<RoomDomain>>
    suspend fun getRoomById(roomId: String): RoomDomain?
    suspend fun getRoomsByType(type: com.example.booking_agency.domain.model.RoomType): Flow<List<RoomDomain>>
    suspend fun searchRooms(query: String): Flow<List<RoomDomain>>
    suspend fun getRoomsByPriceRange(minPrice: Double, maxPrice: Double): Flow<List<RoomDomain>>
    suspend fun refreshRooms(): Result<Unit>
}

/**
 * Repository interface for Booking operations
 */
interface BookingRepository {
    suspend fun getAllBookings(): Flow<List<BookingDomain>>
    suspend fun getBookingsByUserId(userId: String): Flow<List<BookingDomain>>
    suspend fun getBookingById(bookingId: String): BookingDomain?
    suspend fun createBooking(booking: BookingDomain): Result<String>
    suspend fun updateBooking(booking: BookingDomain): Result<Unit>
    suspend fun cancelBooking(bookingId: String): Result<Unit>
    suspend fun refreshBookings(): Result<Unit>
}

/**
 * Repository interface for User operations
 */
interface UserRepository {
    suspend fun getCurrentUser(): Flow<UserDomain?>
    suspend fun getUserById(userId: String): UserDomain?
    suspend fun createUser(user: UserDomain): Result<String>
    suspend fun updateUser(user: UserDomain): Result<Unit>
    suspend fun loginUser(email: String, password: String): Result<UserDomain>
    suspend fun registerUser(name: String, email: String, password: String): Result<UserDomain>
    suspend fun logoutUser(): Result<Unit>
    suspend fun refreshUserProfile(): Result<Unit>
}
