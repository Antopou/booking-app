import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkout_screen.dart';
import 'search_results_screen.dart';
import 'package:booking_app/models/room_model.dart';
import 'package:booking_app/services/room_service.dart';

class RoomDetailsScreen extends StatefulWidget {
  final int roomId;
  
  const RoomDetailsScreen({super.key, required this.roomId});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);
  
  // API state
  final RoomService _roomService = RoomService();
  Room? _room;
  bool _isLoading = true;
  String? _errorMessage;
  
  bool _isHovering = false;
  int _selectedImageIndex = 0;
  int _adults = 2;
  int _children = 1;
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  
  @override
  void initState() {
    super.initState();
    _checkInDate = DateTime.now().add(const Duration(days: 1));
    _checkOutDate = DateTime.now().add(const Duration(days: 4));
    _loadRoomDetails();
  }
  
  Future<void> _loadRoomDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final room = await _roomService.fetchRoomById(widget.roomId);
      setState(() {
        _room = room;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  
  List<String> get roomImages => _room?.imageUrls ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: brandGold),
            )
          : _errorMessage != null
              ? _buildErrorView()
              : _room == null
                  ? const Center(child: Text('Room not found'))
                  : _buildContent(),
    );
  }
  
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error loading room',
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
              onPressed: _loadRoomDetails,
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
      ),
    );
  }
  
  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (roomImages.isNotEmpty) _buildHeroImageSection(),
          if (roomImages.length > 1) _buildImageGallery(),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('About This Room'),
                  const SizedBox(height: 12),
                  Text(
                    _room?.description ?? 'No description available',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600], height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Room Amenities'),
                  const SizedBox(height: 16),
                  _buildAmenitiesWrap(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Policies & Information'),
                  const SizedBox(height: 16),
                  _buildPolicyCard(Icons.access_time_rounded, 'Check-in/out', 'Check-in: 3:00 PM • Check-out: 11:00 AM'),
                  _buildPolicyCard(Icons.cancel_outlined, 'Cancellation', 'Free cancellation up to 48 hours before check-in'),
                  const SizedBox(height: 40),
                  _buildBookingCard(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: brandGold, borderRadius: BorderRadius.circular(8)),
            child: const Text('L', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 10),
          Text('LuxeStay', style: GoogleFonts.poppins(color: darkGrey, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildHeroImageSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _openPhotoGallery(context),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // ZOOM EFFECT: AnimatedScale wraps the image
                AnimatedScale(
                  scale: _isHovering ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: Image.network(
                    roomImages[_selectedImageIndex],
                    height: 350,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Smaller Centered Label on Hover
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isHovering ? 1.0 : 0.0,
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    color: Colors.black.withAlpha((0.25 * 255).toInt()),
                    child: Center(
                      child: Text(
                        'View All Photos',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18, // Reduced size
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPhotoGallery(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PhotoGalleryScreen(
          images: roomImages,
          initialIndex: _selectedImageIndex,
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Makes images below hero scrollable
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: roomImages.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedImageIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedImageIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? brandGold : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  roomImages[index],
                  fit: BoxFit.cover,
                  color: isSelected ? null : Colors.white.withAlpha((0.7 * 255).toInt()),
                  colorBlendMode: isSelected ? null : BlendMode.modulate,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: brandGold, borderRadius: BorderRadius.circular(6)),
          child: Text(_room?.roomTypeName ?? 'Room', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(_room?.title ?? 'Room', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: darkGrey))),
            Row(
              children: [
                const Icon(Icons.star, color: brandGold, size: 20),
                const SizedBox(width: 4),
                Text('${_room?.rating ?? 0}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Text('(${_room?.totalReviews ?? 0} reviews)', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: darkGrey));
  }

  Widget _buildAmenitiesWrap() {
    final amenities = <Map<String, dynamic>>[];
    
    if (_room?.hasWifi == true) {
      amenities.add({'icon': Icons.wifi, 'label': 'Free WiFi'});
    }
    if (_room?.hasTv == true) {
      amenities.add({'icon': Icons.tv, 'label': 'Smart TV'});
    }
    if (_room?.hasAc == true) {
      amenities.add({'icon': Icons.ac_unit, 'label': 'Air Conditioning'});
    }
    if (_room?.hasBreakfast == true) {
      amenities.add({'icon': Icons.restaurant, 'label': 'Breakfast'});
    }
    if (_room?.hasParking == true) {
      amenities.add({'icon': Icons.local_parking, 'label': 'Parking'});
    }
    
    if (amenities.isEmpty) {
      return Text(
        'Standard room amenities included',
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
      );
    }
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: amenities.map((a) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(a['icon'] as IconData, size: 16, color: brandGold),
            const SizedBox(width: 8),
            Text(a['label'] as String, style: GoogleFonts.poppins(fontSize: 13, color: darkGrey, fontWeight: FontWeight.w500)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildPolicyCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: brandGold.withAlpha((0.1 * 255).toInt()), radius: 18, child: Icon(icon, color: brandGold, size: 18)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: darkGrey)),
                Text(subtitle, style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildBookingCard() {
    final price = _room?.pricePerNight ?? 0;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: darkGrey,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: brandGold.withOpacity(0.3), blurRadius: 25, offset: const Offset(0, 15))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\$$price.00', style: GoogleFonts.poppins(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600)),
                  Text('avg / night', style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
              IconButton(
                onPressed: _showPriceBreakdown,
                icon: const Icon(Icons.info_outline, color: Colors.grey, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _showGuestPicker,
            child: _buildDarkInput('GUESTS', '$_adults Adults, $_children Child', Icons.people_outline),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 60,
            child: ElevatedButton(
              onPressed: () {
                // Use last filter payload if available
                final filter = SearchResultsScreenState.lastFilterPayload;
                final checkInDate = filter != null
                    ? DateTime.parse(filter['checkIn'])
                    : _checkInDate;
                final checkOutDate = filter != null
                    ? DateTime.parse(filter['checkOut'])
                    : _checkOutDate;
                final adults = filter != null ? filter['adults'] as int : _adults;
                final children = filter != null ? filter['children'] as int : _children;
                final nights = checkOutDate.difference(checkInDate).inDays;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      roomName: _room?.title ?? 'Room',
                      roomCode: _room?.roomCode ?? 'ROOM-00001',
                      pricePerNight: (_room?.pricePerNight ?? 0).toDouble(),
                      adults: adults,
                      children: children,
                      checkInDate: checkInDate,
                      checkOutDate: checkOutDate,
                      nights: nights,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGold,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text('RESERVE NOW', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkInput(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
      child: Row(
        children: [
          Icon(icon, color: brandGold, size: 18),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              Text(value, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white54, size: 18),
        ],
      ),
    );
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
                  Text("Select Guests", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      child: Text("Confirm Guests", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
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

  void _showPriceBreakdown() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Price Breakdown', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPriceRow('Room rate', '\$250.00'),
            _buildPriceRow('Service fee', '\$25.00'),
            _buildPriceRow('Taxes', '\$30.00'),
            const Divider(height: 24),
            _buildPriceRow('Total per night', '\$305.00', isBold: true),
            const SizedBox(height: 12),
            Text(
              '* Final price may vary based on length of stay and booking dates',
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CLOSE', style: GoogleFonts.poppins(color: brandGold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isBold ? 15 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? darkGrey : Colors.grey[700],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: isBold ? 15 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? brandGold : darkGrey,
            ),
          ),
        ],
      ),
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
}

// Full-screen Photo Gallery
class _PhotoGalleryScreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const _PhotoGalleryScreen({
    required this.images,
    required this.initialIndex,
  });

  @override
  State<_PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<_PhotoGalleryScreen> {
  late PageController _pageController;
  late int _currentIndex;
  static const Color brandGold = Color(0xFFC5A368);

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen PageView for images
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          
          // Top bar with close button and counter
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.images.length}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the layout
                ],
              ),
            ),
          ),
          
          // Bottom image indicators
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? brandGold : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}