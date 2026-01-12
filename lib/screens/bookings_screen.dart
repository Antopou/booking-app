import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0; // 0: Upcoming, 1: Past, 2: Cancelled
  final List<bool> _tabHover = [false, false, false];
  
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color lightBackground = Color(0xFFF5F5F5); // Clean track color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'LuxeStay Reservations',
          style: GoogleFonts.poppins(
            color: darkGrey,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER SECTION ---
            const SizedBox(height: 15),
            Text(
              'My Stays',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkGrey,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Upcoming and past luxury experiences',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 30),

            // --- STATS ROW ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildMiniStat('TOTAL STAYS', '02', darkGrey),
                  const SizedBox(width: 12),
                  _buildMiniStat('UPCOMING', '01', brandGold),
                  const SizedBox(width: 12),
                  _buildMiniStat('REWARDS', '1.2k', Colors.blueGrey),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // --- OPTION 2 TAB SELECTOR (With Refined Hover) ---
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: lightBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  _buildTab('Upcoming', 0),
                  _buildTab('Past', 1),
                  _buildTab('Cancelled', 2),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- BOOKING CONTENT ---
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedTab == 0 ? _buildBookingCard() : _buildEmptyState(),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String title, String value, Color accentColor) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              )),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: accentColor,
              )),
        ],
      ),
    );
  }

  // REFINED TAB METHOD: Clear state separation to avoid "Stain" look
  Widget _buildTab(String label, int index) {
    bool active = _selectedTab == index;
    bool hovering = _tabHover[index];

    return Expanded(
      child: MouseRegion(
        // Ensure the hover state is captured correctly
        onEnter: (_) => setState(() => _tabHover[index] = true),
        onExit: (_) => setState(() => _tabHover[index] = false),
        child: GestureDetector(
          onTap: () => setState(() => _selectedTab = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150), // Snappier response
            curve: Curves.easeOut,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              // PRIORITY: 
              // 1. If active, stay white.
              // 2. If NOT active and mouse is on it, stay dark grey.
              // 3. Otherwise, stay transparent.
              color: active 
                  ? Colors.white 
                  : (hovering ? Colors.grey.shade500 : Colors.transparent),
              borderRadius: BorderRadius.circular(16),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: active ? darkGrey : (hovering ? Colors.black : Colors.grey.shade600),
                fontWeight: active || hovering ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=1974',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _statusBadge('Confirmed', Colors.green.shade600),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Deluxe Ocean View',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dateInfo('CHECK-IN', '28 Dec 2025'),
                    Container(height: 30, width: 1, color: Colors.grey.shade100),
                    _dateInfo('CHECK-OUT', '29 Dec 2025'),
                  ],
                ),
                const Divider(height: 48, thickness: 0.8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TOTAL PRICE',
                            style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 10,
                                letterSpacing: 1.0)),
                        Text('\$250.00',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: darkGrey)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGrey,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('MANAGE',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 1.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateInfo(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                color: Colors.grey.shade400,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2)),
        const SizedBox(height: 4),
        Text(date,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500, fontSize: 15, color: darkGrey)),
      ],
    );
  }

  Widget _statusBadge(String txt, Color col) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
          ]),
      child: Text(
        txt.toUpperCase(),
        style: GoogleFonts.poppins(
            color: col,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      key: const ValueKey('empty'),
      child: Column(
        children: [
          const SizedBox(height: 80),
          Icon(Icons.auto_awesome_outlined,
              size: 60, color: brandGold.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text('No History Yet',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Your luxury stays will appear here.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)),
        ],
      ),
    );
  }
}
