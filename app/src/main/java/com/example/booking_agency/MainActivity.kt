package com.example.booking_agency

import android.content.Intent
import android.os.Bundle
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.cardview.widget.CardView
import androidx.lifecycle.lifecycleScope
import com.example.booking_agency.di.AppContainer
import com.example.booking_agency.utils.JsonDataManager
import com.example.booking_agency.domain.model.RoomType
import com.example.booking_agency.presentation.viewmodel.MainViewModel
import com.example.booking_agency.presentation.state.UiState
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {

    private lateinit var viewModel: MainViewModel
    private lateinit var dataManager: JsonDataManager
    private lateinit var currentUser: com.example.booking_agency.domain.model.UserDomain

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)

        // Hide the ActionBar title
        supportActionBar?.setDisplayShowTitleEnabled(false)

        // Initialize dependency injection
        AppContainer.initialize(this)
        viewModel = AppContainer.createMainViewModel()
        dataManager = JsonDataManager(this)

        // For demo purposes, use the first user as current user
        currentUser = dataManager.users[0]

        initializeViews()
        setupClickListeners()
        observeViewModel()
    }

    private fun initializeViews() {
        // Update user name in the greeting
        val greetingName = findViewById<TextView>(R.id.greeting_name)
        greetingName?.text = "Hi ${currentUser.name.split(" ")[0]}"
    }

    private fun observeViewModel() {
        lifecycleScope.launch {
            viewModel.uiState.collect { state ->
                when (state) {
                    is UiState.Success -> {
                        // Handle success state - data loaded
                    }
                    is UiState.Error -> {
                        // Handle error state
                    }
                    is UiState.Loading -> {
                        // Handle loading state
                    }
                    else -> {}
                }
            }
        }
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

        featuredDeluxe?.setOnClickListener { openRoomDetails("deluxe_ocean_view") }
        featuredSuite?.setOnClickListener { openRoomDetails("executive_suite") }

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
