package com.example.booking_agency.data.datasource.local.entity

import androidx.room.*
import java.util.*

/**
 * Room entity for User
 */
@Entity(tableName = "users")
data class UserEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val email: String,
    val phone: String,
    val profileImage: String? = null,
    val memberSince: String,
    val language: String = "en",
    val currency: String = "USD",
    val notificationsEnabled: Boolean = true,
    val darkMode: Boolean = false,
    val createdAt: Date = Date(),
    val updatedAt: Date = Date()
)

/**
 * Room entity for Room
 */
@Entity(tableName = "rooms")
data class RoomEntity(
    @PrimaryKey
    val id: String,
    val name: String,
    val description: String,
    val type: String, // STANDARD, DELUXE, SUITE, PRESIDENTIAL
    val pricePerNight: Double,
    val hotelName: String,
    val location: String,
    val rating: Float,
    val reviewCount: Int,
    val images: String, // JSON string of image URLs
    val amenities: String, // JSON string of amenities list
    val maxGuests: Int,
    val size: String,
    val bedType: String,
    val isAvailable: Boolean,
    val cancellationPolicy: String,
    val latitude: Double? = null,
    val longitude: Double? = null,
    val createdAt: Date = Date(),
    val updatedAt: Date = Date()
)

/**
 * Room entity for Booking
 */
@Entity(
    tableName = "bookings",
    foreignKeys = [
        ForeignKey(
            entity = UserEntity::class,
            parentColumns = ["id"],
            childColumns = ["userId"],
            onDelete = ForeignKey.CASCADE
        ),
        ForeignKey(
            entity = RoomEntity::class,
            parentColumns = ["id"],
            childColumns = ["roomId"],
            onDelete = ForeignKey.CASCADE
        )
    ],
    indices = [
        Index(value = ["userId"]),
        Index(value = ["roomId"]),
        Index(value = ["status"])
    ]
)
data class BookingEntity(
    @PrimaryKey
    val id: String,
    val userId: String,
    val roomId: String,
    val roomName: String,
    val hotelName: String,
    val roomType: String,
    val checkInDate: String,
    val checkOutDate: String,
    val guests: Int,
    val totalPrice: Double,
    val status: String, // PENDING, CONFIRMED, CANCELLED, COMPLETED
    val bookingDate: String,
    val specialRequests: String = "",
    val roomImage: String = "",
    val createdAt: Date = Date(),
    val updatedAt: Date = Date()
)

/**
 * Room entity for storing user session
 */
@Entity(tableName = "user_session")
data class UserSessionEntity(
    @PrimaryKey
    val id: String = "current_session",
    val userId: String,
    val loginTime: Date,
    val isActive: Boolean = true
)
