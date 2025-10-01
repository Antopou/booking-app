package com.example.booking_agency.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.example.booking_agency.R
import com.example.booking_agency.models.Service

class ServiceAdapter(
    private val onServiceClick: (Service) -> Unit
) : ListAdapter<Service, ServiceAdapter.ServiceViewHolder>(ServiceDiffCallback()) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ServiceViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_service, parent, false)
        return ServiceViewHolder(view, onServiceClick)
    }

    override fun onBindViewHolder(holder: ServiceViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    class ServiceViewHolder(
        itemView: View,
        private val onServiceClick: (Service) -> Unit
    ) : RecyclerView.ViewHolder(itemView) {
        private val serviceName: TextView = itemView.findViewById(R.id.item_service_name)
        private val serviceProvider: TextView = itemView.findViewById(R.id.item_service_provider)
        private val serviceCategory: TextView = itemView.findViewById(R.id.item_service_category)
        private val servicePrice: TextView = itemView.findViewById(R.id.item_service_price)
        private val serviceRating: TextView = itemView.findViewById(R.id.item_service_rating)

        fun bind(service: Service) {
            serviceName.text = service.name
            serviceProvider.text = "Hotel Service" // Default provider
            serviceCategory.text = service.category.toString()
            servicePrice.text = service.getFormattedPrice()
            serviceRating.text = "4.8" // Default rating
            
            // Set click listener
            itemView.setOnClickListener { onServiceClick(service) }
        }
    }

    private class ServiceDiffCallback : DiffUtil.ItemCallback<Service>() {
        override fun areItemsTheSame(oldItem: Service, newItem: Service): Boolean {
            return oldItem.id == newItem.id
        }

        override fun areContentsTheSame(oldItem: Service, newItem: Service): Boolean {
            return oldItem == newItem
        }
    }
}
