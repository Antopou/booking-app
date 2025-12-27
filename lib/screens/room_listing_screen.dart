import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Note: Ensure you have 'google_fonts' in your pubspec.yaml
// Screens imports (Commented out to ensure the code runs immediately)
import 'package:booking_app/screens/bookings_screen.dart';
import 'package:booking_app/screens/profile_screen.dart';

class RoomListingScreen extends StatefulWidget {
  const RoomListingScreen({super.key});

  @override
  State<RoomListingScreen> createState() => _RoomListingScreenState();
}

class _RoomListingScreenState extends State<RoomListingScreen> {
  int _currentIndex = 0;

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (_currentIndex) {
      case 1:
        content = const BookingsScreen();
        break;
      case 2:
        content = const ProfileScreen();
        break;
      default:
        content = const RoomListingScreenContent();
    }
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: content,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFC5A368),
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavTap,
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
    // Room filter state
    final List<String> _filters = ["All Rooms", "Penthouse", "Ocean View", "Suites", "Studio"];
    String _selectedFilter = "All Rooms";
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);

  late AnimationController _controller;
  late Animation<double> _heroOpacity;
  late Animation<Offset> _cardSlide;
  late Animation<double> _filterFade;

  // --- SELECTION STATE ---
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 2)),
  );
  int _adults = 2;
  int _children = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _heroOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.4, curve: Curves.easeIn)),
    );

    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic)),
    );

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

  // --- HELPERS ---

  String _formatDate(DateTime date) => "${date.day} ${_getMonth(date.month)}";

  String _getMonth(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: brandGold,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: darkGrey,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  void _showGuestPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select Guests", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildCounterRow("Adults", _adults, (val) {
                    setModalState(() => _adults = val);
                    setState(() {});
                  }),
                  const Divider(),
                  _buildCounterRow("Children", _children, (val) {
                    setModalState(() => _children = val);
                    setState(() {});
                  }),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGrey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Confirm Guests", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCounterRow(String title, int value, Function(int) onUpdate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              IconButton(
                onPressed: value > 0 ? () => onUpdate(value - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              const SizedBox(width: 10),
              Text("$value", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () => onUpdate(value + 1),
                icon: const Icon(Icons.add_circle_outline, color: brandGold),
              ),
            ],
          )
        ],
      ),
    );
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
                FadeTransition(opacity: _heroOpacity, child: _buildHeroSection()),
                const SizedBox(height: 130),
                _buildFeaturesGrid(),
                _buildRoomSectionHeader(),
                FadeTransition(opacity: _filterFade, child: _buildFilters()),
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
                  InkWell(
                    onTap: () => _selectDateRange(context),
                    child: Row(
                      children: [
                        Expanded(child: _buildInputBox("CHECK-IN", _formatDate(_selectedDateRange.start), Icons.calendar_today_outlined)),
                        const SizedBox(width: 15),
                        Expanded(child: _buildInputBox("CHECK-OUT", _formatDate(_selectedDateRange.end), Icons.calendar_today_outlined)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInputBox(
                    "GUESTS",
                    "$_adults Adults, $_children Child",
                    Icons.people_outline,
                    onTap: _showGuestPicker,
                  ),
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

  Widget _buildInputBox(String label, String value, IconData icon, {VoidCallback? onTap}) {
    final content = Column(
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
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: content,
      );
    }
    return content;
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
        children: _filters
            .map((filter) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Text(filter),
                    selected: filter == _selectedFilter,
                    onSelected: (val) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: brandGold.withOpacity(0.2),
                    checkmarkColor: brandGold,
                    labelStyle: TextStyle(color: filter == _selectedFilter ? brandGold : Colors.black54, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    side: BorderSide(color: filter == _selectedFilter ? brandGold : Colors.grey.shade200),
                  ),
                ))
            .toList(),
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