package com.example.booking_agency.data.datasource.remote

import com.example.booking_agency.data.model.*
import retrofit2.Response
import retrofit2.http.*

/**
 * API Service interface for RoomBooker Pro
 * This interface defines all API endpoints and can be easily implemented with Retrofit
 */
interface RoomBookerApiService {

    // Room endpoints
    @GET("rooms")
    suspend fun getAllRooms(): Response<ApiResponse<List<RoomApiModel>>>

    @GET("rooms/{roomId}")
    suspend fun getRoomById(@Path("roomId") roomId: String): Response<ApiResponse<RoomApiModel>>

    @GET("rooms/search")
    suspend fun searchRooms(@Query("q") query: String): Response<ApiResponse<List<RoomApiModel>>>

    @GET("rooms/filter")
    suspend fun getRoomsByFilter(
        @Query("type") type: String? = null,
        @Query("minPrice") minPrice: Double? = null,
        @Query("maxPrice") maxPrice: Double? = null,
        @Query("minRating") minRating: Float? = null,
        @Query("amenities") amenities: List<String>? = null
    ): Response<ApiResponse<List<RoomApiModel>>>

    // Booking endpoints
    @GET("bookings")
    suspend fun getAllBookings(): Response<ApiResponse<List<BookingApiModel>>>

    @GET("users/{userId}/bookings")
    suspend fun getUserBookings(@Path("userId") userId: String): Response<ApiResponse<List<BookingApiModel>>>

    @GET("bookings/{bookingId}")
    suspend fun getBookingById(@Path("bookingId") bookingId: String): Response<ApiResponse<BookingApiModel>>

    @POST("bookings")
    suspend fun createBooking(@Body bookingRequest: CreateBookingRequest): Response<ApiResponse<String>>

    @PUT("bookings/{bookingId}")
    suspend fun updateBooking(
        @Path("bookingId") bookingId: String,
        @Body booking: BookingApiModel
    ): Response<ApiResponse<Unit>>

    @DELETE("bookings/{bookingId}")
    suspend fun cancelBooking(@Path("bookingId") bookingId: String): Response<ApiResponse<Unit>>

    // User endpoints
    @GET("users/me")
    suspend fun getCurrentUser(): Response<ApiResponse<UserApiModel>>

    @GET("users/{userId}")
    suspend fun getUserById(@Path("userId") userId: String): Response<ApiResponse<UserApiModel>>

    @POST("auth/login")
    suspend fun loginUser(@Body loginRequest: LoginRequest): Response<ApiResponse<UserApiModel>>

    @POST("auth/register")
    suspend fun registerUser(@Body registerRequest: RegisterRequest): Response<ApiResponse<UserApiModel>>

    @PUT("users/me")
    suspend fun updateUser(@Body updateRequest: UpdateUserRequest): Response<ApiResponse<UserApiModel>>

    @POST("auth/logout")
    suspend fun logoutUser(): Response<ApiResponse<Unit>>

    @POST("auth/refresh")
    suspend fun refreshToken(): Response<ApiResponse<String>>
}

/**
 * Network result wrapper for handling API responses
 */
sealed class NetworkResult<T> {
    data class Success<T>(val data: T) : NetworkResult<T>()
    data class Error<T>(val message: String, val code: Int? = null) : NetworkResult<T>()
    data class Loading<T>(val isLoading: Boolean = true) : NetworkResult<T>()
}

/**
 * API Error types
 */
enum class ApiError {
    NETWORK_ERROR,
    SERVER_ERROR,
    UNAUTHORIZED,
    NOT_FOUND,
    VALIDATION_ERROR,
    UNKNOWN_ERROR
}
