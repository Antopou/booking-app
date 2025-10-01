package com.example.booking_agency.models

data class User(
    val id: String = "",
    val name: String = "",
    val email: String = "",
    val phone: String = "",
    val profileImage: String = "",
    val memberSince: String = "",
    val preferences: UserPreferences = UserPreferences()
)

data class UserPreferences(
    val language: String = "en",
    val currency: String = "USD",
    val notificationsEnabled: Boolean = true,
    val darkMode: Boolean = false,
    val savedPaymentMethods: List<PaymentMethod> = emptyList()
)

data class PaymentMethod(
    val id: String = "",
    val cardType: String = "", // VISA, MASTERCARD, etc.
    val lastFour: String = "",
    val expiryDate: String = "" // MM/YY format
)

// Extension functions for User
fun User.getInitials(): String {
    return name.split(" ").take(2).joinToString("") { it.take(1).uppercase() }
}

fun User.getFirstName(): String {
    return name.split(" ").firstOrNull() ?: ""
}
