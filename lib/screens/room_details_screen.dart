import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:booking_app/utils/app_constants.dart';
import 'package:booking_app/screens/checkout_screen.dart';
import 'package:booking_app/models/room_model.dart';
import 'package:booking_app/services/room_service.dart';

class RoomDetailsScreen extends StatefulWidget {
  final int roomId;
  const RoomDetailsScreen({super.key, required this.roomId});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  final RoomService _roomService = RoomService();
  bool _isLoading = true;
  Room? _room;

  @override
  void initState() {
    super.initState();
    _fetchRoomDetails();
  }

  void _fetchRoomDetails() async {
    try {
      // Changed getRoomById to fetchRoomById to match your RoomService
      final room = await _roomService.fetchRoomById(widget.roomId);
      if (mounted) {
        setState(() {
          _room = room;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading room: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.brandGold)),
      );
    }
    
    if (_room == null) {
      return const Scaffold(
        body: Center(child: Text("Room not found")),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Changed .name to .title
                      Expanded(
                        child: Text(
                          _room!.title, 
                          style: AppTextStyles.heading.copyWith(fontSize: 26)
                        ),
                      ),
                      const Icon(Icons.favorite_border, color: AppColors.brandGold),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppColors.brandGold, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        _room!.rating.toString(), 
                        style: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                      const SizedBox(width: 4),
                      Text("(${_room!.totalReviews} reviews)", style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text("Description", style: AppTextStyles.subHeading),
                  const SizedBox(height: 12),
                  Text(
                    _room!.description, 
                    style: AppTextStyles.body.copyWith(color: AppColors.grey, height: 1.6)
                  ),
                  const SizedBox(height: 24),
                  _buildAmenitiesGrid(),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBookingBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: AppColors.brandGold,
      flexibleSpace: FlexibleSpaceBar(
        // Changed .image to .imageUrl
        background: Image.network(
          _room!.imageUrl, 
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50),
          ),
        ),
      ),
    );
  }

  Widget _buildAmenitiesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Amenities", style: AppTextStyles.subHeading),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _room!.amenities.map((amenity) => _buildAmenityChip(amenity)).toList(),
        ),
      ],
    );
  }

  Widget _buildAmenityChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.brandGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColors.brandGold, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildBottomBookingBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // Replaced deprecated withOpacity with withValues
            color: Colors.black.withValues(alpha: 0.05), 
            blurRadius: 10, 
            offset: const Offset(0, -4)
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Price", style: AppTextStyles.caption),
                // Changed .price to .pricePerNight
                Text(
                  "\$${_room!.pricePerNight}", 
                  style: AppTextStyles.subHeading.copyWith(
                    color: AppColors.brandGold, 
                    fontSize: 20
                  )
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_) => CheckoutScreen(
                    // Corrected model field names for parameters
                    roomName: _room!.title, 
                    pricePerNight: _room!.pricePerNight.toDouble(), 
                    roomCode: _room!.roomCode, 
                    adults: 2, 
                    children: 0, 
                    checkInDate: DateTime.now(), 
                    checkOutDate: DateTime.now().add(const Duration(days: 2))
                  )
                )
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGrey,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "BOOK NOW", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            )
          ],
        ),
      ),
    );
  }
}