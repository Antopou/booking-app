package com.example.booking_agency.presentation.state

/**
 * Generic UI State for handling different states in the presentation layer
 */
sealed class UiState<out T> {
    data object Idle : UiState<Nothing>()
    data object Loading : UiState<Nothing>()
    data class Success<T>(val data: T) : UiState<T>()
    data class Error(val message: String) : UiState<Nothing>()
}

/**
 * Specific UI states for different screens
 */
data class RoomListState(
    val rooms: List<com.example.booking_agency.domain.model.RoomDomain> = emptyList(),
    val isLoading: Boolean = false,
    val error: String? = null,
    val searchQuery: String = "",
    val selectedRoomType: com.example.booking_agency.domain.model.RoomType? = null
)

data class BookingState(
    val selectedRoom: com.example.booking_agency.domain.model.RoomDomain? = null,
    val checkInDate: String = "",
    val checkOutDate: String = "",
    val guests: Int = 1,
    val specialRequests: String = "",
    val totalPrice: Double = 0.0,
    val isLoading: Boolean = false,
    val error: String? = null,
    val bookingStatus: com.example.booking_agency.domain.model.BookingStatus? = null
)

data class UserState(
    val currentUser: com.example.booking_agency.domain.model.UserDomain? = null,
    val isLoading: Boolean = false,
    val error: String? = null,
    val isLoggedIn: Boolean = false
)

/**
 * Event classes for UI interactions
 */
sealed class UiEvent {
    data class ShowError(val message: String) : UiEvent()
    data class ShowSuccess(val message: String) : UiEvent()
    data class NavigateTo(val destination: String) : UiEvent()
    data object NavigateBack : UiEvent()
    data object RefreshData : UiEvent()
}

/**
 * Loading states for different operations
 */
sealed class LoadingState {
    data object Idle : LoadingState()
    data object Loading : LoadingState()
    data class Success(val message: String? = null) : LoadingState()
    data class Error(val message: String) : LoadingState()
}
