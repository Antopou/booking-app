package com.example.booking_agency.utils

import android.content.Context
import com.example.booking_agency.data.datasource.local.LocalDataSource
import com.example.booking_agency.data.datasource.local.RoomBookerDatabase
import com.example.booking_agency.domain.model.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.map
import java.text.SimpleDateFormat
import java.util.*

/**
 * Updated JsonDataManager that now uses Room Database
 * Provides sample data and manages data operations
 */
class JsonDataManager(private val context: Context) {

    private val database = RoomBookerDatabase.getInstance(context)
    private val localDataSource = LocalDataSource(database)

    // Sample data properties
    val users: List<UserDomain>
    val rooms: List<RoomDomain>
    val bookings: List<BookingDomain>

    init {
        // Initialize with sample data if database is empty
        users = createSampleUsers()
        rooms = createSampleRooms()
        bookings = createSampleBookings()

        // Populate database with sample data if empty
        populateDatabaseIfEmpty()
    }

    // User operations
    fun getUsers(): List<UserDomain> = users

    fun getUserById(userId: String): UserDomain? {
        return users.find { it.id == userId }
    }

    // Room operations
    fun getRooms(): List<RoomDomain> = rooms

    fun getRoomById(roomId: String): RoomDomain? {
        return rooms.find { it.id == roomId }
    }

    fun getRoomsByType(type: RoomType): List<RoomDomain> {
        return rooms.filter { it.type == type }
    }

    // Booking operations
    fun getBookings(): List<BookingDomain> = bookings

    fun getBookingsByUserId(userId: String): List<BookingDomain> {
        return bookings.filter { it.userId == userId }
    }

    fun getBookingById(bookingId: String): BookingDomain? {
        return bookings.find { it.id == bookingId }
    }

    // Database operations
    suspend fun saveUser(user: UserDomain) {
        localDataSource.saveUser(user)
    }

    suspend fun saveRoom(room: RoomDomain) {
        localDataSource.saveRoom(room)
    }

    suspend fun saveBooking(booking: BookingDomain) {
        localDataSource.saveBooking(booking)
    }

    fun getAllRoomsFlow(): Flow<List<RoomDomain>> {
        return localDataSource.getAllRooms().map { entities ->
            entities.map { it.toDomain() }
        }
    }

    fun getBookingsByUserIdFlow(userId: String): Flow<List<BookingDomain>> {
        return localDataSource.getBookingsByUserId(userId).map { entities ->
            entities.map { it.toDomain() }
        }
    }

    private fun populateDatabaseIfEmpty() {
        // This would be called during app initialization
        // For now, we'll just ensure sample data exists
    }

    private fun createSampleUsers(): List<UserDomain> {
        return listOf(
            UserDomain(
                id = "user1",
                name = "John Doe",
                email = "john.doe@example.com",
                phone = "+1234567890",
                profileImage = null,
                memberSince = "2024-01-15",
                preferences = UserPreferencesDomain(
                    language = "en",
                    currency = "USD",
                    notificationsEnabled = true,
                    darkMode = false
                )
            ),
            UserDomain(
                id = "user2",
                name = "Jane Smith",
                email = "jane.smith@example.com",
                phone = "+1234567891",
                profileImage = null,
                memberSince = "2024-02-20",
                preferences = UserPreferencesDomain(
                    language = "en",
                    currency = "USD",
                    notificationsEnabled = true,
                    darkMode = true
                )
            )
        )
    }

    private fun createSampleRooms(): List<RoomDomain> {
        return listOf(
            RoomDomain(
                id = "room1",
                name = "Deluxe Ocean View",
                description = "Spacious room with a stunning ocean view, perfect for a relaxing vacation. Features modern amenities and premium bedding.",
                type = RoomType.DELUXE,
                pricePerNight = 199.99,
                hotelName = "Luxury Beach Resort",
                location = "Miami Beach, FL",
                rating = 4.7f,
                reviewCount = 128,
                images = listOf(
                    "https://example.com/room1_1.jpg",
                    "https://example.com/room1_2.jpg",
                    "https://example.com/room1_3.jpg"
                ),
                amenities = listOf(
                    "Free WiFi",
                    "Air Conditioning",
                    "Ocean View",
                    "King Size Bed",
                    "Private Balcony",
                    "Minibar",
                    "Room Service",
                    "Flat Screen TV"
                ),
                maxGuests = 2,
                size = "450 sq.ft",
                bedType = "1 King Bed",
                isAvailable = true,
                cancellationPolicy = "Free cancellation until 24 hours before check-in"
            ),
            RoomDomain(
                id = "room2",
                name = "Executive Suite",
                description = "Luxurious suite with separate living area and premium amenities. Ideal for business travelers or couples seeking extra space.",
                type = RoomType.SUITE,
                pricePerNight = 299.99,
                hotelName = "Grand City Hotel",
                location = "New York, NY",
                rating = 4.8f,
                reviewCount = 215,
                images = listOf(
                    "https://example.com/room2_1.jpg",
                    "https://example.com/room2_2.jpg"
                ),
                amenities = listOf(
                    "Free WiFi",
                    "Air Conditioning",
                    "City View",
                    "King Size Bed",
                    "Living Area",
                    "Work Desk",
                    "Minibar",
                    "Room Service",
                    "Premium Toiletries"
                ),
                maxGuests = 3,
                size = "650 sq.ft",
                bedType = "1 King Bed, 1 Sofa Bed",
                isAvailable = true,
                cancellationPolicy = "Free cancellation until 48 hours before check-in"
            ),
            RoomDomain(
                id = "room3",
                name = "Standard Room",
                description = "Comfortable and affordable room perfect for budget-conscious travelers. Clean, modern, and well-maintained.",
                type = RoomType.STANDARD,
                pricePerNight = 89.99,
                hotelName = "Comfort Inn",
                location = "Chicago, IL",
                rating = 4.2f,
                reviewCount = 89,
                images = listOf(
                    "https://example.com/room3_1.jpg"
                ),
                amenities = listOf(
                    "Free WiFi",
                    "Air Conditioning",
                    "Queen Size Bed",
                    "TV",
                    "Basic Toiletries"
                ),
                maxGuests = 2,
                size = "300 sq.ft",
                bedType = "1 Queen Bed",
                isAvailable = true,
                cancellationPolicy = "Free cancellation until 24 hours before check-in"
            ),
            RoomDomain(
                id = "room4",
                name = "Presidential Suite",
                description = "Ultimate luxury experience with panoramic views, premium services, and exclusive amenities. Perfect for special occasions.",
                type = RoomType.PRESIDENTIAL,
                pricePerNight = 899.99,
                hotelName = "Royal Palace Hotel",
                location = "Las Vegas, NV",
                rating = 4.9f,
                reviewCount = 45,
                images = listOf(
                    "https://example.com/room4_1.jpg",
                    "https://example.com/room4_2.jpg",
                    "https://example.com/room4_3.jpg"
                ),
                amenities = listOf(
                    "Free WiFi",
                    "Air Conditioning",
                    "Panoramic View",
                    "King Size Bed",
                    "Living Area",
                    "Dining Area",
                    "Private Butler",
                    "Champagne",
                    "Jacuzzi",
                    "Premium Sound System",
                    "24/7 Room Service"
                ),
                maxGuests = 4,
                size = "1200 sq.ft",
                bedType = "1 King Bed, 2 Queen Beds",
                isAvailable = true,
                cancellationPolicy = "Free cancellation until 72 hours before check-in"
            )
        )
    }

    private fun createSampleBookings(): List<BookingDomain> {
        val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
        val today = Calendar.getInstance()
        val checkIn = Calendar.getInstance().apply { add(Calendar.DAY_OF_MONTH, 7) }
        val checkOut = Calendar.getInstance().apply { add(Calendar.DAY_OF_MONTH, 14) }

        return listOf(
            BookingDomain(
                id = "book1",
                userId = "user1",
                roomId = "room1",
                roomName = "Deluxe Ocean View",
                hotelName = "Luxury Beach Resort",
                roomType = RoomType.DELUXE,
                checkInDate = dateFormat.format(checkIn.time),
                checkOutDate = dateFormat.format(checkOut.time),
                guests = 2,
                totalPrice = 1399.93,
                status = BookingStatus.CONFIRMED,
                bookingDate = dateFormat.format(today.time),
                specialRequests = "High floor preferred, ocean view guaranteed",
                roomImage = "https://example.com/room1_1.jpg"
            ),
            BookingDomain(
                id = "book2",
                userId = "user1",
                roomId = "room3",
                roomName = "Standard Room",
                hotelName = "Comfort Inn",
                roomType = RoomType.STANDARD,
                checkInDate = dateFormat.format(checkIn.time),
                checkOutDate = dateFormat.format(checkOut.time),
                guests = 1,
                totalPrice = 629.93,
                status = BookingStatus.PENDING,
                bookingDate = dateFormat.format(today.time),
                specialRequests = "Quiet room preferred",
                roomImage = "https://example.com/room3_1.jpg"
            )
        )
    }
}
