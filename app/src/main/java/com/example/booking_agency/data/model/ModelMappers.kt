package com.example.booking_agency.data.model

import com.example.booking_agency.domain.model.*

/**
 * Extension functions for converting between API models and Domain models
 */

// Room mappings
fun RoomApiModel.toDomain(): RoomDomain {
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
        images = images,
        amenities = amenities,
        maxGuests = maxGuests,
        size = size,
        bedType = bedType,
        isAvailable = isAvailable,
        cancellationPolicy = cancellationPolicy,
        latitude = latitude,
        longitude = longitude
    )
}

fun RoomDomain.toApiModel(): RoomApiModel {
    return RoomApiModel(
        id = id,
        name = name,
        description = description,
        type = type.name,
        pricePerNight = pricePerNight,
        hotelName = hotelName,
        location = location,
        rating = rating,
        reviewCount = reviewCount,
        images = images,
        amenities = amenities,
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
fun BookingApiModel.toDomain(): BookingDomain {
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

fun BookingDomain.toApiModel(): BookingApiModel {
    return BookingApiModel(
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

// User mappings
fun UserApiModel.toDomain(): UserDomain {
    return UserDomain(
        id = id,
        name = name,
        email = email,
        phone = phone,
        profileImage = profileImage,
        memberSince = memberSince,
        preferences = preferences.toDomain()
    )
}

fun UserDomain.toApiModel(): UserApiModel {
    return UserApiModel(
        id = id,
        name = name,
        email = email,
        phone = phone,
        profileImage = profileImage,
        memberSince = memberSince,
        preferences = preferences.toApiModel()
    )
}

fun UserPreferencesApiModel.toDomain(): UserPreferencesDomain {
    return UserPreferencesDomain(
        language = language,
        currency = currency,
        notificationsEnabled = notificationsEnabled,
        darkMode = darkMode
    )
}

fun UserPreferencesDomain.toApiModel(): UserPreferencesApiModel {
    return UserPreferencesApiModel(
        language = language,
        currency = currency,
        notificationsEnabled = notificationsEnabled,
        darkMode = darkMode
    )
}
