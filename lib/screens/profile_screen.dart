import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color goldAccent = const Color(0xFFB89146);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: goldAccent,
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Edit profile action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Menu Items
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Personal Information',
              onTap: () {
                // Navigate to personal info
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.credit_card_outlined,
              title: 'Payment Methods',
              onTap: () {
                // Navigate to payment methods
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.history_outlined,
              title: 'Booking History',
              onTap: () {
                // Navigate to booking history
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: 'Wishlist',
              onTap: () {
                // Navigate to wishlist
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {
                // Navigate to help center
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About Us',
              onTap: () {
                // Navigate to about us
              },
            ),
            _buildDivider(),
            _buildMenuItem(
              icon: Icons.logout_outlined,
              title: 'Logout',
              textColor: Colors.red,
              onTap: () {
                // Handle logout
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, goldAccent),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.black87,
          fontSize: 16,
        ),
      ),
      trailing: textColor == null
          ? const Icon(Icons.chevron_right, color: Colors.grey)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFF0F0F0),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, Color goldAccent) {
    return BottomNavigationBar(
      currentIndex: 2, // Profile tab is active
      onTap: (index) {
        if (index == 0) {
          // Navigate to Home
          Navigator.pushReplacementNamed(context, '/');
        } else if (index == 1) {
          // Navigate to Bookings
          Navigator.pushReplacementNamed(context, '/bookings');
        }
        // If index is 2 (Profile), do nothing as we're already here
      },
      selectedItemColor: goldAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Rooms',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'My Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}