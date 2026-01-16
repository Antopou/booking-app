import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';
import 'package:booking_app/screens/room_listing_screen.dart'; // Reuse RoomCard

class SearchResultsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGrey),
        title: Column(
          children: [
            Text("Search Results", style: AppTextStyles.subHeading),
            Text("${adults + children} guests • ${dateRange.duration.inDays} nights", style: AppTextStyles.caption),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5, // Example count
        itemBuilder: (context, index) {
          // This would ideally use the same RoomCard widget defined in room_listing_screen.dart
          // or a more compact version if needed.
          return const Center(child: Text("Search Result Item (Uses RoomCard)"));
        },
      ),
    );
  }
}