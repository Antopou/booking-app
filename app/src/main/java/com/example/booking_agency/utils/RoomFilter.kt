package com.example.booking_agency.utils

import com.example.booking_agency.models.Room

class RoomFilter {
    
    fun filterRooms(
        rooms: List<Room>,
        query: String? = null,
        minPrice: Double? = null,
        maxPrice: Double? = null,
        roomType: String? = null,
        minRating: Float = 0f,
        amenities: List<String> = emptyList()
    ): List<Room> {
        return rooms.filter { room ->
            // Filter by search query
            val matchesQuery = query.isNullOrBlank() || 
                room.name.contains(query, ignoreCase = true) ||
                room.description.contains(query, ignoreCase = true) ||
                room.hotelName.contains(query, ignoreCase = true)
            
            // Filter by price range
            val matchesPrice = (minPrice == null || room.pricePerNight >= minPrice) &&
                             (maxPrice == null || room.pricePerNight <= maxPrice)
            
            // Filter by room type
            val matchesType = roomType.isNullOrBlank() || 
                             room.type.equals(roomType, ignoreCase = true)
            
            // Filter by minimum rating
            val matchesRating = room.rating >= minRating
            
            // Filter by amenities (all selected amenities must be present)
            val matchesAmenities = amenities.all { amenity ->
                room.amenities.any { it.equals(amenity, ignoreCase = true) }
            }
            
            matchesQuery && matchesPrice && matchesType && matchesRating && matchesAmenities
        }
    }
    
    fun getAvailableRoomTypes(rooms: List<Room>): List<String> {
        return rooms.map { it.type }
            .distinct()
            .sorted()
    }
    
    fun getAvailableAmenities(rooms: List<Room>): List<String> {
        return rooms.flatMap { it.amenities }
            .distinct()
            .sorted()
    }
    
    fun getPriceRange(rooms: List<Room>): Pair<Double, Double> {
        if (rooms.isEmpty()) return 0.0 to 0.0
        
        val minPrice = rooms.minOf { it.pricePerNight }
        val maxPrice = rooms.maxOf { it.pricePerNight }
        
        return minPrice to maxPrice
    }
}
