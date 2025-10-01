package com.example.booking_agency.domain.model

/**
 * Domain model for Room - represents the core business entity
 */
data class RoomDomain(
    val id: String,
    val name: String,
    val description: String,
    val type: RoomType,
    val pricePerNight: Double,
    val hotelName: String,
    val location: String,
    val rating: Float,
    val reviewCount: Int,
    val images: List<String>,
    val amenities: List<String>,
    val maxGuests: Int,
    val size: String,
    val bedType: String,
    val isAvailable: Boolean,
    val cancellationPolicy: String,
    val latitude: Double? = null,
    val longitude: Double? = null
)

enum class RoomType {
    STANDARD, DELUXE, SUITE, PRESIDENTIAL
}

/**
 * Domain model for Booking - represents booking business logic
 */
data class BookingDomain(
    val id: String,
    val userId: String,
    val roomId: String,
    val roomName: String,
    val hotelName: String,
    val roomType: RoomType,
    val checkInDate: String,
    val checkOutDate: String,
    val guests: Int,
    val totalPrice: Double,
    val status: BookingStatus,
    val bookingDate: String,
    val specialRequests: String = "",
    val roomImage: String = ""
)

enum class BookingStatus {
    PENDING, CONFIRMED, CANCELLED, COMPLETED
}

/**
 * Domain model for User - represents user business entity
 */
data class UserDomain(
    val id: String,
    val name: String,
    val email: String,
    val phone: String,
    val profileImage: String? = null,
    val memberSince: String,
    val preferences: UserPreferencesDomain = UserPreferencesDomain()
)

data class UserPreferencesDomain(
    val language: String = "en",
    val currency: String = "USD",
    val notificationsEnabled: Boolean = true,
    val darkMode: Boolean = false
)
