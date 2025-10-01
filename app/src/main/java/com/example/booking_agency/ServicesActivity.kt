package com.example.booking_agency

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.ProgressBar
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.Toolbar
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.booking_agency.adapters.RoomAdapter
import com.example.booking_agency.models.Room
import com.example.booking_agency.utils.JsonDataManager

class ServicesActivity : AppCompatActivity() {

    private lateinit var recyclerView: RecyclerView
    private lateinit var progressBar: ProgressBar
    private lateinit var emptyStateText: TextView
    private lateinit var dataManager: JsonDataManager
    private lateinit var roomType: String
    private lateinit var userId: String
    
    private val roomAdapter = RoomAdapter { room ->
        // Handle room click
        val intent = Intent(this, ServiceDetailsActivity::class.java).apply {
            putExtra("roomId", room.id)
            putExtra("userId", userId)
        }
        startActivity(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_services)

        // Get extras
        roomType = intent.getStringExtra("roomType") ?: "STANDARD"
        userId = intent.getStringExtra("userId") ?: ""
        
        dataManager = JsonDataManager(this)
        
        setupToolbar()
        initializeViews()
        setupRecyclerView()
        loadRooms()
    }

    private fun setupToolbar() {
        val toolbar = findViewById<Toolbar>(R.id.toolbar)
        setSupportActionBar(toolbar)
        supportActionBar?.apply {
            setDisplayHomeAsUpEnabled(true)
            setDisplayShowHomeEnabled(true)
            title = roomType.replaceFirstChar { it.uppercase() } + " Rooms"
        }
        toolbar.setNavigationOnClickListener { onBackPressed() }
    }

    private fun initializeViews() {
        recyclerView = findViewById(R.id.services_recycler)
        progressBar = findViewById(R.id.progress_bar)
        emptyStateText = findViewById(R.id.empty_state_text)
    }

    private fun setupRecyclerView() {
        recyclerView.layoutManager = GridLayoutManager(this, 2)
        recyclerView.adapter = roomAdapter
        
        // Add item decoration for spacing
        val spacing = resources.getDimensionPixelSize(R.dimen.grid_spacing)
        recyclerView.addItemDecoration(GridSpacingItemDecoration(2, spacing, true))
    }

    private fun loadRooms() {
        showLoading(true)
        
        // Simulate network/database call
        recyclerView.postDelayed({
            try {
                val allRooms = dataManager.getRooms()
                val filteredRooms = allRooms.filter { 
                    it.type.toString().equals(roomType, ignoreCase = true) 
                }
                
                if (filteredRooms.isNotEmpty()) {
                    roomAdapter.submitList(filteredRooms)
                    showEmptyState(false)
                } else {
                    showEmptyState(true)
                }
            } catch (e: Exception) {
                showEmptyState(true, "Failed to load rooms. Please try again.")
            } finally {
                showLoading(false)
            }
        }, 500)
    }

    private fun showLoading(show: Boolean) {
        progressBar.visibility = if (show) View.VISIBLE else View.GONE
        recyclerView.visibility = if (show) View.INVISIBLE else View.VISIBLE
    }

    private fun showEmptyState(show: Boolean, message: String? = null) {
        emptyStateText.visibility = if (show) View.VISIBLE else View.GONE
        if (show && message != null) {
            emptyStateText.text = message
        }
        recyclerView.visibility = if (show) View.INVISIBLE else View.VISIBLE
    }

    // Grid spacing item decoration
    class GridSpacingItemDecoration(
        private val spanCount: Int,
        private val spacing: Int,
        private val includeEdge: Boolean
    ) : RecyclerView.ItemDecoration() {
        // Implementation of item decoration
    }
}
