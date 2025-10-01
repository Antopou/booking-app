package com.example.booking_agency

import android.content.Intent
import android.graphics.Rect
import android.os.Bundle
import android.view.View
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.booking_agency.adapters.BookingAdapter
import com.example.booking_agency.domain.model.BookingDomain
import com.example.booking_agency.utils.JsonDataManager

class BookingsActivity : AppCompatActivity(), BookingAdapter.OnBookingActionListener {

    private lateinit var recyclerView: RecyclerView
    private var adapter: BookingAdapter? = null
    private lateinit var dataManager: JsonDataManager
    private var progressBar: ProgressBar? = null
    private var emptyStateText: TextView? = null
    private var userId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_bookings)

        // Set up toolbar
        val toolbar = findViewById<Toolbar>(R.id.toolbar)
        toolbar?.let {
            setSupportActionBar(it)
            supportActionBar?.apply {
                setDisplayHomeAsUpEnabled(true)
                setDisplayShowHomeEnabled(true)
                title = "My Bookings"
            }
            it.setNavigationOnClickListener { onBackPressed() }
        }

        userId = intent.getStringExtra("userId")
        dataManager = JsonDataManager(this)

        initializeViews()
        setupRecyclerView()
        loadBookings()
    }

    private fun initializeViews() {
        recyclerView = findViewById(R.id.bookings_recycler)
        progressBar = findViewById(R.id.progress_bar)
        emptyStateText = findViewById(R.id.empty_state_text)
    }

    private fun setupRecyclerView() {
        val layoutManager = LinearLayoutManager(this)
        recyclerView.layoutManager = layoutManager
        
        // Add item decoration for better spacing
        recyclerView.addItemDecoration(object : RecyclerView.ItemDecoration() {
            override fun getItemOffsets(
                outRect: Rect,
                view: View,
                parent: RecyclerView,
                state: RecyclerView.State
            ) {
                outRect.bottom = 8
                outRect.top = 8
            }
        })
    }

    private fun loadBookings() {
        showLoading(true)
        
        // Simulate loading delay for better UX
        recyclerView.postDelayed({
            try {
                userId?.let { id ->
                    val bookings = dataManager.getBookingsByUserId(id)
                    
                    if (bookings.isNotEmpty()) {
                        adapter = BookingAdapter(this@BookingsActivity, bookings)
                        adapter?.setOnBookingActionListener(this@BookingsActivity)
                        recyclerView.adapter = adapter
                        showEmptyState(false)
                    } else {
                        showEmptyState(true)
                    }
                } ?: showEmptyState(true)
            } catch (e: Exception) {
                Toast.makeText(
                    this,
                    "Error loading bookings: ${e.message}",
                    Toast.LENGTH_SHORT
                ).show()
                showEmptyState(true)
            } finally {
                showLoading(false)
            }
        }, 500)
    }

    private fun showLoading(show: Boolean) {
        progressBar?.visibility = if (show) View.VISIBLE else View.GONE
        recyclerView.visibility = if (show) View.GONE else View.VISIBLE
    }

    private fun showEmptyState(show: Boolean) {
        emptyStateText?.apply {
            visibility = if (show) View.VISIBLE else View.GONE
            if (show) {
                text = "No bookings found.\nStart exploring rooms to make your first reservation!"
            }
        }
        recyclerView.visibility = if (show) View.GONE else View.VISIBLE
    }

    // BookingAdapter.OnBookingActionListener implementation
    override fun onViewDetails(booking: BookingDomain) {
        val intent = Intent(this, ServiceDetailsActivity::class.java)
        intent.putExtra("roomId", booking.roomId)
        intent.putExtra("bookingId", booking.id)
        intent.putExtra("userId", userId)
        startActivity(intent)
    }

    override fun onManageBooking(booking: BookingDomain) {
        // Create a simple dialog or navigate to booking management
        Toast.makeText(
            this,
            "Managing booking for ${booking.roomName}",
            Toast.LENGTH_SHORT
        ).show()
        
        // TODO: Implement booking management functionality
        // This could include options like:
        // - Modify dates
        // - Cancel booking
        // - Add special requests
        // - Contact hotel
    }

    override fun onBookingClick(booking: BookingDomain) {
        // Same as view details for now
        onViewDetails(booking)
    }

    override fun onSupportNavigateUp(): Boolean {
        onBackPressed()
        return true
    }

    override fun onResume() {
        super.onResume()
        // Refresh bookings when returning to this activity
        adapter?.let {
            loadBookings()
        }
    }
}
