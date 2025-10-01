package com.example.booking_agency

import android.os.Bundle
import android.view.MenuItem
import android.view.View
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.core.content.ContextCompat
import androidx.viewpager2.widget.ViewPager2
import com.example.booking_agency.adapters.RoomImagePagerAdapter
import com.example.booking_agency.domain.model.RoomDomain
import com.example.booking_agency.utils.JsonDataManager
import com.google.android.material.appbar.AppBarLayout
import com.google.android.material.button.MaterialButton
import com.google.android.material.tabs.TabLayout
import com.google.android.material.tabs.TabLayoutMediator
import java.text.NumberFormat
import java.util.*

class ServiceDetailsActivity : AppCompatActivity() {

    private lateinit var room: RoomDomain
    private lateinit var dataManager: JsonDataManager
    private lateinit var viewPager: ViewPager2
    private lateinit var indicator: TabLayout
    private lateinit var bookNowButton: MaterialButton
    private lateinit var toolbar: Toolbar
    private lateinit var appBarLayout: AppBarLayout
    
    private var isFavorite = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_room_details)
        
        dataManager = JsonDataManager(this)
        
        // Get room ID from intent
        val roomId = intent.getStringExtra("roomId") ?: ""
        room = dataManager.getRoomById(roomId) ?: run {
            Toast.makeText(this, "Room not found", Toast.LENGTH_SHORT).show()
            finish()
            return
        }
        
        setupToolbar()
        initializeViews()
        setupViewPager()
        setupRoomDetails()
        setupBookNowButton()
    }
    
    private fun setupToolbar() {
        toolbar = findViewById(R.id.toolbar)
        appBarLayout = findViewById(R.id.app_bar)
        
        setSupportActionBar(toolbar)
        supportActionBar?.apply {
            setDisplayHomeAsUpEnabled(true)
            setDisplayShowHomeEnabled(true)
            title = "" // Clear title to use the one in the collapsing toolbar
        }
        
        // Set up collapsing toolbar behavior
        appBarLayout.addOnOffsetChangedListener { appBarLayout, verticalOffset ->
            val totalScrollRange = appBarLayout.totalScrollRange
            val isCollapsed = Math.abs(verticalOffset) == totalScrollRange
            
            // Show/hide toolbar title based on scroll position
            supportActionBar?.title = if (isCollapsed) room.name else ""
        }
    }
    
    private fun initializeViews() {
        viewPager = findViewById(R.id.room_images_pager)
        indicator = findViewById(R.id.indicator)
        bookNowButton = findViewById(R.id.book_now_button)
        
        // Set up favorite button
        val favoriteButton: ImageButton = findViewById(R.id.favorite_button)
        favoriteButton.setOnClickListener {
            isFavorite = !isFavorite
            updateFavoriteButton(favoriteButton)
        }
        updateFavoriteButton(favoriteButton)
    }
    
    private fun setupViewPager() {
        val adapter = RoomImagePagerAdapter(room.images.ifEmpty { listOf(R.drawable.room_placeholder) })
        viewPager.adapter = adapter
        
        // Set up indicator dots
        TabLayoutMediator(indicator, viewPager) { _, _ -> }.attach()
    }
    
    private fun setupRoomDetails() {
        // Set room details
        findViewById<TextView>(R.id.room_name).text = room.name
        findViewById<TextView>(R.id.room_location).text = room.location
        findViewById<TextView>(R.id.room_price).text = "$${String.format("%.2f", room.pricePerNight)}/night"
        findViewById<RatingBar>(R.id.room_rating).rating = room.rating
        findViewById<TextView>(R.id.room_review_count).text = "(${room.reviewCount} reviews)"
        
        // Set room features
        findViewById<TextView>(R.id.room_type).text = room.type.toString()
        findViewById<TextView>(R.id.room_size).text = room.size
        findViewById<TextView>(R.id.room_bed_type).text = room.bedType
        findViewById<TextView>(R.id.room_max_guests).text = "${room.maxGuests} guests"
        
        // Set room description
        findViewById<TextView>(R.id.room_description).text = room.description
        
        // Set up amenities
        setupAmenities()
    }
    
    private fun setupAmenities() {
        val amenitiesContainer = findViewById<LinearLayout>(R.id.amenities_container)
        amenitiesContainer.removeAllViews()
        
        room.amenities.take(6).forEach { amenity ->
            val chip = layoutInflater.inflate(
                R.layout.chip_amenity,
                amenitiesContainer,
                false
            ) as TextView
            
            chip.text = amenity
            amenitiesContainer.addView(chip)
        }
        
        // Show "+X more" if there are more amenities
        if (room.amenities.size > 6) {
            val moreChip = layoutInflater.inflate(
                R.layout.chip_amenity_more,
                amenitiesContainer,
                false
            ) as TextView
            
            moreChip.text = "+${room.amenities.size - 6} more"
            amenitiesContainer.addView(moreChip)
        }
    }
    
    private fun setupBookNowButton() {
        bookNowButton.setOnClickListener {
            // Show booking dialog or navigate to booking screen
            showBookingDialog()
        }
    }
    
    private fun showBookingDialog() {
        // Implement booking dialog
        Toast.makeText(this, "Opening booking for ${room.name}", Toast.LENGTH_SHORT).show()
    }
    
    private fun updateFavoriteButton(button: ImageButton) {
        val drawableRes = if (isFavorite) {
            R.drawable.ic_favorite_filled
        } else {
            R.drawable.ic_favorite_border
        }
        
        button.setImageResource(drawableRes)
        button.contentDescription = if (isFavorite) "Remove from favorites" else "Add to favorites"
    }
    
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == android.R.id.home) {
            onBackPressed()
            return true
        }
        return super.onOptionsItemSelected(item)
    }
}
