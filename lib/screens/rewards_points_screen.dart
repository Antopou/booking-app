import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';

class RewardsPointsScreen extends StatelessWidget {
  const RewardsPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text("Rewards & Points", style: AppTextStyles.subHeading),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGrey),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildPointsHeader(),
            const SizedBox(height: 24),
            Align(alignment: Alignment.centerLeft, child: Text("Recent History", style: AppTextStyles.subHeading)),
            const SizedBox(height: 16),
            _buildHistoryItem("Booking at Ocean View", "+250 pts", "Jan 12, 2025", true),
            _buildHistoryItem("Reward Redemption", "-500 pts", "Jan 08, 2025", false),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.brandGold, Color(0xFFE5C185)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text("Current Balance", style: AppTextStyles.body.copyWith(color: Colors.white70)),
          const SizedBox(height: 8),
          Text("4,850", style: AppTextStyles.heading.copyWith(fontSize: 40, color: Colors.white)),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          Text("Gold Tier Member", style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String title, String points, String date, bool isEarned) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
            Text(date, style: AppTextStyles.caption),
          ]),
          Text(points, style: TextStyle(color: isEarned ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}