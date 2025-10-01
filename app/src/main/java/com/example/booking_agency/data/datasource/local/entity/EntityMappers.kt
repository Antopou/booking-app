package com.example.booking_agency.data.datasource.local.entity

import com.example.booking_agency.domain.model.*
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

/**
 * Extension functions for converting between Room entities and Domain models
 */

// User mappings
fun UserEntity.toDomain(): UserDomain {
    return UserDomain(
        id = id,
        name = name,
        email = email,
        phone = phone,
        profileImage = profileImage,
        memberSince = memberSince,
        preferences = UserPreferencesDomain(
            language = language,
            currency = currency,
            notificationsEnabled = notificationsEnabled,
            darkMode = darkMode
        )
    )
}

fun UserDomain.toEntity(): UserEntity {
    return UserEntity(
        id = id,
        name = name,
        email = email,
        phone = phone,
        profileImage = profileImage,
        memberSince = memberSince,
        language = preferences.language,
        currency = preferences.currency,
        notificationsEnabled = preferences.notificationsEnabled,
        darkMode = preferences.darkMode
    )
}

// Room mappings
fun RoomEntity.toDomain(): RoomDomain {
    return RoomDomain(
        id = id,
        name = name,
        description = description,
        type = when (type.uppercase()) {
            "STANDARD" -> RoomType.STANDARD
            "DELUXE" -> RoomType.DELUXE
            "SUITE" -> RoomType.SUITE
            "PRESIDENTIAL" -> RoomType.PRESIDENTIAL
            else -> RoomType.STANDARD
        },
        pricePerNight = pricePerNight,
        hotelName = hotelName,
        location = location,
        rating = rating,
        reviewCount = reviewCount,
        images = parseJsonList(images),
        amenities = parseJsonList(amenities),
        maxGuests = maxGuests,
        size = size,
        bedType = bedType,
        isAvailable = isAvailable,
        cancellationPolicy = cancellationPolicy,
        latitude = latitude,
        longitude = longitude
    )
}

fun RoomDomain.toEntity(): RoomEntity {
    return RoomEntity(
        id = id,
        name = name,
        description = description,
        type = type.name,
        pricePerNight = pricePerNight,
        hotelName = hotelName,
        location = location,
        rating = rating,
        reviewCount = reviewCount,
        images = convertListToJson(images),
        amenities = convertListToJson(amenities),
        maxGuests = maxGuests,
        size = size,
        bedType = bedType,
        isAvailable = isAvailable,
        cancellationPolicy = cancellationPolicy,
        latitude = latitude,
        longitude = longitude
    )
}

// Booking mappings
fun BookingEntity.toDomain(): BookingDomain {
    return BookingDomain(
        id = id,
        userId = userId,
        roomId = roomId,
        roomName = roomName,
        hotelName = hotelName,
        roomType = when (roomType.uppercase()) {
            "STANDARD" -> RoomType.STANDARD
            "DELUXE" -> RoomType.DELUXE
            "SUITE" -> RoomType.SUITE
            "PRESIDENTIAL" -> RoomType.PRESIDENTIAL
            else -> RoomType.STANDARD
        },
        checkInDate = checkInDate,
        checkOutDate = checkOutDate,
        guests = guests,
        totalPrice = totalPrice,
        status = when (status.uppercase()) {
            "PENDING" -> BookingStatus.PENDING
            "CONFIRMED" -> BookingStatus.CONFIRMED
            "CANCELLED" -> BookingStatus.CANCELLED
            "COMPLETED" -> BookingStatus.COMPLETED
            else -> BookingStatus.PENDING
        },
        bookingDate = bookingDate,
        specialRequests = specialRequests,
        roomImage = roomImage
    )
}

fun BookingDomain.toEntity(): BookingEntity {
    return BookingEntity(
        id = id,
        userId = userId,
        roomId = roomId,
        roomName = roomName,
        hotelName = hotelName,
        roomType = roomType.name,
        checkInDate = checkInDate,
        checkOutDate = checkOutDate,
        guests = guests,
        totalPrice = totalPrice,
        status = status.name,
        bookingDate = bookingDate,
        specialRequests = specialRequests,
        roomImage = roomImage
    )
}

// Helper functions for JSON conversion
private val gson = Gson()

private inline fun <reified T> parseJsonList(json: String): List<T> {
    return try {
        if (json.isBlank()) emptyList()
        else gson.fromJson(json, object : TypeToken<List<T>>() {}.type)
    } catch (e: Exception) {
        emptyList()
    }
}

private fun <T> convertListToJson(list: List<T>): String {
    return try {
        gson.toJson(list)
    } catch (e: Exception) {
        "[]"
    }
}
