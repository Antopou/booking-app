package com.example.booking_agency.data.model

/**
 * API Response models - these match the expected API structure
 */
data class ApiResponse<T>(
    val success: Boolean,
    val data: T? = null,
    val message: String? = null,
    val error: String? = null
)

data class RoomApiModel(
    val id: String,
    val name: String,
    val description: String,
    val type: String, // "STANDARD", "DELUXE", "SUITE", "PRESIDENTIAL"
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

data class BookingApiModel(
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
    val status: String, // "PENDING", "CONFIRMED", "CANCELLED", "COMPLETED"
    val bookingDate: String,
    val specialRequests: String = "",
    val roomImage: String = ""
)

data class UserApiModel(
    val id: String,
    val name: String,
    val email: String,
    val phone: String,
    val profileImage: String? = null,
    val memberSince: String,
    val preferences: UserPreferencesApiModel = UserPreferencesApiModel()
)

data class UserPreferencesApiModel(
    val language: String = "en",
    val currency: String = "USD",
    val notificationsEnabled: Boolean = true,
    val darkMode: Boolean = false
)

/**
 * API Request models
 */
data class CreateBookingRequest(
    val roomId: String,
    val checkInDate: String,
    val checkOutDate: String,
    val guests: Int,
    val specialRequests: String = ""
)

data class LoginRequest(
    val email: String,
    val password: String
)

data class RegisterRequest(
    val name: String,
    val email: String,
    val password: String,
    val phone: String? = null
)

data class UpdateUserRequest(
    val name: String? = null,
    val phone: String? = null,
    val preferences: UserPreferencesApiModel? = null
)
