import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _promo = true;
  bool _bookings = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: Text("Notifications", style: AppTextStyles.subHeading), elevation: 0, backgroundColor: Colors.white, iconTheme: const IconThemeData(color: AppColors.darkGrey)),
      body: Column(
        children: [
          _buildToggle("Promotions & Offers", "Get updates on special deals", _promo, (v) => setState(() => _promo = v)),
          _buildToggle("Booking Updates", "Confirmations and reminders", _bookings, (v) => setState(() => _bookings = v)),
        ],
      ),
    );
  }

  Widget _buildToggle(String title, String sub, bool val, Function(bool) onChanged) {
    return SwitchListTile(
      value: val,
      onChanged: onChanged,
      title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: AppTextStyles.caption),
      activeColor: AppColors.brandGold,
    );
  }
}