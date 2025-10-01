package com.example.booking_agency.dialogs

import android.app.Dialog
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.Window
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.core.content.ContextCompat
import com.example.booking_agency.R
import com.example.booking_agency.models.Booking
import com.example.booking_agency.models.Room
import java.text.NumberFormat
import java.text.SimpleDateFormat
import java.util.*

class BookingConfirmationDialog(
    context: Context,
    private val room: Room,
    private val booking: Booking,
    private val onConfirm: () -> Unit,
    private val onCancel: () -> Unit = {}
) : Dialog(context) {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)
        setContentView(R.layout.dialog_booking_confirmation)
        
        window?.setBackgroundDrawableResource(android.R.color.transparent)
        
        initializeViews()
    }
    
    private fun initializeViews() {
        // Set room image
        findViewById<ImageView>(R.id.room_image).setImageResource(room.getFirstImage())
        
        // Set room details
        findViewById<TextView>(R.id.dialog_room_name).text = room.name
        findViewById<TextView>(R.id.dialog_hotel_name).text = room.hotelName
        
        // Format and set dates
        val dateFormat = SimpleDateFormat("MMM dd, yyyy", Locale.getDefault())
        val checkInDate = SimpleDateFormat("yyyy-MM-dd").parse(booking.checkInDate) ?: Date()
        val checkOutDate = SimpleDateFormat("yyyy-MM-dd").parse(booking.checkOutDate) ?: Date()
        
        findViewById<TextView>(R.id.dialog_check_in).text = dateFormat.format(checkInDate)
        findViewById<TextView>(R.id.dialog_check_out).text = dateFormat.format(checkOutDate)
        
        // Set guest count
        val nights = booking.getNights()
        val guestText = context.resources.getQuantityString(
            R.plurals.number_of_guests,
            booking.guests,
            booking.guests
        )
        
        findViewById<TextView>(R.id.dialog_nights).text = 
            context.getString(R.string.nights_guests_format, nights, guestText)
        
        // Set price summary
        val subtotal = room.pricePerNight * nights
        val taxes = subtotal * 0.12 // 12% tax
        val total = subtotal + taxes
        
        val currencyFormat = NumberFormat.getCurrencyInstance().apply {
            maximumFractionDigits = 2
            currency = Currency.getInstance("USD")
        }
        
        findViewById<TextView>(R.id.dialog_price_per_night).text = currencyFormat.format(subtotal)
        findViewById<TextView>(R.id.dialog_total_price).text = currencyFormat.format(total)
        
        // Set button click listeners
        findViewById<Button>(R.id.btn_cancel_booking).setOnClickListener {
            onCancel()
            dismiss()
        }
        
        findViewById<Button>(R.id.btn_confirm_booking).setOnClickListener {
            onConfirm()
            dismiss()
        }
    }
    
    companion object {
        fun show(
            context: Context,
            room: Room,
            booking: Booking,
            onConfirm: () -> Unit,
            onCancel: () -> Unit = {}
        ): BookingConfirmationDialog {
            return BookingConfirmationDialog(context, room, booking, onConfirm, onCancel).apply {
                setCancelable(false)
                show()
            }
        }
    }
}
