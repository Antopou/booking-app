package com.example.booking_agency.adapters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.example.booking_agency.R

class RoomImagePagerAdapter(private val images: List<Any>) : RecyclerView.Adapter<RoomImagePagerAdapter.ImageViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ImageViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.item_room_image, parent, false)
        return ImageViewHolder(view)
    }

    override fun onBindViewHolder(holder: ImageViewHolder, position: Int) {
        holder.bind(images[position])
    }

    override fun getItemCount(): Int = images.size

    class ImageViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        private val imageView: ImageView = itemView.findViewById(R.id.room_image)

        fun bind(image: Any) {
            when (image) {
                is String -> {
                    // URL image
                    Glide.with(itemView.context)
                        .load(image)
                        .placeholder(R.drawable.room_placeholder)
                        .error(R.drawable.room_placeholder)
                        .into(imageView)
                }
                is Int -> {
                    // Resource ID
                    imageView.setImageResource(image)
                }
                else -> {
                    // Default placeholder
                    imageView.setImageResource(R.drawable.room_placeholder)
                }
            }
        }
    }
}