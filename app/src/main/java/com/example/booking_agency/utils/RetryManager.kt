package com.example.booking_agency.utils

import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*
import java.util.concurrent.TimeUnit
import kotlin.math.min

/**
 * Retry manager for handling failed operations with exponential backoff
 */
class RetryManager(
    private val networkManager: NetworkManager,
    private val maxRetries: Int = 3,
    private val initialDelayMs: Long = 1000L
) {

    /**
     * Execute operation with retry logic
     */
    suspend fun <T> executeWithRetry(
        operation: suspend () -> T,
        shouldRetry: (Throwable) -> Boolean = { it is java.net.UnknownHostException || it is java.net.ConnectException },
        onRetry: (attempt: Int, error: Throwable) -> Unit = { _, _ -> }
    ): T {
        var lastError: Throwable? = null

        repeat(maxRetries) { attempt ->
            try {
                return operation()
            } catch (e: Throwable) {
                lastError = e

                if (!shouldRetry(e) || attempt == maxRetries - 1) {
                    throw e
                }

                onRetry(attempt + 1, e)

                // Wait before retry with exponential backoff
                val delay = calculateDelay(attempt)
                delay(delay)
            }
        }

        throw lastError ?: RuntimeException("Max retries exceeded")
    }

    /**
     * Execute operation with retry and network awareness
     */
    suspend fun <T> executeWithNetworkRetry(
        operation: suspend () -> T,
        onRetry: (attempt: Int, error: Throwable) -> Unit = { _, _ -> }
    ): T {
        return executeWithRetry(
            operation = operation,
            shouldRetry = { error ->
                when (error) {
                    is java.net.UnknownHostException,
                    is java.net.ConnectException,
                    is java.net.SocketTimeoutException -> {
                        // Retry network errors when we come back online
                        networkManager.networkState.first() is NetworkState.Available
                    }
                    else -> false
                }
            },
            onRetry = onRetry
        )
    }

    /**
     * Retry flow for reactive operations
     */
    fun <T> retryFlow(
        operation: () -> Flow<T>,
        shouldRetry: (Throwable) -> Boolean = { it is Exception }
    ): Flow<T> = flow {
        var attempt = 0
        var lastError: Throwable? = null

        while (attempt < maxRetries) {
            try {
                operation().collect { value ->
                    emit(value)
                }
                return@flow
            } catch (e: Throwable) {
                lastError = e
                attempt++

                if (!shouldRetry(e) || attempt >= maxRetries) {
                    throw e
                }

                // Wait before retry
                val delay = calculateDelay(attempt - 1)
                delay(delay)
            }
        }

        throw lastError ?: RuntimeException("Max retries exceeded")
    }

    /**
     * Calculate delay with exponential backoff and jitter
     */
    private fun calculateDelay(attempt: Int): Long {
        val exponentialDelay = initialDelayMs * (1L shl attempt) // 2^attempt
        val maxDelay = TimeUnit.SECONDS.toMillis(30) // Max 30 seconds
        val delayWithCap = min(exponentialDelay, maxDelay)

        // Add jitter (±25%)
        val jitterRange = (delayWithCap * 0.25).toLong()
        val jitter = (-jitterRange..jitterRange).random()

        return delayWithCap + jitter
    }

    /**
     * Wait for network connectivity before retrying
     */
    suspend fun waitForNetwork(timeoutMs: Long = 30000L): Boolean {
        return withTimeoutOrNull(timeoutMs) {
            networkManager.networkState.first { it is NetworkState.Available }
            true
        } ?: false
    }
}

/**
 * Retry configuration for different types of operations
 */
object RetryConfig {
    val NETWORK_OPERATIONS = RetryConfig(
        maxRetries = 3,
        initialDelayMs = 1000L,
        shouldRetry = { error ->
            error is java.net.UnknownHostException ||
            error is java.net.ConnectException ||
            error is java.net.SocketTimeoutException
        }
    )

    val USER_OPERATIONS = RetryConfig(
        maxRetries = 2,
        initialDelayMs = 500L,
        shouldRetry = { error ->
            error is java.net.UnknownHostException ||
            error is java.net.ConnectException
        }
    )

    val BOOKING_OPERATIONS = RetryConfig(
        maxRetries = 3,
        initialDelayMs = 2000L,
        shouldRetry = { error ->
            error is java.net.UnknownHostException ||
            error is java.net.ConnectException ||
            error is java.net.SocketTimeoutException
        }
    )
}

data class RetryConfig(
    val maxRetries: Int,
    val initialDelayMs: Long,
    val shouldRetry: (Throwable) -> Boolean
)
