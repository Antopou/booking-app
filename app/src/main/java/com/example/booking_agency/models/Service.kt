package com.example.booking_agency.models

import com.example.booking_agency.R

/**
 * Data model representing a hotel service/amenity
 */
data class Service(
    val id: String,
    val name: String,
    val description: String,
    val price: Double,
    val duration: String,
    val imageResId: Int = R.drawable.ic_service_default,
    val isAvailable: Boolean = true,
    val category: ServiceCategory = ServiceCategory.OTHER
) {
    fun getFormattedPrice(): String {
        return if (price > 0) {
            "$${"%.2f".format(price)}"
        } else {
            "Free"
        }
    }
}

enum class ServiceCategory {
    SPA, FITNESS, DINING, BUSINESS, ENTERTAINMENT, OTHER
}

object ServiceSamples {
    val sampleServices = listOf(
        Service(
            id = "spa1",
            name = "Relaxing Spa Treatment",
            description = "Full body massage with essential oils",
            price = 120.00,
            duration = "90 min",
            imageResId = R.drawable.ic_spa,
            category = ServiceCategory.SPA
        ),
        Service(
            id = "gym1",
            name = "Fitness Center Access",
            description = "24/7 access to fully equipped gym",
            price = 0.00,
            duration = "All day",
            imageResId = R.drawable.ic_fitness,
            category = ServiceCategory.FITNESS
        ),
        Service(
            id = "dining1",
            name = "Room Service",
            description = "Premium dining experience in your room",
            price = 25.00,
            duration = "30 min delivery",
            imageResId = R.drawable.ic_dining,
            category = ServiceCategory.DINING
        ),
        Service(
            id = "business1",
            name = "Business Center",
            description = "Meeting rooms and office services",
            price = 0.00,
            duration = "Available 24/7",
            imageResId = R.drawable.ic_business,
            category = ServiceCategory.BUSINESS
        )
    )
}