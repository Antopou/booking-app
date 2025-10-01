package com.example.booking_agency.di

import android.content.Context
import com.example.booking_agency.data.datasource.local.LocalDataSource
import com.example.booking_agency.data.datasource.local.RoomBookerDatabase
import com.example.booking_agency.data.repository.SimpleRoomRepositoryImpl
import com.example.booking_agency.data.repository.SimpleBookingRepositoryImpl  
import com.example.booking_agency.data.repository.SimpleUserRepositoryImpl
import com.example.booking_agency.domain.repository.BookingRepository
import com.example.booking_agency.domain.repository.RoomRepository
import com.example.booking_agency.domain.repository.UserRepository
import com.example.booking_agency.domain.usecase.*
import com.example.booking_agency.presentation.viewmodel.AuthViewModel
import com.example.booking_agency.presentation.viewmodel.MainViewModel
import com.example.booking_agency.presentation.viewmodel.RoomDetailsViewModel
import com.example.booking_agency.presentation.viewmodel.RoomsViewModel
import com.example.booking_agency.utils.NetworkManager
import com.example.booking_agency.utils.OfflineDataManager
import com.example.booking_agency.utils.RetryManager
import com.example.booking_agency.utils.SyncManager

/**
 * Simple dependency injection container with offline support
 * This replaces Hilt temporarily until we implement proper DI
 */
object AppContainer {

    private lateinit var database: RoomBookerDatabase
    private lateinit var localDataSource: LocalDataSource

    private lateinit var roomRepository: RoomRepository
    private lateinit var bookingRepository: BookingRepository
    private lateinit var userRepository: UserRepository

    // Offline support
    private lateinit var networkManager: NetworkManager
    private lateinit var syncManager: SyncManager
    private lateinit var offlineDataManager: OfflineDataManager
    private lateinit var retryManager: RetryManager

    // Use Cases
    private lateinit var getAllRoomsUseCase: GetAllRoomsUseCase
    private lateinit var getRoomDetailsUseCase: GetRoomDetailsUseCase
    private lateinit var searchRoomsUseCase: SearchRoomsUseCase
    private lateinit var getRoomsByTypeUseCase: GetRoomsByTypeUseCase
    private lateinit var getUserBookingsUseCase: GetUserBookingsUseCase
    private lateinit var createBookingUseCase: CreateBookingUseCase
    private lateinit var getCurrentUserUseCase: GetCurrentUserUseCase
    private lateinit var loginUserUseCase: LoginUserUseCase
    private lateinit var registerUserUseCase: RegisterUserUseCase
    private lateinit var calculateBookingTotalUseCase: CalculateBookingTotalUseCase
    private lateinit var validateBookingDatesUseCase: ValidateBookingDatesUseCase

    fun initialize(context: Context) {
        database = RoomBookerDatabase.getInstance(context)
        localDataSource = LocalDataSource(database)

        // Initialize offline support
        networkManager = NetworkManager(context)
        retryManager = RetryManager(networkManager)

        // Create API service (mock for now)
        val apiService = object : com.example.booking_agency.data.datasource.remote.RoomBookerApiService {
            // Mock implementation - would be replaced with real Retrofit service
            override suspend fun getAllRooms() = TODO("Mock API - implement when ready")
            override suspend fun getRoomById(roomId: String) = TODO("Mock API - implement when ready")
            override suspend fun searchRooms(q: String) = TODO("Mock API - implement when ready")
            override suspend fun getRoomsByFilter(type: String?, minPrice: Double?, maxPrice: Double?, minRating: Float?, amenities: List<String>?) = TODO("Mock API - implement when ready")
            override suspend fun getAllBookings() = TODO("Mock API - implement when ready")
            override suspend fun getUserBookings(userId: String) = TODO("Mock API - implement when ready")
            override suspend fun getBookingById(bookingId: String) = TODO("Mock API - implement when ready")
            override suspend fun createBooking(bookingRequest: com.example.booking_agency.data.model.CreateBookingRequest) = TODO("Mock API - implement when ready")
            override suspend fun updateBooking(bookingId: String, booking: com.example.booking_agency.data.model.BookingApiModel) = TODO("Mock API - implement when ready")
            override suspend fun cancelBooking(bookingId: String) = TODO("Mock API - implement when ready")
            override suspend fun getCurrentUser() = TODO("Mock API - implement when ready")
            override suspend fun getUserById(userId: String) = TODO("Mock API - implement when ready")
            override suspend fun loginUser(loginRequest: com.example.booking_agency.data.model.LoginRequest) = TODO("Mock API - implement when ready")
            override suspend fun registerUser(registerRequest: com.example.booking_agency.data.model.RegisterRequest) = TODO("Mock API - implement when ready")
            override suspend fun updateUser(updateRequest: com.example.booking_agency.data.model.UpdateUserRequest) = TODO("Mock API - implement when ready")
            override suspend fun logoutUser() = TODO("Mock API - implement when ready")
            override suspend fun refreshToken() = TODO("Mock API - implement when ready")
        }

        // Initialize sync manager
        syncManager = SyncManager(apiService, localDataSource, networkManager)
        offlineDataManager = OfflineDataManager(localDataSource, syncManager, networkManager)

        // Initialize repositories
        roomRepository = SimpleRoomRepositoryImpl(localDataSource)
        bookingRepository = SimpleBookingRepositoryImpl(localDataSource)
        userRepository = SimpleUserRepositoryImpl(localDataSource)

        // Initialize use cases
        getAllRoomsUseCase = GetAllRoomsUseCase(roomRepository)
        getRoomDetailsUseCase = GetRoomDetailsUseCase(roomRepository)
        searchRoomsUseCase = SearchRoomsUseCase(roomRepository)
        getRoomsByTypeUseCase = GetRoomsByTypeUseCase(roomRepository)
        getUserBookingsUseCase = GetUserBookingsUseCase(bookingRepository)
        createBookingUseCase = CreateBookingUseCase(bookingRepository)
        getCurrentUserUseCase = GetCurrentUserUseCase(userRepository)
        loginUserUseCase = LoginUserUseCase(userRepository)
        registerUserUseCase = RegisterUserUseCase(userRepository)
        calculateBookingTotalUseCase = CalculateBookingTotalUseCase()
        validateBookingDatesUseCase = ValidateBookingDatesUseCase()
    }

    // Repository getters
    fun getRoomRepository(): RoomRepository = roomRepository
    fun getBookingRepository(): BookingRepository = bookingRepository
    fun getUserRepository(): UserRepository = userRepository

    // Offline support getters
    fun getNetworkManager(): NetworkManager = networkManager
    fun getSyncManager(): SyncManager = syncManager
    fun getOfflineDataManager(): OfflineDataManager = offlineDataManager
    fun getRetryManager(): RetryManager = retryManager

    // Use case getters
    fun getAllRoomsUseCase(): GetAllRoomsUseCase = getAllRoomsUseCase
    fun getRoomDetailsUseCase(): GetRoomDetailsUseCase = getRoomDetailsUseCase
    fun getSearchRoomsUseCase(): SearchRoomsUseCase = searchRoomsUseCase
    fun getRoomsByTypeUseCase(): GetRoomsByTypeUseCase = getRoomsByTypeUseCase
    fun getUserBookingsUseCase(): GetUserBookingsUseCase = getUserBookingsUseCase
    fun getCreateBookingUseCase(): CreateBookingUseCase = createBookingUseCase
    fun getCurrentUserUseCase(): GetCurrentUserUseCase = getCurrentUserUseCase
    fun getLoginUserUseCase(): LoginUserUseCase = loginUserUseCase
    fun getRegisterUserUseCase(): RegisterUserUseCase = registerUserUseCase
    fun getCalculateBookingTotalUseCase(): CalculateBookingTotalUseCase = calculateBookingTotalUseCase
    fun getValidateBookingDatesUseCase(): ValidateBookingDatesUseCase = validateBookingDatesUseCase

    // ViewModel factory methods
    fun createMainViewModel(): MainViewModel {
        return MainViewModel(
            getAllRoomsUseCase = getAllRoomsUseCase(),
            getCurrentUserUseCase = getCurrentUserUseCase()
        )
    }

    fun createRoomsViewModel(): RoomsViewModel {
        return RoomsViewModel(
            getRoomsByTypeUseCase = getRoomsByTypeUseCase(),
            searchRoomsUseCase = getSearchRoomsUseCase(),
            getCurrentUserUseCase = getCurrentUserUseCase()
        )
    }

    fun createRoomDetailsViewModel(): RoomDetailsViewModel {
        return RoomDetailsViewModel(
            getRoomDetailsUseCase = getRoomDetailsUseCase(),
            calculateBookingTotalUseCase = getCalculateBookingTotalUseCase(),
            validateBookingDatesUseCase = getValidateBookingDatesUseCase(),
            createBookingUseCase = getCreateBookingUseCase(),
            getCurrentUserUseCase = getCurrentUserUseCase()
        )
    }

    fun createAuthViewModel(): AuthViewModel {
        return AuthViewModel(
            loginUserUseCase = getLoginUserUseCase(),
            registerUserUseCase = getRegisterUserUseCase(),
            getCurrentUserUseCase = getCurrentUserUseCase()
        )
    }

    fun cleanup() {
        syncManager.cleanup()
    }
}
