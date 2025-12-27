import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:booking_agency/screens/bookings_screen.dart';
import 'package:booking_agency/screens/profile_screen.dart';
import 'package:booking_agency/utils/route_transitions.dart';

class RoomListingScreen extends StatefulWidget {
  const RoomListingScreen({super.key});

  @override
  State<RoomListingScreen> createState() => _RoomListingScreenState();
}

class _RoomListingScreenState extends State<RoomListingScreen> {
  int _currentIndex = 0;
  // Add this method to handle navigation
  void _onBottomNavTap(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        RouteTransitions.slideFromRight(BookingsScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        RouteTransitions.slideFromRight(ProfileScreen()),
      );
    } else {
      setState(() => _currentIndex = index);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          RoomListingScreenContent(),
          BookingsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFC5A368),
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavTap, // Use the new method here
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class RoomListingScreenContent extends StatefulWidget {
  const RoomListingScreenContent({super.key});

  @override
  State<RoomListingScreenContent> createState() => _RoomListingScreenContentState();
}

class _RoomListingScreenContentState extends State<RoomListingScreenContent> with SingleTickerProviderStateMixin {
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);

  late AnimationController _controller;
  
  // Animation definitions
  late Animation<double> _heroOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _filterFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 1. Hero Fades in first
    _heroOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );

    // 2. Booking Card slides up
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic)),
    );

    // 3. Filters fade in last
    _filterFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.6, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated Hero
                FadeTransition(opacity: _heroOpacity, child: _buildHeroSection()),
                
                const SizedBox(height: 250),
                
                _buildFeaturesGrid(),
                _buildRoomSectionHeader(),
                
                // Animated Filters
                FadeTransition(
                  opacity: _filterFade,
                  child: _buildFilters(),
                ),
                
                _buildRoomList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: brandGold, borderRadius: BorderRadius.circular(8)),
            child: const Text('L', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 10),
          Text('LuxeStay', style: GoogleFonts.poppins(color: darkGrey, fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded, color: darkGrey)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 350,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=2070'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
            padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
            child: Column(
              children: [
                Text(
                  'Luxury Awaits You',
                  style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Experience world-class hospitality in\nbeautifully designed rooms',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                ),
              ],
            ),
          ),
        ),
        // Animated Slide for the Booking Card
        Positioned(
          top: 220,
          left: 20,
          right: 20,
          child: SlideTransition(
            position: _cardSlide,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildInputBox("CHECK-IN", "28 Dec", Icons.calendar_today_outlined)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildInputBox("CHECK-OUT", "30 Dec", Icons.calendar_today_outlined)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInputBox("GUESTS", "2 Adults, 1 Child", Icons.people_outline),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGold,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Search Availability", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- REUSED HELPERS ---
  Widget _buildInputBox(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, size: 18, color: brandGold),
            const SizedBox(width: 10),
            Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildFeaturesGrid() {
    final features = [
      {'icon': Icons.shield_outlined, 'title': 'Secure Booking'},
      {'icon': Icons.workspace_premium_outlined, 'title': 'Best Prices'},
      {'icon': Icons.headset_mic_outlined, 'title': '24/7 Support'},
      {'icon': Icons.auto_awesome_outlined, 'title': 'Premium Quality'},
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: 4,
        itemBuilder: (context, index) => Row(
          children: [
            CircleAvatar(backgroundColor: brandGold.withOpacity(0.1), child: Icon(features[index]['icon'] as IconData, color: brandGold, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Text(features[index]['title'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomSectionHeader() => const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Text("Featured Accommodations", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)));

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        children: ["All Rooms", "Penthouse", "Ocean View", "Suites", "Studio"]
            .map((filter) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(filter),
                    selected: filter == "All Rooms",
                    onSelected: (val) {},
                    backgroundColor: Colors.white,
                    selectedColor: brandGold.withOpacity(0.2),
                    checkmarkColor: brandGold,
                    labelStyle: TextStyle(color: filter == "All Rooms" ? brandGold : Colors.black54, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide(color: filter == "All Rooms" ? brandGold : Colors.grey.shade200),
                  ),
                )).toList(),
      ),
    );
  }

  Widget _buildRoomList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: Image.network(index == 0 ? 'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=1974' : 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?q=80&w=1974', height: 220, width: double.infinity, fit: BoxFit.cover)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(index == 0 ? "Deluxe Ocean View" : "Classic Single Room", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Row(children: const [Icon(Icons.star, color: brandGold, size: 18), Text(" 4.9", style: TextStyle(fontWeight: FontWeight.bold))])]),
                  const SizedBox(height: 8),
                  Text("Luxury stay with premium amenities and specialized service.", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(text: TextSpan(children: [TextSpan(text: "\$${index == 0 ? 250 : 80}", style: const TextStyle(color: darkGrey, fontWeight: FontWeight.bold, fontSize: 20)), const TextSpan(text: " /night", style: TextStyle(color: Colors.grey, fontSize: 14))])),
                      ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: darkGrey, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text("Book Now")),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}