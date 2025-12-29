import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomDetailsScreen extends StatefulWidget {
  const RoomDetailsScreen({super.key});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);
  
  bool _isHovering = false;
  int _selectedImageIndex = 0; 
  
  final List<String> roomImages = [
    'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=1974',
    'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?q=80&w=2070',
    'https://images.unsplash.com/photo-1595571024048-45a59177f538?q=80&w=2070',
    // 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?q=80&w=1974',
    'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=2070', // Extra image to show scroll
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBackNavigation(),
            _buildHeroImageSection(),
            _buildImageGallery(), // Now scrollable
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleSection(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('About This Room'),
                  const SizedBox(height: 12),
                  Text(
                    'Spacious deluxe room with breathtaking ocean views. Features a king-size bed, modern bathroom with rain shower, and private balcony designed for ultimate comfort.',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600], height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Room Amenities'),
                  const SizedBox(height: 16),
                  _buildAmenitiesWrap(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Policies & Information'),
                  const SizedBox(height: 16),
                  _buildPolicyCard(Icons.access_time_rounded, 'Check-in/out', 'Check-in: 3:00 PM • Check-out: 11:00 AM'),
                  _buildPolicyCard(Icons.cancel_outlined, 'Cancellation', 'Free cancellation up to 48 hours before check-in'),
                  const SizedBox(height: 40),
                  _buildBookingCard(),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: brandGold, borderRadius: BorderRadius.circular(8)),
            child: const Text('L', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const SizedBox(width: 10),
          Text('LuxeStay', style: GoogleFonts.poppins(color: darkGrey, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
      centerTitle: true,
    );
  }

  Widget _buildBackNavigation() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.arrow_back, size: 18, color: Colors.black),
            const SizedBox(width: 12),
            Text('Back to Rooms', style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImageSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ZOOM EFFECT: AnimatedScale wraps the image
              AnimatedScale(
                scale: _isHovering ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: Image.network(
                  roomImages[_selectedImageIndex],
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Smaller Centered Label on Hover
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isHovering ? 1.0 : 0.0,
                child: Container(
                  height: 350,
                  width: double.infinity,
                  color: Colors.black.withAlpha((0.25 * 255).toInt()),
                  child: Center(
                    child: Text(
                      'View All Photos',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18, // Reduced size
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 90,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Makes images below hero scrollable
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: roomImages.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedImageIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedImageIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? brandGold : Colors.transparent,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  roomImages[index],
                  fit: BoxFit.cover,
                  color: isSelected ? null : Colors.white.withAlpha((0.7 * 255).toInt()),
                  colorBlendMode: isSelected ? null : BlendMode.modulate,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: brandGold, borderRadius: BorderRadius.circular(6)),
          child: Text('Deluxe', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text('Deluxe Ocean View', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: darkGrey))),
            Row(
              children: [
                const Icon(Icons.star, color: brandGold, size: 20),
                const SizedBox(width: 4),
                Text('4.8', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Text('(127 reviews)', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: darkGrey));
  }

  Widget _buildAmenitiesWrap() {
    final amenities = [
      {'icon': Icons.wifi, 'label': 'Free WiFi'},
      {'icon': Icons.ac_unit, 'label': 'Air Conditioning'},
      {'icon': Icons.tv, 'label': 'Smart TV'},
      {'icon': Icons.coffee_maker, 'label': 'Coffee Maker'},
      {'icon': Icons.lock_outline, 'label': 'Digital Safe'},
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: amenities.map((a) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(a['icon'] as IconData, size: 16, color: brandGold),
            const SizedBox(width: 8),
            Text(a['label'] as String, style: GoogleFonts.poppins(fontSize: 13, color: darkGrey, fontWeight: FontWeight.w500)),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildPolicyCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: brandGold.withAlpha((0.1 * 255).toInt()), radius: 18, child: Icon(icon, color: brandGold, size: 18)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: darkGrey)),
                Text(subtitle, style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: darkGrey,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TOTAL PRICE', style: GoogleFonts.poppins(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('\$250.00', style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: brandGold, borderRadius: BorderRadius.circular(8)),
                child: Text('Per Night', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGold,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text('Book Now', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

}