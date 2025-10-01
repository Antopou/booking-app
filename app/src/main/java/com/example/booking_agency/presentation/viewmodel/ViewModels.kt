package com.example.booking_agency.presentation.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.booking_agency.domain.model.*
import com.example.booking_agency.domain.usecase.*
import com.example.booking_agency.presentation.state.UiState
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

/**
 * ViewModel for Main/Home screen
 */
class MainViewModel(
    private val getAllRoomsUseCase: GetAllRoomsUseCase,
    private val getCurrentUserUseCase: GetCurrentUserUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow<UiState<MainScreenData>>(UiState.Loading)
    val uiState: StateFlow<UiState<MainScreenData>> = _uiState

    private val _currentUser = MutableStateFlow<UserDomain?>(null)
    val currentUser: StateFlow<UserDomain?> = _currentUser

    init {
        loadInitialData()
    }

    private fun loadInitialData() {
        viewModelScope.launch {
            try {
                // Load current user
                getCurrentUserUseCase().collect { user ->
                    _currentUser.value = user
                }

                // Load featured rooms
                getAllRoomsUseCase().collect { rooms ->
                    _uiState.value = UiState.Success(
                        MainScreenData(
                            featuredRooms = rooms.take(6), // Show first 6 as featured
                            totalRooms = rooms.size
                        )
                    )
                }
            } catch (e: Exception) {
                _uiState.value = UiState.Error(e.message ?: "Unknown error")
            }
        }
    }

    fun refreshData() {
        loadInitialData()
    }
}

data class MainScreenData(
    val featuredRooms: List<RoomDomain> = emptyList(),
    val totalRooms: Int = 0
)

/**
 * ViewModel for Room listing screen
 */
class RoomsViewModel(
    private val getRoomsByTypeUseCase: GetRoomsByTypeUseCase,
    private val searchRoomsUseCase: SearchRoomsUseCase,
    private val getCurrentUserUseCase: GetCurrentUserUseCase
) : ViewModel() {

    private val _roomsState = MutableStateFlow<UiState<List<RoomDomain>>>(UiState.Loading)
    val roomsState: StateFlow<UiState<List<RoomDomain>>> = _roomsState

    private val _searchQuery = MutableStateFlow("")
    val searchQuery: StateFlow<String> = _searchQuery

    private val _currentUser = MutableStateFlow<UserDomain?>(null)
    val currentUser: StateFlow<UserDomain?> = _currentUser

    private var currentRoomType: RoomType? = null

    init {
        loadCurrentUser()
    }

    private fun loadCurrentUser() {
        viewModelScope.launch {
            getCurrentUserUseCase().collect { user ->
                _currentUser.value = user
            }
        }
    }

    fun loadRoomsByType(roomType: RoomType) {
        currentRoomType = roomType
        _roomsState.value = UiState.Loading

        viewModelScope.launch {
            try {
                getRoomsByTypeUseCase(roomType).collect { rooms ->
                    _roomsState.value = UiState.Success(rooms)
                }
            } catch (e: Exception) {
                _roomsState.value = UiState.Error(e.message ?: "Failed to load rooms")
            }
        }
    }

    fun searchRooms(query: String) {
        _searchQuery.value = query
        _roomsState.value = UiState.Loading

        viewModelScope.launch {
            try {
                if (query.isBlank()) {
                    currentRoomType?.let { loadRoomsByType(it) }
                } else {
                    searchRoomsUseCase(query).collect { rooms ->
                        _roomsState.value = UiState.Success(rooms)
                    }
                }
            } catch (e: Exception) {
                _roomsState.value = UiState.Error(e.message ?: "Search failed")
            }
        }
    }

    fun refreshRooms() {
        currentRoomType?.let { loadRoomsByType(it) }
    }
}

/**
 * ViewModel for Room details screen
 */
class RoomDetailsViewModel(
    private val getRoomDetailsUseCase: GetRoomDetailsUseCase,
    private val calculateBookingTotalUseCase: CalculateBookingTotalUseCase,
    private val validateBookingDatesUseCase: ValidateBookingDatesUseCase,
    private val createBookingUseCase: CreateBookingUseCase,
    private val getCurrentUserUseCase: GetCurrentUserUseCase
) : ViewModel() {

    private val _roomState = MutableStateFlow<UiState<RoomDomain>>(UiState.Loading)
    val roomState: StateFlow<UiState<RoomDomain>> = _roomState

    private val _bookingState = MutableStateFlow<UiState<String>>(UiState.Idle)
    val bookingState: StateFlow<UiState<String>> = _bookingState

    private val _currentUser = MutableStateFlow<UserDomain?>(null)
    val currentUser: StateFlow<UserDomain?> = _currentUser

    private val _selectedCheckInDate = MutableStateFlow("")
    val selectedCheckInDate: StateFlow<String> = _selectedCheckInDate

    private val _selectedCheckOutDate = MutableStateFlow("")
    val selectedCheckOutDate: StateFlow<String> = _selectedCheckOutDate

    private val _selectedGuests = MutableStateFlow(1)
    val selectedGuests: StateFlow<Int> = _selectedGuests

    init {
        loadCurrentUser()
    }

    private fun loadCurrentUser() {
        viewModelScope.launch {
            getCurrentUserUseCase().collect { user ->
                _currentUser.value = user
            }
        }
    }

    fun loadRoomDetails(roomId: String) {
        _roomState.value = UiState.Loading

        viewModelScope.launch {
            try {
                val room = getRoomDetailsUseCase(roomId)
                if (room != null) {
                    _roomState.value = UiState.Success(room)
                } else {
                    _roomState.value = UiState.Error("Room not found")
                }
            } catch (e: Exception) {
                _roomState.value = UiState.Error(e.message ?: "Failed to load room details")
            }
        }
    }

    fun setCheckInDate(date: String) {
        _selectedCheckInDate.value = date
    }

    fun setCheckOutDate(date: String) {
        _selectedCheckOutDate.value = date
    }

    fun setGuests(count: Int) {
        _selectedGuests.value = count
    }

    fun calculateTotal(room: RoomDomain): Double {
        val nights = calculateNights()
        return calculateBookingTotalUseCase(room, nights, selectedGuests.value)
    }

    fun validateDates(): Result<Unit> {
        return validateBookingDatesUseCase(selectedCheckInDate.value, selectedCheckOutDate.value)
    }

    private fun calculateNights(): Int {
        return try {
            val checkIn = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
                .parse(selectedCheckInDate.value) ?: return 1
            val checkOut = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
                .parse(selectedCheckOutDate.value) ?: return 1

            val diff = checkOut.time - checkIn.time
            (diff / (1000 * 60 * 60 * 24)).toInt().coerceAtLeast(1)
        } catch (e: Exception) {
            1
        }
    }

    fun createBooking(room: RoomDomain, specialRequests: String = "") {
        _bookingState.value = UiState.Loading

        viewModelScope.launch {
            try {
                // Validate dates first
                validateDates().onFailure { error ->
                    _bookingState.value = UiState.Error(error.message ?: "Invalid dates")
                    return@launch
                }

                val nights = calculateNights()
                val totalPrice = calculateTotal(room)

                val booking = BookingDomain(
                    id = "booking_${System.currentTimeMillis()}",
                    userId = currentUser.value?.id ?: "",
                    roomId = room.id,
                    roomName = room.name,
                    hotelName = room.hotelName,
                    roomType = room.type,
                    checkInDate = selectedCheckInDate.value,
                    checkOutDate = selectedCheckOutDate.value,
                    guests = selectedGuests.value,
                    totalPrice = totalPrice,
                    status = BookingStatus.PENDING,
                    bookingDate = java.text.SimpleDateFormat("yyyy-MM-dd", java.util.Locale.getDefault())
                        .format(java.util.Date()),
                    specialRequests = specialRequests,
                    roomImage = room.images.firstOrNull() ?: ""
                )

                val result = createBookingUseCase(booking)
                result.fold(
                    onSuccess = { bookingId ->
                        _bookingState.value = UiState.Success("Booking created successfully")
                    },
                    onFailure = { error ->
                        _bookingState.value = UiState.Error(error.message ?: "Failed to create booking")
                    }
                )
            } catch (e: Exception) {
                _bookingState.value = UiState.Error(e.message ?: "Failed to create booking")
            }
        }
    }
}

/**
 * ViewModel for User authentication
 */
class AuthViewModel(
    private val loginUserUseCase: LoginUserUseCase,
    private val registerUserUseCase: RegisterUserUseCase,
    private val getCurrentUserUseCase: GetCurrentUserUseCase
) : ViewModel() {

    private val _authState = MutableStateFlow<UiState<UserDomain>>(UiState.Idle)
    val authState: StateFlow<UiState<UserDomain>> = _authState

    private val _currentUser = MutableStateFlow<UserDomain?>(null)
    val currentUser: StateFlow<UserDomain?> = _currentUser

    init {
        loadCurrentUser()
    }

    private fun loadCurrentUser() {
        viewModelScope.launch {
            getCurrentUserUseCase().collect { user ->
                _currentUser.value = user
                if (user != null) {
                    _authState.value = UiState.Success(user)
                }
            }
        }
    }

    fun login(email: String, password: String) {
        _authState.value = UiState.Loading

        viewModelScope.launch {
            try {
                val result = loginUserUseCase(email, password)
                result.fold(
                    onSuccess = { user ->
                        _authState.value = UiState.Success(user)
                    },
                    onFailure = { error ->
                        _authState.value = UiState.Error(error.message ?: "Login failed")
                    }
                )
            } catch (e: Exception) {
                _authState.value = UiState.Error(e.message ?: "Login failed")
            }
        }
    }

    fun register(name: String, email: String, password: String, phone: String? = null) {
        _authState.value = UiState.Loading

        viewModelScope.launch {
            try {
                val result = registerUserUseCase(name, email, password)
                result.fold(
                    onSuccess = { user ->
                        _authState.value = UiState.Success(user)
                    },
                    onFailure = { error ->
                        _authState.value = UiState.Error(error.message ?: "Registration failed")
                    }
                )
            } catch (e: Exception) {
                _authState.value = UiState.Error(e.message ?: "Registration failed")
            }
        }
    }

    fun logout() {
        _authState.value = UiState.Loading

        viewModelScope.launch {
            try {
                // Clear current user
                _currentUser.value = null
                _authState.value = UiState.Idle
            } catch (e: Exception) {
                _authState.value = UiState.Error(e.message ?: "Logout failed")
            }
        }
    }
}
