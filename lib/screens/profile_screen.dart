import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';
import 'package:booking_app/screens/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("Profile", style: AppTextStyles.heading),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(radius: 55, backgroundColor: AppColors.brandGold, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 12),
            Text("John Doe", style: AppTextStyles.heading),
            Text("john.doe@example.com", style: AppTextStyles.body.copyWith(color: AppColors.grey)),
            const SizedBox(height: 30),
            const Divider(),
            _buildMenuItem(Icons.person_outline, "Personal Information"),
            _buildMenuItem(Icons.payment_outlined, "Payment Methods"),
            _buildMenuItem(Icons.notifications_none_outlined, "Notifications"),
            _buildMenuItem(Icons.language_outlined, "Language & Currency"),
            const Divider(),
            _buildMenuItem(Icons.logout, "Logout", isDestructive: true, onTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isDestructive = false, VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isDestructive ? Colors.red.withOpacity(0.1) : AppColors.brandGold.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: isDestructive ? Colors.red : AppColors.brandGold, size: 22),
      ),
      title: Text(title, style: AppTextStyles.body.copyWith(color: isDestructive ? Colors.red : AppColors.darkGrey, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.grey),
    );
  }
}