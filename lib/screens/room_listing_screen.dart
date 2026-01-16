import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';
import 'package:booking_app/screens/room_details_screen.dart';
import 'package:booking_app/models/room_model.dart';
import 'package:booking_app/services/room_service.dart';

class RoomListingScreen extends StatefulWidget {
  const RoomListingScreen({super.key});

  @override
  State<RoomListingScreen> createState() => _RoomListingScreenState();
}

class _RoomListingScreenState extends State<RoomListingScreen> {
  final RoomService _roomService = RoomService();
  String _selectedFilter = "All Rooms";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            _buildFilters(),
            _buildRoomList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Find your", style: AppTextStyles.body),
            Text("Perfect Escape", style: AppTextStyles.heading.copyWith(fontSize: 28)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    final filters = ["All Rooms", "Single", "Double", "Suite"];
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedFilter == filters[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ChoiceChip(
                label: Text(filters[index]),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedFilter = filters[index]);
                },
                selectedColor: AppColors.brandGold,
                labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.darkGrey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoomList() {
    return FutureBuilder<List<Room>>(
      // Updated: Changed getRooms() to fetchRooms()
      future: _roomService.fetchRooms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return SliverFillRemaining(child: Center(child: Text("Error: ${snapshot.error}")));
        }
        
        final rooms = snapshot.data ?? [];
        final filteredRooms = _selectedFilter == "All Rooms" 
            ? rooms 
            : rooms.where((r) => r.roomTypeName == _selectedFilter).toList();

        return SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _RoomCard(room: filteredRooms[index]),
              childCount: filteredRooms.length,
            ),
          ),
        );
      },
    );
  }
}

class _RoomCard extends StatelessWidget {
  final Room room;
  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RoomDetailsScreen(roomId: room.id))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              // Updated: Using withValues for modern Flutter API
              color: Colors.black.withValues(alpha: 0.05), 
              blurRadius: 10, 
              offset: const Offset(0, 4)
            )
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              // Updated: Changed room.image to room.imageUrl
              child: Image.network(room.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Updated: Changed room.name to room.title
                    Text(room.title, style: AppTextStyles.subHeading),
                    const SizedBox(height: 4),
                    // Updated: Changed room.price to room.pricePerNight
                    Text("\$${room.pricePerNight} / night", 
                      style: const TextStyle(color: AppColors.brandGold, fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ]),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}