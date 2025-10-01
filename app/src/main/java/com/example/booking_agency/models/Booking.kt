package com.example.booking_agency.models

import com.example.booking_agency.R

data class Booking(
    val id: String = "",
    val userId: String = "",
    val roomId: String = "",
    val roomName: String = "",
    val hotelName: String = "",
    val roomType: String = "",
    val checkInDate: String = "",
    val checkOutDate: String = "",
    val guests: Int = 1,
    val totalPrice: Double = 0.0,
    val status: String = "pending", // pending, confirmed, cancelled, completed
    val bookingDate: String = "",
    val specialRequests: String = "",
    val roomImage: Int = 0
) {
    // Format price with currency
    fun getFormattedPrice(): String = "$${String.format("%.2f", totalPrice)}"
    
    // Calculate number of nights
    fun getNights(): Int {
        return try {
            val format = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
            val checkIn = format.parse(checkInDate) ?: return 1
            val checkOut = format.parse(checkOutDate) ?: return 1
            val diff = checkOut.time - checkIn.time
            (diff / (1000 * 60 * 60 * 24)).toInt().coerceAtLeast(1)
        } catch (e: Exception) {
            1
        }
    }
    
    // Get status color
    fun getStatusColorRes(): Int {
        return when (status.lowercase()) {
            "confirmed" -> R.color.status_confirmed
            "pending" -> R.color.status_pending
            "cancelled" -> R.color.status_cancelled
            "completed" -> R.color.status_completed
            else -> R.color.status_pending
        }
    }
}
