import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:booking_app/screens/room_listing_screen.dart';
// import 'package:booking_app/screens/bookings_screen.dart';
// import 'package:booking_app/utils/route_transitions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Premium AppBar Header
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'LuxeStay Member',
          style: GoogleFonts.poppins(
            color: darkGrey,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: darkGrey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildActionSection(context),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: brandGold, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=2070'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: darkGrey,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Johnathan Doe',
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: darkGrey,
            ),
          ),
          Text(
            'Gold Elite Member',
            style: GoogleFonts.poppins(
              color: brandGold,
              fontWeight: FontWeight.w500,
              fontSize: 13,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("MEMBERSHIP & ACCOUNT"),
          const SizedBox(height: 12),
          _buildMenuCard([
            _buildMenuItem(Icons.person_outline, "Personal Information"),
            _buildMenuItem(Icons.credit_card_outlined, "Payment Methods"),
            _buildMenuItem(Icons.loyalty_outlined, "Rewards & Points"),
          ]),
          const SizedBox(height: 30),
          _buildSectionHeader("PREFERENCES"),
          const SizedBox(height: 12),
          _buildMenuCard([
            _buildMenuItem(Icons.favorite_border, "Saved Destinations"),
            _buildMenuItem(Icons.notifications_none, "Notifications"),
            _buildMenuItem(Icons.language_outlined, "Language & Currency"),
          ]),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                "SIGN OUT",
                style: GoogleFonts.poppins(
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "Version 2.4.0",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
            ),
          ),
          const SizedBox(height: 40), 
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade500,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: darkGrey, size: 22),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: darkGrey,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: () {},
    );
  }
}