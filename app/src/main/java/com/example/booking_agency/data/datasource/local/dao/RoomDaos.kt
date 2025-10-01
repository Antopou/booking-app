package com.example.booking_agency.data.datasource.local.dao

import androidx.room.*
import com.example.booking_agency.data.datasource.local.entity.BookingEntity
import com.example.booking_agency.data.datasource.local.entity.RoomEntity
import com.example.booking_agency.data.datasource.local.entity.UserEntity
import com.example.booking_agency.data.datasource.local.entity.UserSessionEntity
import kotlinx.coroutines.flow.Flow
import java.util.Date

/**
 * Data Access Object for User operations
 */
@Dao
interface UserDao {

    @Query("SELECT * FROM users WHERE id = :userId")
    suspend fun getUserById(userId: String): UserEntity?

    @Query("SELECT * FROM users WHERE email = :email")
    suspend fun getUserByEmail(email: String): UserEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertUser(user: UserEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun createUser(user: UserEntity): Long

    @Update
    suspend fun updateUser(user: UserEntity): Int

    @Delete
    suspend fun deleteUser(user: UserEntity): Int

    @Query("SELECT * FROM users LIMIT 1") // For demo, get first user
    fun getCurrentUser(): Flow<UserEntity?>

    @Query("DELETE FROM users WHERE id = :userId")
    suspend fun deleteUserById(userId: String): Int
}

/**
 * Data Access Object for Room operations
 */
@Dao
interface RoomDao {

    @Query("SELECT * FROM rooms")
    fun getAllRooms(): Flow<List<RoomEntity>>

    @Query("SELECT * FROM rooms WHERE id = :roomId")
    suspend fun getRoomById(roomId: String): RoomEntity?

    @Query("SELECT * FROM rooms WHERE type = :type")
    fun getRoomsByType(type: String): Flow<List<RoomEntity>>

    @Query("SELECT * FROM rooms WHERE name LIKE '%' || :query || '%' OR description LIKE '%' || :query || '%' OR hotelName LIKE '%' || :query || '%'")
    fun searchRooms(query: String): Flow<List<RoomEntity>>

    @Query("SELECT * FROM rooms WHERE pricePerNight BETWEEN :minPrice AND :maxPrice")
    fun getRoomsByPriceRange(minPrice: Double, maxPrice: Double): Flow<List<RoomEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertRoom(room: RoomEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertRooms(rooms: List<RoomEntity>): List<Long>

    @Update
    suspend fun updateRoom(room: RoomEntity): Int

    @Delete
    suspend fun deleteRoom(room: RoomEntity): Int

    @Query("DELETE FROM rooms")
    suspend fun deleteAllRooms(): Int

    @Query("DELETE FROM rooms WHERE id = :roomId")
    suspend fun deleteRoomById(roomId: String): Int

    @Query("SELECT COUNT(*) FROM rooms")
    suspend fun getRoomCount(): Int
}

/**
 * Data Access Object for Booking operations
 */
@Dao
interface BookingDao {

    @Query("SELECT * FROM bookings")
    fun getAllBookings(): Flow<List<BookingEntity>>

    @Query("SELECT * FROM bookings WHERE userId = :userId")
    fun getBookingsByUserId(userId: String): Flow<List<BookingEntity>>

    @Query("SELECT * FROM bookings WHERE id = :bookingId")
    suspend fun getBookingById(bookingId: String): BookingEntity?

    @Query("SELECT * FROM bookings WHERE status = :status")
    fun getBookingsByStatus(status: String): Flow<List<BookingEntity>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertBooking(booking: BookingEntity): Long

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertBookings(bookings: List<BookingEntity>): List<Long>

    @Update
    suspend fun updateBooking(booking: BookingEntity): Int

    @Delete
    suspend fun deleteBooking(booking: BookingEntity): Int

    @Query("DELETE FROM bookings WHERE id = :bookingId")
    suspend fun deleteBookingById(bookingId: String): Int

    @Query("DELETE FROM bookings")
    suspend fun deleteAllBookings(): Int

    @Query("UPDATE bookings SET status = 'CANCELLED', updatedAt = :updatedAt WHERE id = :bookingId")
    suspend fun cancelBooking(bookingId: String, updatedAt: Date): Int
}

/**
 * Data Access Object for User Session operations
 */
@Dao
interface UserSessionDao {

    @Query("SELECT * FROM user_session WHERE isActive = 1 LIMIT 1")
    suspend fun getActiveSession(): UserSessionEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSession(session: UserSessionEntity): Long

    @Update
    suspend fun updateSession(session: UserSessionEntity): Int

    @Query("UPDATE user_session SET isActive = 0 WHERE id = :sessionId")
    suspend fun deactivateSession(sessionId: String): Int

    @Query("DELETE FROM user_session")
    suspend fun clearAllSessions(): Int
}
