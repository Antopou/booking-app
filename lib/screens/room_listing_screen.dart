import 'package:flutter/material.dart';
import 'package:booking_agency/screens/bookings_screen.dart';

class RoomListingScreen extends StatefulWidget {
  const RoomListingScreen({super.key});

  @override
  State<RoomListingScreen> createState() => _RoomListingScreenState();
}

class _RoomListingScreenState extends State<RoomListingScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          RoomListingScreenContent(),
          BookingsScreen(),
          Center(child: Text('Profile')), // Placeholder for Profile
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            // Navigate to Bookings screen using named route
            Navigator.pushReplacementNamed(context, '/bookings');
          } else if (index == 2) {
            // Navigate to Profile screen using named route
            Navigator.pushReplacementNamed(context, '/profile');
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        selectedItemColor: RoomListingScreenContent.brandGold,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class RoomListingScreenContent extends StatelessWidget {
  const RoomListingScreenContent({super.key});

  static const Color brandGold = Color(0xFFC5A368);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Bar
        AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: brandGold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'L',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'LuxeStay',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          leadingWidth: 150,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, color: Colors.black),
            ),
          ],
        ),
        // Content
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeroSection(),
                _buildFeaturesGrid(),
                _buildRoomSectionHeader(),
                _buildFilters(),
                _buildRoomList(brandGold),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildHeroSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Image
        Container(
          height: 400,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=2070',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              children: const [
                Text(
                  'Luxury Awaits You',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Experience world-class hospitality in beautifully designed rooms',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        // Booking Card
        Positioned(
          top: 180,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputLabel("CHECK-IN"),
                _buildInputField("28/12/2025", Icons.calendar_today),
                const SizedBox(height: 15),
                _buildInputLabel("CHECK-OUT"),
                _buildInputField("29/12/2025", Icons.calendar_today),
                const SizedBox(height: 15),
                _buildInputLabel("GUESTS"),
                _buildInputField("2", null),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.search, size: 18),
                    label: const Text("Search Rooms"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandGold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 380), // Spacer for the stack
      ],
    );
  }

  static Widget _buildInputLabel(String label) => Text(
    label,
    style: const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    ),
  );

  static Widget _buildInputField(String text, IconData? icon) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 16)),
          if (icon != null) Icon(icon, size: 18, color: Colors.black54),
        ],
      ),
    );
  }

  static Widget _buildFeaturesGrid() {
    final features = [
      {
        'icon': Icons.shield_outlined,
        'title': 'Secure Booking',
        'sub': 'Safe & encrypted payments',
      },
      {
        'icon': Icons.workspace_premium_outlined,
        'title': 'Best Prices',
        'sub': 'Guaranteed lowest rates',
      },
      {
        'icon': Icons.headset_mic_outlined,
        'title': '24/7 Support',
        'sub': 'Always here to help',
      },
      {
        'icon': Icons.auto_awesome_outlined,
        'title': 'Premium Quality',
        'sub': 'Luxury accommodations',
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(
        top: 240,
        left: 20,
        right: 20,
      ), // Compensate for Stack height
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2,
          mainAxisSpacing: 20,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: brandGold.withOpacity(0.3)),
                  color: brandGold.withOpacity(0.05),
                ),
                child: Icon(
                  features[index]['icon'] as IconData,
                  color: brandGold,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                features[index]['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              Text(
                features[index]['sub'] as String,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _buildRoomSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          const Text(
            "Our Rooms",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Choose from our selection of beautifully designed accommodations",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  static Widget _buildFilters() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search rooms...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 10),
          _buildFilterDropdown("All Types"),
          const SizedBox(height: 10),
          _buildFilterDropdown("All Prices"),
          const SizedBox(height: 10),
          _buildFilterDropdown("Any Capacity"),
        ],
      ),
    );
  }

  static Widget _buildFilterDropdown(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: const TextStyle(color: Colors.black87)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ],
      ),
    );
  }

  static Widget _buildRoomList(Color brandGold) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[100]!),
          ),
          margin: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  index == 0
                      ? 'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=1974'
                      : 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?q=80&w=1974',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      index == 0 ? "Deluxe Ocean View" : "Classic Single Room",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Spacious deluxe room with breathtaking ocean views, features a king-size bed...",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${index == 0 ? 2 : 1} Guests",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Icon(
                          Icons.square_foot,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${index == 0 ? 45 : 28} m²",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "From",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "\$${index == 0 ? 250 : 80}/night",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: brandGold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A1A1A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text("View Details"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
