package com.example.booking_agency.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationUtils
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.RecyclerView
import com.example.booking_agency.R
import com.example.booking_agency.models.Booking
import java.text.SimpleDateFormat
import java.util.*

import com.example.booking_agency.domain.model.BookingDomain

class BookingAdapter(
    private val context: Context,
    private val bookings: List<BookingDomain>
) : RecyclerView.Adapter<BookingAdapter.BookingViewHolder>() {

    interface OnBookingActionListener {
        fun onViewDetails(booking: BookingDomain)
        fun onManageBooking(booking: BookingDomain)
        fun onBookingClick(booking: BookingDomain)
    }

    private var actionListener: OnBookingActionListener? = null
    private var lastPosition = -1

    fun setOnBookingActionListener(listener: OnBookingActionListener) {
        this.actionListener = listener
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): BookingViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_booking, parent, false)
        return BookingViewHolder(view)
    }

    override fun onBindViewHolder(holder: BookingViewHolder, position: Int) {
        val booking = bookings[position]
        
        // Set basic information
        holder.serviceName.text = booking.roomName
        holder.providerName.text = booking.hotelName
        
        // Format and set date range
        val dateRange = formatDateRange(booking.checkInDate, booking.checkOutDate)
        holder.dateTime.text = dateRange
        
        // Set guest information
        val nights = calculateNights(booking.checkInDate, booking.checkOutDate)
        val guestInfo = "${booking.guests} guests • $nights nights"
        holder.guests.text = guestInfo
        
        // Set status with appropriate styling
        setStatusBadge(holder.status, booking.status.toString())
        
        // Set price
        holder.price.text = "$${String.format("%.2f", booking.totalPrice)}"
        
        // Set room image based on room type or use default
        setRoomImage(holder.roomImage, booking.roomType.toString())
        
        // Set click listeners
        holder.itemView.setOnClickListener {
            actionListener?.onBookingClick(booking)
        }
        
        holder.viewDetailsBtn.setOnClickListener {
            actionListener?.onViewDetails(booking)
        }
        
        holder.manageBookingBtn.setOnClickListener {
            actionListener?.onManageBooking(booking)
        }
        
        // Add animation for newly visible items
        setAnimation(holder.itemView, position)
    }

    private fun formatDateRange(checkInDate: String, checkOutDate: String): String {
        return try {
            val inputFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val outputFormat = SimpleDateFormat("MMM dd", Locale.getDefault())
            
            val checkIn = inputFormat.parse(checkInDate)
            val checkOut = inputFormat.parse(checkOutDate)
            
            if (checkIn != null && checkOut != null) {
                "${outputFormat.format(checkIn)} - ${outputFormat.format(checkOut)}, 2024"
            } else {
                "$checkInDate - $checkOutDate"
            }
        } catch (e: Exception) {
            e.printStackTrace()
            "$checkInDate - $checkOutDate"
        }
    }

    private fun calculateNights(checkInDate: String, checkOutDate: String): Int {
        return try {
            val format = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val checkIn = format.parse(checkInDate)
            val checkOut = format.parse(checkOutDate)
            
            if (checkIn != null && checkOut != null) {
                val diffInMillies = checkOut.time - checkIn.time
                (diffInMillies / (1000 * 60 * 60 * 24)).toInt()
            } else {
                1 // Default to 1 night
            }
        } catch (e: Exception) {
            e.printStackTrace()
            1 // Default to 1 night
        }
    }

    private fun setStatusBadge(statusView: TextView, status: String) {
        statusView.text = status.uppercase()
        
        val backgroundRes = when (status.lowercase()) {
            "confirmed" -> R.drawable.status_confirmed_background
            "pending" -> R.drawable.status_pending_background
            "cancelled" -> R.drawable.status_cancelled_background
            else -> R.drawable.status_confirmed_background
        }
        
        val textColor = ContextCompat.getColor(context, R.color.text_on_primary)
        statusView.background = ContextCompat.getDrawable(context, backgroundRes)
        statusView.setTextColor(textColor)
    }

    private fun setRoomImage(imageView: ImageView, roomType: String) {
        val imageRes = when (roomType.lowercase()) {
            "standard" -> R.drawable.room_standard
            "deluxe" -> R.drawable.room_deluxe
            "suite" -> R.drawable.room_suite
            "presidential" -> R.drawable.room_presidential
            else -> R.drawable.room_standard
        }
        imageView.setImageResource(imageRes)
    }

    private fun setAnimation(viewToAnimate: View, position: Int) {
        if (position > lastPosition) {
            val animation = AnimationUtils.loadAnimation(context, android.R.anim.slide_in_left)
            animation.duration = 300
            viewToAnimate.startAnimation(animation)
            lastPosition = position
        }
    }

    override fun onViewDetachedFromWindow(holder: BookingViewHolder) {
        super.onViewDetachedFromWindow(holder)
        holder.itemView.clearAnimation()
    }

    override fun getItemCount(): Int = bookings.size

    class BookingViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val roomImage: ImageView = itemView.findViewById(R.id.booking_room_image)
        val serviceName: TextView = itemView.findViewById(R.id.item_booking_service_name)
        val providerName: TextView = itemView.findViewById(R.id.item_booking_provider_name)
        val dateTime: TextView = itemView.findViewById(R.id.item_booking_datetime)
        val guests: TextView = itemView.findViewById(R.id.item_booking_guests)
        val status: TextView = itemView.findViewById(R.id.item_booking_status)
        val price: TextView = itemView.findViewById(R.id.item_booking_price)
        val viewDetailsBtn: Button = itemView.findViewById(R.id.btn_view_details)
        val manageBookingBtn: Button = itemView.findViewById(R.id.btn_manage_booking)
    }
}
