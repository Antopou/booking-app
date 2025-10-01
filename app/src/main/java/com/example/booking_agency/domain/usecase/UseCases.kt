package com.example.booking_agency.domain.usecase

import com.example.booking_agency.domain.model.BookingDomain
import com.example.booking_agency.domain.model.BookingStatus
import com.example.booking_agency.domain.model.RoomDomain
import com.example.booking_agency.domain.model.UserDomain
import com.example.booking_agency.domain.repository.BookingRepository
import com.example.booking_agency.domain.repository.RoomRepository
import com.example.booking_agency.domain.repository.UserRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

/**
 * Use case for getting all available rooms
 */
class GetAllRoomsUseCase(private val roomRepository: RoomRepository) {
    suspend operator fun invoke(): Flow<List<RoomDomain>> {
        return roomRepository.getAllRooms()
    }
}

/**
 * Use case for getting room details
 */
class GetRoomDetailsUseCase(private val roomRepository: RoomRepository) {
    suspend operator fun invoke(roomId: String): RoomDomain? {
        return roomRepository.getRoomById(roomId)
    }
}

/**
 * Use case for searching rooms
 */
class SearchRoomsUseCase(private val roomRepository: RoomRepository) {
    suspend operator fun invoke(query: String): Flow<List<RoomDomain>> {
        return roomRepository.searchRooms(query)
    }
}

/**
 * Use case for filtering rooms by type
 */
class GetRoomsByTypeUseCase(private val roomRepository: RoomRepository) {
    suspend operator fun invoke(type: com.example.booking_agency.domain.model.RoomType): Flow<List<RoomDomain>> {
        return roomRepository.getRoomsByType(type)
    }
}

/**
 * Use case for getting user bookings
 */
class GetUserBookingsUseCase(private val bookingRepository: BookingRepository) {
    suspend operator fun invoke(userId: String): Flow<List<BookingDomain>> {
        return bookingRepository.getBookingsByUserId(userId)
    }
}

/**
 * Use case for creating a new booking
 */
class CreateBookingUseCase(private val bookingRepository: BookingRepository) {
    suspend operator fun invoke(booking: BookingDomain): Result<String> {
        return bookingRepository.createBooking(booking)
    }
}

/**
 * Use case for getting current user
 */
class GetCurrentUserUseCase(private val userRepository: UserRepository) {
    suspend operator fun invoke(): Flow<UserDomain?> {
        return userRepository.getCurrentUser()
    }
}

/**
 * Use case for user login
 */
class LoginUserUseCase(private val userRepository: UserRepository) {
    suspend operator fun invoke(email: String, password: String): Result<UserDomain> {
        return userRepository.loginUser(email, password)
    }
}

/**
 * Use case for user registration
 */
class RegisterUserUseCase(private val userRepository: UserRepository) {
    suspend operator fun invoke(name: String, email: String, password: String): Result<UserDomain> {
        return userRepository.registerUser(name, email, password)
    }
}

/**
 * Use case for calculating booking total
 */
class CalculateBookingTotalUseCase {
    operator fun invoke(room: RoomDomain, nights: Int, guests: Int): Double {
        val basePrice = room.pricePerNight * nights
        val guestSurcharge = if (guests > room.maxGuests) (guests - room.maxGuests) * 50.0 else 0.0
        val taxes = basePrice * 0.12 // 12% tax
        return basePrice + guestSurcharge + taxes
    }
}

/**
 * Use case for validating booking dates
 */
class ValidateBookingDatesUseCase {
    operator fun invoke(checkInDate: String, checkOutDate: String): Result<Unit> {
        return try {
            val checkIn = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
                .parse(checkInDate) ?: return Result.failure(Exception("Invalid check-in date"))
            val checkOut = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
                .parse(checkOutDate) ?: return Result.failure(Exception("Invalid check-out date"))

            if (checkOut.before(checkIn) || checkOut.equals(checkIn)) {
                return Result.failure(Exception("Check-out date must be after check-in date"))
            }

            val today = java.util.Calendar.getInstance().time
            if (checkIn.before(today)) {
                return Result.failure(Exception("Check-in date cannot be in the past"))
            }

            Result.success(Unit)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
