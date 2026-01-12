import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Note: Ensure you have 'google_fonts' in your pubspec.yaml
// Screens imports
import 'package:booking_app/screens/room_details_screen.dart';
import 'package:booking_app/screens/search_results_screen.dart';

// Models and Services
import 'package:booking_app/models/room_model.dart';
import 'package:booking_app/services/room_service.dart';

class RoomListingScreen extends StatefulWidget {
  const RoomListingScreen({super.key});

  @override
  State<RoomListingScreen> createState() => _RoomListingScreenState();
}

class _RoomListingScreenState extends State<RoomListingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RoomListingScreenContent(),
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
  final List<String> _filters = ["All Rooms"];
  String _selectedFilter = "All Rooms";
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);
  
  // API state
  final RoomService _roomService = RoomService();
  List<Room> _allRooms = [];
  bool _isLoading = true;
  String? _errorMessage;

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

  List<Room> get _filteredRooms {
    if (_selectedFilter == 'All Rooms') {
      return _allRooms;
    }
    return _allRooms.where((room) => room.roomTypeName == _selectedFilter).toList();
  }
  
  Future<void> _loadRooms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final rooms = await _roomService.fetchRooms();
      
      // Extract unique room types for filters
      final Set<String> roomTypes = rooms.map((room) => room.roomTypeName).toSet();
      
      setState(() {
        _allRooms = rooms;
        _filters.clear();
        _filters.add('All Rooms');
        _filters.addAll(roomTypes);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

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
    
    // Load rooms from API
    _loadRooms();
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
      lastDate: DateTime(2027, 12, 31),
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
          Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
          Row(
            children: [
              IconButton(
                onPressed: value > 0 ? () => onUpdate(value - 1) : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              const SizedBox(width: 10),
              Text("$value", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
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
                const SizedBox(height: 50),
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
    return Column(
      children: [
        // The Image part
        Container(
          height: 300,
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
        // The Search Card part
        Transform.translate(
          offset: const Offset(0, -80), // Pull the card UP into the image
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SlideTransition(
              position: _cardSlide,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // print('Check-in tapped');
                            _selectDateRange(context);
                          },
                          child: _buildInputBox("CHECK-IN", _formatDate(_selectedDateRange.start), Icons.calendar_today_outlined),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // print('Check-out tapped');
                            _selectDateRange(context);
                          },
                          child: _buildInputBox("CHECK-OUT", _formatDate(_selectedDateRange.end), Icons.calendar_today_outlined),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // print('Guests tapped');
                      _showGuestPicker();
                    },
                    child: _buildInputBox(
                      "GUESTS",
                      "$_adults Adults, $_children Child",
                      Icons.people_outline,
                    ),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      print('Search Availability button clicked!');
                      print('Date range: ${_selectedDateRange.start} to ${_selectedDateRange.end}');
                      print('Adults: $_adults, Children: $_children');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsScreen(
                            dateRange: _selectedDateRange,
                            adults: _adults,
                            children: _children,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: brandGold,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Search Availability",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputBox(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1)),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, size: 18, color: brandGold),
            const SizedBox(width: 10),
            Expanded(
              child: Text(value, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
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
            Expanded(child: Text(features[index]['title'] as String, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomSectionHeader() => Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), child: Text("Featured Accommodations", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)));

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Row(
        children: _filters
            .map((filter) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 110,
                  child: FilterChip(
                    label: SizedBox(
                      width: double.infinity,
                      child: Text(
                        filter,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: filter == _selectedFilter ? brandGold : Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: brandGold),
        ),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error loading rooms',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRooms,
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
    
    final rooms = _filteredRooms;
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: rooms.isEmpty
          ? Padding(
              key: const ValueKey('empty'),
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No rooms found',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try selecting a different category',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              key: ValueKey(_selectedFilter),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rooms.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                return _HoverableRoomCard(roomData: rooms[index].toMap());
              },
            ),
    );
  }

}

class _HoverableRoomCard extends StatefulWidget {
  final Map<String, dynamic> roomData;
  const _HoverableRoomCard({required this.roomData});

  @override
  State<_HoverableRoomCard> createState() => _HoverableRoomCardState();
}

class _HoverableRoomCardState extends State<_HoverableRoomCard> {
  bool _hoveringImage = false;

  @override
  Widget build(BuildContext context) {
    final roomData = widget.roomData;
    final roomId = roomData['id'] as int?;
    
    return GestureDetector(
      onTap: () {
        if (roomId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomDetailsScreen(roomId: roomId),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // No shadow, border stays the same
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _hoveringImage = true),
              onExit: (_) => setState(() => _hoveringImage = false),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: AnimatedScale(
                  scale: _hoveringImage ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  child: Image.network(
                    widget.roomData['image'],
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              widget.roomData['name'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Row(children: [
                          const Icon(Icons.star, color: Color(0xFFC5A368), size: 18),
                          Text(" ${widget.roomData['rating']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(" (${widget.roomData['reviews']})", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                        ])
                      ]),
                  const SizedBox(height: 8),
                  Text(
                      widget.roomData['description'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const Divider(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "\$${widget.roomData['price']}",
                            style: GoogleFonts.poppins(
                                color: const Color(0xFF1A1A1A),
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        TextSpan(
                            text: " /night",
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 14))
                      ])),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          child: Text(
                            "Book Now",
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                letterSpacing: 1.0),
                          ),
                        ),
                      ),
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