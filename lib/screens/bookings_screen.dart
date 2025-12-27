import 'package:flutter/material.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0; // 0: Upcoming, 1: Past, 2: Cancelled
  final Color goldAccent = const Color(0xFFB89146);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Colors.white,
      // --- UPDATED TOP NAVIGATION BAR (LuxeStay Brand) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the default back button
        leadingWidth: 150,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: goldAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'L',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'LuxeStay',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Bookings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage and track your reservations',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 24),

            // --- SUMMARY CARDS ---
            _buildStatCard(
              'Total Bookings',
              '2',
              goldAccent,
              Icons.calendar_month,
              const Color(0xFFFFF9EE),
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              'Upcoming',
              '1',
              Colors.green,
              Icons.calendar_today,
              const Color(0xFFEEFFF3),
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              'Total Spent',
              '\$500',
              Colors.orange,
              Icons.monetization_on,
              const Color(0xFFFFF4EE),
            ),

            const SizedBox(height: 24),

            // --- SEARCH BAR ---
            TextField(
              decoration: InputDecoration(
                hintText: 'Search bookings by room name or guest...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // --- TAB SELECTOR ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  _buildTab('Upcoming (1)', 0),
                  _buildTab('Past (0)', 1),
                  _buildTab('Cancelled (0)', 2),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- BOOKING CONTENT ---
            if (_selectedTab == 0) _buildBookingCard() else _buildEmptyState(),

            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  // In bookings_screen.dart, update the _buildBottomNavigationBar method
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 1, // Bookings tab is active
      onTap: (index) {
        if (index == 0) {
          // Navigate to Home
          Navigator.pushReplacementNamed(context, '/');
        } else if (index == 2) {
          // Navigate to Profile
          Navigator.pushReplacementNamed(context, '/profile');
        }
        // If index is 1 (Bookings), do nothing as we're already here
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

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
    Color bg,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    bool active = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? goldAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.white : Colors.grey,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deluxe Ocean View',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    '\$250',
                    style: TextStyle(
                      color: goldAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _statusBadge('confirmed', Colors.green),
              const SizedBox(width: 8),
              _statusBadge('pending', Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              _dateCol('Check-in', 'Dec 28, 2025'),
              const Spacer(),
              const Icon(
                Icons.calendar_month_outlined,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              _dateCol('Check-out', 'Dec 29, 2025'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text('1 nights', style: TextStyle(color: Colors.grey)),
              SizedBox(width: 16),
              Icon(Icons.person_outline, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text('1 guests', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _actionBtn('Modify', Colors.black, Colors.grey.shade300),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _actionBtn(
                  'Cancel Booking',
                  Colors.red,
                  Colors.red.shade100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'No bookings found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Text(
            'Your booking history will appear here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String txt, Color col) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: col.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        txt,
        style: TextStyle(color: col, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _dateCol(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _actionBtn(String label, Color col, Color border) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: TextStyle(color: col)),
    );
  }
}
