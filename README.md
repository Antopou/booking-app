# RoomBooker Pro - Professional Room Booking App

A modern, professional Android application for booking hotel rooms with an intuitive user interface and comprehensive booking management features.

## Features

### 🏨 Room Categories
- **Standard Rooms** - Comfortable accommodations for budget-conscious travelers
- **Deluxe Rooms** - Premium rooms with enhanced amenities and views
- **Suites** - Spacious accommodations with separate living areas
- **Presidential Suites** - Ultimate luxury with premium services and panoramic views

### 🔍 Advanced Search & Filtering
- Filter by room type, price range, occupancy, and amenities
- Sort by price, rating, and availability
- Real-time search with instant results
- Location-based room discovery

### 💎 Professional Features
- **Detailed Room Information** - Comprehensive room details including size, bed type, amenities
- **High-Quality Images** - Multiple room photos and hotel images
- **Guest Reviews & Ratings** - Verified guest reviews and star ratings
- **Flexible Booking Options** - Multiple check-in/check-out times and guest configurations
- **Cancellation Policies** - Clear and flexible cancellation terms

### 📱 Modern UI/UX
- Material Design principles
- Intuitive navigation and user flow
- Responsive layouts for all screen sizes
- Professional color scheme and typography
- Smooth animations and transitions

### 🛡️ Booking Management
- **Booking Confirmation** - Detailed booking confirmation with price breakdown
- **Booking History** - Complete history of past and upcoming bookings
- **Real-time Updates** - Instant booking status updates
- **Secure Transactions** - Professional booking confirmation system

## Technical Architecture

### Models
- **Room** - Comprehensive room data model with amenities, pricing, and availability
- **Booking** - Complete booking information with guest details and stay duration
- **User** - User profile and preferences management

### Key Components
- **RoomAdapter** - Efficient RecyclerView adapter for room listings
- **RoomFilter** - Advanced filtering and sorting utilities
- **BookingConfirmationDialog** - Professional booking confirmation interface
- **JsonDataManager** - Robust data management and persistence

### Data Structure
```json
{
  "rooms": [
    {
      "id": "deluxe_ocean_view",
      "name": "Deluxe Ocean View",
      "type": "DELUXE",
      "pricePerNight": 189.0,
      "maxOccupancy": 2,
      "amenities": ["WiFi", "Air Conditioning", "Ocean View", "Balcony"],
      "rating": 4.8,
      "reviewCount": 124
    }
  ]
}
```

## Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone [repository-url]
   cd booking_agency
   ```

2. **Open in Android Studio**
   - Import the project in Android Studio
   - Sync Gradle files
   - Build and run the application

3. **Requirements**
   - Android SDK 24+ (Android 7.0)
   - Target SDK 35
   - Java 11 compatibility

## Usage

### For Users
1. **Browse Rooms** - Explore different room categories from the main screen
2. **Filter & Search** - Use advanced filters to find the perfect room
3. **View Details** - Check comprehensive room information and amenities
4. **Book Room** - Complete booking with confirmation dialog
5. **Manage Bookings** - View and manage your booking history

### For Developers
1. **Add New Room Types** - Extend the Room model and update categories
2. **Customize Filters** - Modify RoomFilter class for additional criteria
3. **Update UI** - Customize layouts and themes in res/ directory
4. **Add Features** - Extend functionality with new activities and services

## Project Structure

```
app/
├── src/main/
│   ├── java/com/example/booking_agency/
│   │   ├── models/          # Data models (Room, Booking, User)
│   │   ├── adapters/        # RecyclerView adapters
│   │   ├── dialogs/         # Custom dialogs
│   │   ├── utils/           # Utility classes (JsonDataManager, RoomFilter)
│   │   └── *.java          # Activities (MainActivity, etc.)
│   ├── res/
│   │   ├── layout/          # XML layouts
│   │   ├── drawable/        # Icons and graphics
│   │   ├── values/          # Strings, colors, themes
│   │   └── mipmap/          # App icons
│   └── assets/data/         # JSON data files
└── build.gradle.kts         # Build configuration
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Contact

For questions, suggestions, or support, please contact the development team. Email: gnanantopou@gmail.com

---

**RoomBooker Pro** - Your gateway to seamless hotel room booking experiences.
