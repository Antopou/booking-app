package com.example.booking_agency.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.RatingBar
import android.widget.TextView
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.example.booking_agency.R
import com.example.booking_agency.domain.model.RoomDomain

class RoomAdapter(
    private val onRoomClick: (RoomDomain) -> Unit
) : ListAdapter<RoomDomain, RoomAdapter.RoomViewHolder>(RoomDiffCallback()) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RoomViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_room, parent, false)
        return RoomViewHolder(view, onRoomClick)
    }

    override fun onBindViewHolder(holder: RoomViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    class RoomViewHolder(
        itemView: View,
        private val onRoomClick: (RoomDomain) -> Unit
    ) : RecyclerView.ViewHolder(itemView) {
        private val roomImage: ImageView = itemView.findViewById(R.id.room_image)
        private val roomName: TextView = itemView.findViewById(R.id.room_name)
        private val roomType: TextView = itemView.findViewById(R.id.room_type)
        private val roomPrice: TextView = itemView.findViewById(R.id.room_price)
        private val roomRating: RatingBar = itemView.findViewById(R.id.room_rating)
        private val roomReviewCount: TextView = itemView.findViewById(R.id.room_review_count)
        private val roomSize: TextView = itemView.findViewById(R.id.room_size)
        private val roomBedType: TextView = itemView.findViewById(R.id.room_bed_type)
        private val roomMaxGuests: TextView = itemView.findViewById(R.id.room_max_guests)

        fun bind(room: RoomDomain) {
            // Set room image - RoomDomain has string URLs, so use placeholder for now
            roomImage.setImageResource(R.drawable.room_placeholder)
            
            roomName.text = room.name
            roomType.text = room.type.name
            roomPrice.text = "$${String.format("%.2f", room.pricePerNight)}"
            roomSize.text = room.size
            roomBedType.text = room.bedType
            roomMaxGuests.text = itemView.context.getString(R.string.max_guests, room.maxGuests)
            
            // Set rating
            roomRating.rating = room.rating
            roomReviewCount.text = "(${room.reviewCount})"
            
            // Set click listener
            itemView.setOnClickListener { onRoomClick(room) }
        }
    }

    private class RoomDiffCallback : DiffUtil.ItemCallback<RoomDomain>() {
        override fun areItemsTheSame(oldItem: RoomDomain, newItem: RoomDomain): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: RoomDomain, newItem: RoomDomain): Boolean {
            return oldItem == newItem
        }
    }

    companion object {
        // Animation duration for item animations
        const val ANIMATION_DURATION = 300L
    }
}
