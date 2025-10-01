package com.example.booking_agency

import android.app.Application
import com.example.booking_agency.di.AppContainer

class RoomBookerApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        // Initialize dependency injection container
        AppContainer.initialize(this)
    }
}
