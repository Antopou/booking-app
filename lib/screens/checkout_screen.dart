import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';
import 'package:booking_app/screens/home_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final String roomName;
  final double pricePerNight;
  final String roomCode;
  final int adults;
  final int children;
  final DateTime checkInDate;
  final DateTime checkOutDate;

  const CheckoutScreen({
    super.key,
    required this.roomName,
    required this.pricePerNight,
    required this.roomCode,
    required this.adults,
    required this.children,
    required this.checkInDate,
    required this.checkOutDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text("Checkout", style: AppTextStyles.subHeading),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.darkGrey),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 24),
            Text("Payment Method", style: AppTextStyles.subHeading),
            const SizedBox(height: 16),
            _buildPaymentOption(Icons.credit_card, "Credit Card", "**** 4242", true),
            _buildPaymentOption(Icons.account_balance, "Bank Transfer", "Direct Payment", false),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _showSuccessDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandGold,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("CONFIRM & PAY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.hotel, color: AppColors.brandGold),
            const SizedBox(width: 12),
            Text(roomName, style: AppTextStyles.subHeading),
          ]),
          const Divider(height: 32),
          _buildSummaryRow("Dates", "Jan 15 - Jan 17"),
          _buildSummaryRow("Guests", "$adults Adults, $children Children"),
          const Divider(height: 32),
          _buildSummaryRow("Total Price", "\$${pricePerNight * 2}", isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? AppTextStyles.subHeading : AppTextStyles.body),
          Text(value, style: isTotal ? AppTextStyles.subHeading.copyWith(color: AppColors.brandGold) : AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title, String subtitle, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppColors.brandGold : Colors.transparent, width: 2),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.brandGold),
        title: Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.brandGold) : null,
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text("Booking Confirmed!", style: AppTextStyles.heading),
            const SizedBox(height: 8),
            const Text("Your stay has been successfully reserved.", textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen(initialIndex: 1)), (route) => false),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandGold),
              child: const Text("VIEW BOOKINGS", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}