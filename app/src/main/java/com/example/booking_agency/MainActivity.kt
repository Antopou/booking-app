package com.example.booking_agency

import android.content.Intent
import android.os.Bundle
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.cardview.widget.CardView
import com.example.booking_agency.domain.model.RoomType

class MainActivity : AppCompatActivity() {

    private lateinit var currentUser: com.example.booking_agency.domain.model.UserDomain

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)

        // Hide the ActionBar title
        supportActionBar?.setDisplayShowTitleEnabled(false)

        // Create a simple user without any database dependency
        currentUser = com.example.booking_agency.domain.model.UserDomain(
            id = "user1",
            name = "John Doe", 
            email = "john.doe@example.com",
            phone = "+1234567890",
            profileImage = null,
            memberSince = "2024-01-15",
            preferences = com.example.booking_agency.domain.model.UserPreferencesDomain(
                language = "en",
                currency = "USD",
                notificationsEnabled = true,
                darkMode = false
            )
        )

        initializeViews()
        setupClickListeners()
    }

    private fun initializeViews() {
        // Update user name in the greeting
        val greetingName = findViewById<TextView>(R.id.greeting_name)
        greetingName?.text = "Hi ${currentUser.name.split(" ")[0]}"
    }

    private fun setupClickListeners() {
        // Set up click listeners for room categories by ID
        val catStandard = findViewById<LinearLayout>(R.id.cat_standard)
        val catDeluxe = findViewById<LinearLayout>(R.id.cat_deluxe)
        val catSuite = findViewById<LinearLayout>(R.id.cat_suite)
        val catPresidential = findViewById<LinearLayout>(R.id.cat_presidential)

        catStandard?.setOnClickListener { openRoomsActivity(RoomType.STANDARD) }
        catDeluxe?.setOnClickListener { openRoomsActivity(RoomType.DELUXE) }
        catSuite?.setOnClickListener { openRoomsActivity(RoomType.SUITE) }
        catPresidential?.setOnClickListener { openRoomsActivity(RoomType.PRESIDENTIAL) }

        // Set up click listeners for featured room cards by ID
        val featuredDeluxe = findViewById<CardView>(R.id.featured_deluxe_card)
        val featuredSuite = findViewById<CardView>(R.id.featured_suite_card)

        featuredDeluxe?.setOnClickListener { openRoomDetails("room1") }
        featuredSuite?.setOnClickListener { openRoomDetails("room2") }

        // Set up click listener for booking summary card's button
        val viewDetailsBtn = findViewById<android.view.View>(R.id.btn_view_details)
        viewDetailsBtn?.setOnClickListener { openBookingsActivity() }
    }

    private fun openRoomsActivity(roomType: RoomType) {
        val intent = Intent(this, ServicesActivity::class.java)
        intent.putExtra("roomType", roomType.name)
        intent.putExtra("userId", currentUser.id)
        startActivity(intent)
    }

    private fun openRoomDetails(roomId: String) {
        val intent = Intent(this, ServiceDetailsActivity::class.java)
        intent.putExtra("roomId", roomId)
        intent.putExtra("userId", currentUser.id)
        startActivity(intent)
    }

    private fun openBookingsActivity() {
        val intent = Intent(this, BookingsActivity::class.java)
        intent.putExtra("userId", currentUser.id)
        startActivity(intent)
    }
}
