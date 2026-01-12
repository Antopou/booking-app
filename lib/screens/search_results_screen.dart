import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:booking_app/screens/room_details_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final DateTimeRange dateRange;
  final int adults;
  final int children;

  const SearchResultsScreen({
    super.key,
    required this.dateRange,
    required this.adults,
    required this.children,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> with SingleTickerProviderStateMixin {
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  String _sortBy = 'Recommended';
  final List<String> _sortOptions = ['Recommended', 'Price: Low to High', 'Price: High to Low', 'Rating'];

  // Available rooms data
  final List<Map<String, dynamic>> _availableRooms = [
    {
      'id': 1,
      'name': 'Deluxe Ocean View',
      'category': 'Ocean View',
      'price': 250,
      'rating': 4.9,
      'reviews': 127,
      'description': 'Spacious deluxe room with breathtaking ocean views and premium amenities.',
      'image': 'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=1974',
      'amenities': ['Ocean View', 'King Bed', 'Free WiFi', 'Breakfast'],
      'size': '45 m²',
    },
    {
      'id': 2,
      'name': 'Luxury Penthouse Suite',
      'category': 'Penthouse',
      'price': 580,
      'rating': 5.0,
      'reviews': 89,
      'description': 'Top-floor penthouse with panoramic city views and exclusive services.',
      'image': 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=2070',
      'amenities': ['City View', 'Private Terrace', 'Butler Service', 'Jacuzzi'],
      'size': '120 m²',
    },
    {
      'id': 3,
      'name': 'Executive Suite',
      'category': 'Suites',
      'price': 380,
      'rating': 4.8,
      'reviews': 156,
      'description': 'Elegant suite with separate living area and modern workspace.',
      'image': 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?q=80&w=1974',
      'amenities': ['Living Room', '2 Bathrooms', 'Work Desk', 'Mini Bar'],
      'size': '75 m²',
    },
    {
      'id': 4,
      'name': 'Coastal Ocean View',
      'category': 'Ocean View',
      'price': 220,
      'rating': 4.7,
      'reviews': 94,
      'description': 'Comfortable room with stunning ocean views and private balcony.',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=2070',
      'amenities': ['Balcony', 'Queen Bed', 'Sea View', 'Coffee Maker'],
      'size': '35 m²',
    },
    {
      'id': 5,
      'name': 'Modern Studio',
      'category': 'Studio',
      'price': 150,
      'rating': 4.6,
      'reviews': 203,
      'description': 'Compact studio with contemporary design and all essential amenities.',
      'image': 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?q=80&w=2070',
      'amenities': ['Kitchenette', 'Smart TV', 'Free WiFi', 'Air Conditioning'],
      'size': '28 m²',
    },
    {
      'id': 6,
      'name': 'Presidential Penthouse',
      'category': 'Penthouse',
      'price': 890,
      'rating': 5.0,
      'reviews': 42,
      'description': 'Ultimate luxury penthouse with private terrace and butler service.',
      'image': 'https://images.unsplash.com/photo-1611892440504-42a792e24d32?q=80&w=2070',
      'amenities': ['Private Pool', 'Helipad Access', 'Cinema Room', 'Chef Service'],
      'size': '250 m²',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) => "${date.day} ${_getMonth(date.month)}";

  String _getMonth(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  int get _totalNights => widget.dateRange.duration.inDays;

  List<Map<String, dynamic>> get _sortedRooms {
    final rooms = List<Map<String, dynamic>>.from(_availableRooms);
    switch (_sortBy) {
      case 'Price: Low to High':
        rooms.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price: High to Low':
        rooms.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Rating':
        rooms.sort((a, b) => b['rating'].compareTo(a['rating']));
        break;
      default:
        // Recommended - keep original order
        break;
    }
    return rooms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: darkGrey),
        ),
        title: Text(
          'Available Rooms',
          style: GoogleFonts.poppins(
            color: darkGrey,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: const Icon(Icons.sort, color: darkGrey),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSummary(),
          Expanded(
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _sortedRooms.length,
                  itemBuilder: (context, index) {
                    return _buildRoomCard(_sortedRooms[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Check-in',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(widget.dateRange.start),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: brandGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_totalNights nights',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: brandGold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Check-out',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(widget.dateRange.end),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.people_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                '${widget.adults} Adults, ${widget.children} Children',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${_sortedRooms.length} rooms available',
                style: const TextStyle(
                  fontSize: 14,
                  color: brandGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    final totalPrice = room['price'] * _totalNights;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomDetailsScreen(roomId: room['id']),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    room['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${room['rating']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: brandGold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      room['category'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Room Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: darkGrey,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          room['size'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    room['description'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Amenities
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (room['amenities'] as List<String>).take(3).map((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: brandGold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getAmenityIcon(amenity),
                              size: 14,
                              color: brandGold,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              amenity,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: brandGold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${room['price']} / night',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$$totalPrice total',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: brandGold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoomDetailsScreen(roomId: room['id']),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkGrey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
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

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'ocean view':
      case 'sea view':
      case 'city view':
        return Icons.visibility_outlined;
      case 'king bed':
      case 'queen bed':
        return Icons.bed_outlined;
      case 'free wifi':
        return Icons.wifi;
      case 'breakfast':
        return Icons.restaurant_outlined;
      case 'balcony':
        return Icons.balcony_outlined;
      case 'private terrace':
        return Icons.deck_outlined;
      case 'butler service':
      case 'chef service':
        return Icons.room_service_outlined;
      case 'jacuzzi':
      case 'private pool':
        return Icons.hot_tub_outlined;
      case 'living room':
        return Icons.chair_outlined;
      case '2 bathrooms':
        return Icons.bathroom_outlined;
      case 'work desk':
        return Icons.desk_outlined;
      case 'mini bar':
        return Icons.local_bar_outlined;
      case 'kitchenette':
        return Icons.kitchen_outlined;
      case 'smart tv':
        return Icons.tv;
      case 'air conditioning':
        return Icons.ac_unit;
      case 'helipad access':
        return Icons.flight_outlined;
      case 'cinema room':
        return Icons.movie_outlined;
      case 'coffee maker':
        return Icons.coffee_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkGrey,
                ),
              ),
              const SizedBox(height: 20),
              ..._sortOptions.map((option) {
                final isSelected = _sortBy == option;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? brandGold : darkGrey,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: brandGold)
                      : null,
                  onTap: () {
                    setState(() => _sortBy = option);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
