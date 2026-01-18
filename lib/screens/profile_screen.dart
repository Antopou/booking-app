import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:booking_app/screens/login_screen.dart';
import 'package:booking_app/screens/personal_information_screen.dart';
import 'package:booking_app/screens/payment_methods_screen.dart';
import 'package:booking_app/screens/rewards_points_screen.dart';
import 'package:booking_app/screens/saved_destinations_screen.dart';
import 'package:booking_app/screens/notifications_screen.dart';
import 'package:booking_app/screens/language_currency_screen.dart';
import 'package:booking_app/services/auth_service.dart';
import 'package:booking_app/services/user_service.dart';
import 'package:booking_app/models/user_profile_models.dart';
import 'package:booking_app/utils/route_transitions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);

  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  bool? _isAuthenticated;
  UserProfile? _userProfile;
  // ignore: unused_field
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAuthenticationAndFetchProfile();
  }

  Future<void> _checkAuthenticationAndFetchProfile() async {
    final token = await _authService.getToken();
    
    if (token == null || token.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isAuthenticated = false;
      });
      return;
    }

    setState(() {
      _isAuthenticated = true;
    });

    try {
      final response = await _userService.getProfile();
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _userProfile = response.data;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    await _authService.logout();
    
    if (!context.mounted) return;
    
    Navigator.of(context).pushAndRemoveUntil(
      RouteTransitions.fadeIn(const LoginScreen()),
      (route) => false,
    );
  }

  void _handleLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

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
      body: _isAuthenticated == null
          ? _buildLoadingSpinner()
          : (_isAuthenticated! ? _buildAuthenticatedProfile() : _buildLoginPrompt()),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: brandGold),
            const SizedBox(height: 24),
            Text(
              'Welcome to LuxeStay',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkGrey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Sign in to access your account and manage your profile',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => _handleLogin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'SIGN IN',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSpinner() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(brandGold),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          Text(
            'Loading profile...',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedProfile() {
    return RefreshIndicator(
      onRefresh: _checkAuthenticationAndFetchProfile,
      color: brandGold,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildActionSection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final displayName = _userProfile?.displayName ?? 'Loading...';
    final membershipLevel = _userProfile?.membershipLevel ?? 'Standard';
    final profileImage = _userProfile?.profileImage;

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
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null
                      ? NetworkImage(profileImage)
                      : const NetworkImage(
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
            displayName,
            style: GoogleFonts.playfairDisplay(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: darkGrey,
            ),
          ),
          Text(
            '$membershipLevel Member',
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
              onPressed: () => _handleSignOut(context),
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
            color: Colors.black.withValues(alpha: 0.04),
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
      onTap: () {
        _handleMenuTap(context, title);
      },
    );
  }

  void _handleMenuTap(BuildContext context, String menuTitle) {
    switch (menuTitle) {
      case "Personal Information":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalInformationScreen(
              userProfile: _userProfile,
              onProfileUpdated: () => _checkAuthenticationAndFetchProfile(),
            ),
          ),
        );
        break;
      case "Payment Methods":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentMethodsScreen()),
        );
        break;
      case "Rewards & Points":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RewardsPointsScreen()),
        );
        break;
      case "Saved Destinations":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavedDestinationsScreen()),
        );
        break;
      case "Notifications":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        );
        break;
      case "Language & Currency":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LanguageCurrencyScreen()),
        );
        break;
    }
  }
}