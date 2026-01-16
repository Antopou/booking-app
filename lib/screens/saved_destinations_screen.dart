import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';

class SavedDestinationsScreen extends StatelessWidget {
  const SavedDestinationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text("Saved", style: AppTextStyles.subHeading), elevation: 0, backgroundColor: Colors.white, iconTheme: const IconThemeData(color: AppColors.darkGrey)),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: const DecorationImage(image: NetworkImage("https://via.placeholder.com/400x120"), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: LinearGradient(colors: [Colors.black.withOpacity(0.6), Colors.transparent], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bali, Indonesia", style: AppTextStyles.subHeading.copyWith(color: Colors.white)),
                Text("Saved on Jan 12, 2025", style: AppTextStyles.caption.copyWith(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}