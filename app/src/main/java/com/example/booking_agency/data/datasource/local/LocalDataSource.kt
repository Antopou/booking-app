package com.example.booking_agency.data.datasource.local

import com.example.booking_agency.data.datasource.local.entity.BookingEntity
import com.example.booking_agency.data.datasource.local.entity.RoomEntity
import com.example.booking_agency.data.datasource.local.entity.UserEntity
import com.example.booking_agency.data.datasource.local.entity.UserSessionEntity
import com.example.booking_agency.data.datasource.local.entity.toDomain
import com.example.booking_agency.data.datasource.local.entity.toEntity
import com.example.booking_agency.domain.model.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import java.util.*

/**
 * Local data source implementation using Room Database
 * Provides offline-first data access
 */
class LocalDataSource(private val database: RoomBookerDatabase) {

    // User operations
    fun getCurrentUser(): Flow<UserDomain?> {
        return database.userDao().getCurrentUser().map { it?.toDomain() }
    }

    suspend fun getUserById(userId: String): UserDomain? {
        return database.userDao().getUserById(userId)?.toDomain()
    }

    suspend fun getUserByEmail(email: String): UserDomain? {
        return database.userDao().getUserByEmail(email)?.toDomain()
    }

    suspend fun saveUser(user: UserDomain): Long {
        return database.userDao().insertUser(user.toEntity())
    }

    suspend fun updateUser(user: UserDomain): Int {
        return database.userDao().updateUser(user.toEntity())
    }

    suspend fun deleteUser(userId: String): Int {
        return database.userDao().deleteUserById(userId)
    }

    // Room operations
    fun getAllRooms(): Flow<List<RoomEntity>> {
        return database.roomDao().getAllRooms()
    }

    suspend fun getRoomById(roomId: String): RoomEntity? {
        return database.roomDao().getRoomById(roomId)
    }

    fun getRoomsByType(type: RoomType): Flow<List<RoomEntity>> {
        return database.roomDao().getRoomsByType(type.name)
    }

    fun searchRooms(query: String): Flow<List<RoomEntity>> {
        return database.roomDao().searchRooms(query)
    }

    fun getRoomsByPriceRange(minPrice: Double, maxPrice: Double): Flow<List<RoomEntity>> {
        return database.roomDao().getRoomsByPriceRange(minPrice, maxPrice)
    }

    suspend fun saveRoom(room: RoomDomain): Long {
        return database.roomDao().insertRoom(room.toEntity())
    }

    suspend fun saveRooms(rooms: List<RoomDomain>): List<Long> {
        return database.roomDao().insertRooms(rooms.map { it.toEntity() })
    }

    suspend fun updateRoom(room: RoomDomain): Int {
        return database.roomDao().updateRoom(room.toEntity())
    }

    suspend fun deleteRoom(roomId: String): Int {
        return database.roomDao().deleteRoomById(roomId)
    }

    suspend fun deleteAllRooms(): Int {
        return database.roomDao().deleteAllRooms()
    }

    suspend fun getRoomCount(): Int {
        return database.roomDao().getRoomCount()
    }

    // Booking operations
    fun getAllBookings(): Flow<List<BookingEntity>> {
        return database.bookingDao().getAllBookings()
    }

    fun getBookingsByUserId(userId: String): Flow<List<BookingEntity>> {
        return database.bookingDao().getBookingsByUserId(userId)
    }

    suspend fun getBookingById(bookingId: String): BookingEntity? {
        return database.bookingDao().getBookingById(bookingId)
    }

    fun getBookingsByStatus(status: BookingStatus): Flow<List<BookingEntity>> {
        return database.bookingDao().getBookingsByStatus(status.name)
    }

    suspend fun saveBooking(booking: BookingDomain): Long {
        return database.bookingDao().insertBooking(booking.toEntity())
    }

    suspend fun saveBookings(bookings: List<BookingDomain>): List<Long> {
        return database.bookingDao().insertBookings(bookings.map { it.toEntity() })
    }

    suspend fun updateBooking(booking: BookingEntity): Int {
        return database.bookingDao().updateBooking(booking)
    }

    suspend fun deleteBooking(bookingId: String): Int {
        return database.bookingDao().deleteBookingById(bookingId)
    }

    suspend fun deleteAllBookings(): Int {
        return database.bookingDao().deleteAllBookings()
    }

    suspend fun cancelBooking(bookingId: String): Int {
        return database.bookingDao().cancelBooking(bookingId, Date())
    }

    // User session operations
    suspend fun getActiveSession(): UserSessionEntity? {
        return database.userSessionDao().getActiveSession()
    }

    suspend fun saveSession(userId: String): Long {
        return database.userSessionDao().insertSession(
            UserSessionEntity(
                userId = userId,
                loginTime = Date(),
                isActive = true
            )
        )
    }

    suspend fun deactivateSession(sessionId: String): Int {
        return database.userSessionDao().deactivateSession(sessionId)
    }

    suspend fun clearUserSession(): Int {
        return database.userSessionDao().clearAllSessions()
    }
}
