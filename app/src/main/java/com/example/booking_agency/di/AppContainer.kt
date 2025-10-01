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

    private var database: RoomBookerDatabase? = null
    private var localDataSource: LocalDataSource? = null

    private var roomRepository: RoomRepository? = null
    private var bookingRepository: BookingRepository? = null
    private var userRepository: UserRepository? = null

    // Offline support
    private var networkManager: NetworkManager? = null
    private var syncManager: SyncManager? = null
    private var offlineDataManager: OfflineDataManager? = null
    private var retryManager: RetryManager? = null

    // Use Cases
    private var getAllRoomsUseCase: GetAllRoomsUseCase? = null
    private var getRoomDetailsUseCase: GetRoomDetailsUseCase? = null
    private var searchRoomsUseCase: SearchRoomsUseCase? = null
    private var getRoomsByTypeUseCase: GetRoomsByTypeUseCase? = null
    private var getUserBookingsUseCase: GetUserBookingsUseCase? = null
    private var createBookingUseCase: CreateBookingUseCase? = null
    private var getCurrentUserUseCase: GetCurrentUserUseCase? = null
    private var loginUserUseCase: LoginUserUseCase? = null
    private var registerUserUseCase: RegisterUserUseCase? = null
    private var calculateBookingTotalUseCase: CalculateBookingTotalUseCase? = null
    private var validateBookingDatesUseCase: ValidateBookingDatesUseCase? = null

    private var isInitialized = false

    fun initialize(context: Context) {
        if (isInitialized) return
        
        // Initialize lightweight components only
        networkManager = NetworkManager(context)
        retryManager = RetryManager(networkManager!!)
        
        // Initialize use cases that don't require database
        calculateBookingTotalUseCase = CalculateBookingTotalUseCase()
        validateBookingDatesUseCase = ValidateBookingDatesUseCase()
        
        isInitialized = true
    }
    
    suspend fun initializeDatabase(context: Context) {
        if (database == null) {
            database = RoomBookerDatabase.getInstance(context)
            localDataSource = LocalDataSource(database!!)

            // Initialize sync manager with null API service for now
            syncManager = SyncManager(null, localDataSource!!, networkManager!!)
            offlineDataManager = OfflineDataManager(localDataSource!!, syncManager!!, networkManager!!)

            // Initialize repositories
            roomRepository = SimpleRoomRepositoryImpl(localDataSource!!)
            bookingRepository = SimpleBookingRepositoryImpl(localDataSource!!)
            userRepository = SimpleUserRepositoryImpl(localDataSource!!)

            // Initialize use cases
            getAllRoomsUseCase = GetAllRoomsUseCase(roomRepository!!)
            getRoomDetailsUseCase = GetRoomDetailsUseCase(roomRepository!!)
            searchRoomsUseCase = SearchRoomsUseCase(roomRepository!!)
            getRoomsByTypeUseCase = GetRoomsByTypeUseCase(roomRepository!!)
            getUserBookingsUseCase = GetUserBookingsUseCase(bookingRepository!!)
            createBookingUseCase = CreateBookingUseCase(bookingRepository!!)
            getCurrentUserUseCase = GetCurrentUserUseCase(userRepository!!)
            loginUserUseCase = LoginUserUseCase(userRepository!!)
            registerUserUseCase = RegisterUserUseCase(userRepository!!)
        }
    }

    // Repository getters
    fun getRoomRepository(): RoomRepository = roomRepository ?: throw IllegalStateException("AppContainer not initialized")
    fun getBookingRepository(): BookingRepository = bookingRepository ?: throw IllegalStateException("AppContainer not initialized")
    fun getUserRepository(): UserRepository = userRepository ?: throw IllegalStateException("AppContainer not initialized")

    // Offline support getters
    fun getNetworkManager(): NetworkManager = networkManager ?: throw IllegalStateException("AppContainer not initialized")
    fun getSyncManager(): SyncManager = syncManager ?: throw IllegalStateException("AppContainer not initialized")
    fun getOfflineDataManager(): OfflineDataManager = offlineDataManager ?: throw IllegalStateException("AppContainer not initialized")
    fun getRetryManager(): RetryManager = retryManager ?: throw IllegalStateException("AppContainer not initialized")

    // Use case getters
    fun getAllRoomsUseCase(): GetAllRoomsUseCase = getAllRoomsUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getRoomDetailsUseCase(): GetRoomDetailsUseCase = getRoomDetailsUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getSearchRoomsUseCase(): SearchRoomsUseCase = searchRoomsUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getRoomsByTypeUseCase(): GetRoomsByTypeUseCase = getRoomsByTypeUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getUserBookingsUseCase(): GetUserBookingsUseCase = getUserBookingsUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getCreateBookingUseCase(): CreateBookingUseCase = createBookingUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getCurrentUserUseCase(): GetCurrentUserUseCase = getCurrentUserUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getLoginUserUseCase(): LoginUserUseCase = loginUserUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getRegisterUserUseCase(): RegisterUserUseCase = registerUserUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getCalculateBookingTotalUseCase(): CalculateBookingTotalUseCase = calculateBookingTotalUseCase ?: throw IllegalStateException("AppContainer not initialized")
    fun getValidateBookingDatesUseCase(): ValidateBookingDatesUseCase = validateBookingDatesUseCase ?: throw IllegalStateException("AppContainer not initialized")

    // ViewModel factory methods - simple implementations that don't require immediate database access
    fun createMainViewModel(): MainViewModel? {
        // Don't create ViewModel until database is ready
        return null
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
        syncManager?.cleanup()
    }
}
