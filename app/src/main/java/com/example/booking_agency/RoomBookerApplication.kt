package com.example.booking_agency

import android.app.Application

class RoomBookerApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        // For now, just initialize without any dependencies to avoid crashes
        // TODO: Initialize dependency injection container when needed
        // AppContainer.initialize(this)
    }
}
