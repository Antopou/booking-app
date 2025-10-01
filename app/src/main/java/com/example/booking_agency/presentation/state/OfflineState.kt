package com.example.booking_agency.presentation.state

import com.example.booking_agency.utils.NetworkState
import com.example.booking_agency.utils.SyncState
import kotlinx.coroutines.flow.StateFlow

/**
 * Global UI state for offline support
 */
data class OfflineUiState(
    val networkState: NetworkState = NetworkState.Unavailable,
    val syncState: SyncState = SyncState.Idle,
    val isOnline: Boolean = false,
    val pendingOperations: Int = 0,
    val lastSyncTime: Long? = null,
    val showOfflineIndicator: Boolean = false
) {
    val isOfflineMode: Boolean
        get() = networkState is NetworkState.Unavailable

    val isSyncing: Boolean
        get() = syncState is SyncState.Syncing

    val hasErrors: Boolean
        get() = syncState is SyncState.Error

    val syncMessage: String?
        get() = when (syncState) {
            is SyncState.Syncing -> syncState.message
            is SyncState.Success -> syncState.message
            is SyncState.Error -> syncState.message
            else -> null
        }
}

/**
 * ViewModel for managing offline UI state
 */
class OfflineStateViewModel(
    networkStateFlow: StateFlow<NetworkState>,
    syncStateFlow: StateFlow<SyncState>
) {

    private val _uiState = MutableStateFlow(OfflineUiState())
    val uiState: StateFlow<OfflineUiState> = _uiState

    init {
        // Combine network and sync states
        combine(networkStateFlow, syncStateFlow) { networkState, syncState ->
            OfflineUiState(
                networkState = networkState,
                syncState = syncState,
                isOnline = networkState is NetworkState.Available,
                showOfflineIndicator = networkState is NetworkState.Unavailable ||
                    syncState is SyncState.Syncing ||
                    syncState is SyncState.Error
            )
        }.collectInViewModelScope { state ->
            _uiState.value = state
        }
    }

    fun dismissSyncMessage() {
        _uiState.value = _uiState.value.copy(syncState = SyncState.Idle)
    }

    fun retrySync() {
        // Trigger sync operation
        // This would be connected to the sync manager
    }
}

/**
 * Helper function to collect flows in ViewModel scope
 * This would be replaced with actual ViewModel scope in real implementation
 */
private fun <T> Flow<T>.collectInViewModelScope(action: (T) -> Unit) {
    // In a real implementation, this would use viewModelScope
    // For now, we'll use a simple launch
    kotlinx.coroutines.GlobalScope.launch {
        collect(action)
    }
}
