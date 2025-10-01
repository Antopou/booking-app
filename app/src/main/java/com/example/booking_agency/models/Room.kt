package com.example.booking_agency.models

data class Room(
    val id: String = "",
    val name: String = "",
    val description: String = "",
    val type: String = "", // STANDARD, DELUXE, SUITE, PRESIDENTIAL
    val pricePerNight: Double = 0.0,
    val hotelName: String = "",
    val location: String = "",
    val rating: Float = 0f,
    val reviewCount: Int = 0,
    val images: List<Int> = emptyList(),
    val amenities: List<String> = emptyList(),
    val maxGuests: Int = 2,
    val size: String = "", // e.g., "300 sq.ft"
    val bedType: String = "", // e.g., "1 King Bed"
    val isAvailable: Boolean = true,
    val cancellationPolicy: String = "Free cancellation until 24 hours before check-in",
    val thumbnail: Int = 0
) {
    // Get formatted price with currency
    fun getFormattedPrice(): String = "$${String.format("%.2f", pricePerNight)}"
    
    // Get rating as string with 1 decimal place
    fun getFormattedRating(): String = "${String.format("%.1f", rating)}"
    
    // Get first image or a default if none available
    fun getFirstImage(): Int = if (images.isNotEmpty()) images[0] else R.drawable.room_placeholder
    
    // Get room type display name
    fun getTypeDisplayName(): String = type.replaceFirstChar { it.uppercase() }
    
    // Check if room has a specific amenity
    fun hasAmenity(amenity: String): Boolean = amenities.any { it.equals(amenity, ignoreCase = true) }
}
