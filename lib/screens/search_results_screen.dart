import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:booking_app/screens/room_details_screen.dart';
import 'package:booking_app/config/api_config.dart';
import 'package:booking_app/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  State<SearchResultsScreen> createState() => SearchResultsScreenState();
}

class SearchResultsScreenState extends State<SearchResultsScreen> with SingleTickerProviderStateMixin {
  // Store the last filter payload for later use (e.g., for booking)
  static Map<String, dynamic>? _lastFilterPayload;
  static Map<String, dynamic>? get lastFilterPayload => _lastFilterPayload;
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  String _sortBy = 'Recommended';
  List<String> get _sortOptions => [
    AppLocalizations.of(context)!.recommended,
    AppLocalizations.of(context)!.priceLowToHigh,
    AppLocalizations.of(context)!.priceHighToLow,
    AppLocalizations.of(context)!.rating,
  ];

  List<Map<String, dynamic>> _availableRooms = [];
  bool _isLoading = true;
  String? _errorMessage;

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

    _fetchAvailableRooms();
    _controller.forward();
  }

  Future<void> _fetchAvailableRooms() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final checkIn = widget.dateRange.start.toIso8601String().split('T').first;
      final checkOut = widget.dateRange.end.toIso8601String().split('T').first;
      // Save the filter payload for later use
      _lastFilterPayload = {
        'checkIn': checkIn,
        'checkOut': checkOut,
        'adults': widget.adults,
        'children': widget.children,
      };
      final url = Uri.parse('${ApiConfig.baseUrl}/rooms/availability?checkIn=$checkIn&checkOut=$checkOut&adults=${widget.adults}&children=${widget.children}');
      final response = await http.get(url, headers: ApiConfig.defaultHeaders);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List rooms = json['data'] ?? [];
        setState(() {
          _availableRooms = rooms.map<Map<String, dynamic>>((e) => _mapApiRoomToUi(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load rooms. (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load rooms.';
        _isLoading = false;
      });
    }
  }

  Map<String, dynamic> _mapApiRoomToUi(Map<String, dynamic> apiRoom) {
    // Map API fields to UI fields
    return {
      'id': apiRoom['id'],
      'name': apiRoom['name'] ?? '',
      'category': apiRoom['roomTypeName'] ?? '',
      'price': apiRoom['pricePerNight'] ?? 0,
      'rating': (apiRoom['rating'] ?? 0).toDouble(),
      'reviews': apiRoom['totalReviews'] ?? 0,
      'description': apiRoom['description'] ?? '',
      'image': apiRoom['image'] ?? 'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=1974',
      'amenities': _extractAmenities(apiRoom),
      'size': 'N/A',
    };
  }

  List<String> _extractAmenities(Map<String, dynamic> apiRoom) {
    final amenities = <String>[];
    if (apiRoom['hasWifi'] == true) amenities.add('Free WiFi');
    if (apiRoom['hasTv'] == true) amenities.add('Smart TV');
    if (apiRoom['hasAc'] == true) amenities.add('Air Conditioning');
    if (apiRoom['hasBreakfast'] == true) amenities.add('Breakfast');
    if (apiRoom['hasParking'] == true) amenities.add('Parking');
    return amenities;
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
    final localizations = AppLocalizations.of(context)!;
    
    if (_sortBy == localizations.priceLowToHigh) {
      rooms.sort((a, b) => a['price'].compareTo(b['price']));
    } else if (_sortBy == localizations.priceHighToLow) {
      rooms.sort((a, b) => b['price'].compareTo(a['price']));
    } else if (_sortBy == localizations.rating) {
      rooms.sort((a, b) => b['rating'].compareTo(a['rating']));
    }
    // else Recommended - keep original order
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
          AppLocalizations.of(context)!.availableRooms,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    _buildSearchSummary(),
                    Expanded(
                      child: _sortedRooms.isEmpty
                          ? Center(child: Text(AppLocalizations.of(context)!.noRoomsAvailable))
                          : FadeTransition(
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
                      AppLocalizations.of(context)!.checkIn,
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
                  AppLocalizations.of(context)!.nightsLabel(_totalNights),
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
                      AppLocalizations.of(context)!.checkOut,
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
                AppLocalizations.of(context)!.adultsChildren(widget.adults, widget.children),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.roomsAvailableCount(_sortedRooms.length),
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
                              '\$${room['price']} ${AppLocalizations.of(context)!.perNight}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$$totalPrice ${AppLocalizations.of(context)!.totalPrice}',
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
                        child: Text(
                          AppLocalizations.of(context)!.bookNow,
                          style: const TextStyle(
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
                AppLocalizations.of(context)!.sortBy,
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
              }),
            ],
          ),
        );
      },
    );
  }
}
