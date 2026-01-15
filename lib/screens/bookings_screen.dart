import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:booking_app/services/booking_service.dart';
import 'package:booking_app/services/auth_service.dart';
import 'package:booking_app/models/booking_models.dart';
import 'login_screen.dart';

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
  static const Color lightBackground = Color(0xFFF5F5F5);

  final BookingService _bookingService = BookingService();
  final AuthService _authService = AuthService();
  late Future<BookingListResponse> _bookingsFuture;
  List<BookingListItem> _allBookings = [];
  bool _isLoading = true;
  bool? _isAuthenticated;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkAuthAndFetchBookings();
  }

  Future<void> _checkAuthAndFetchBookings() async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _isAuthenticated = false;
        _isLoading = false;
      });
      return;
    }
    
    setState(() {
      _isAuthenticated = true;
    });
    _bookingsFuture = _fetchBookings();
  }

  Future<BookingListResponse> _fetchBookings() async {
    try {
      final response = await _bookingService.fetchBookings();
      setState(() {
        _allBookings = response.data;
        _isLoading = false;
        _errorMessage = null;
      });
      return response;
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      throw e;
    }
  }

  List<BookingListItem> get _upcomingBookings {
    return _allBookings.where((b) {
      return !b.isCancelled && 
             b.status == 'confirmed' &&
             b.checkInDate.isAfter(DateTime.now());
    }).toList();
  }

  List<BookingListItem> get _pastBookings {
    return _allBookings.where((b) {
      return !b.isCancelled && b.status == 'completed';
    }).toList();
  }

  List<BookingListItem> get _cancelledBookings {
    return _allBookings.where((b) => b.isCancelled).toList();
  }

  double get _totalSpent {
    return _allBookings.fold(0, (sum, booking) => sum + booking.totalPrice);
  }

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
      body: _isAuthenticated == null
          ? _buildLoadingSpinner()
          : (_isAuthenticated! ? _buildAuthenticatedContent() : _buildLoginPrompt()),
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
            'Loading your bookings...',
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

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outlined, size: 80, color: brandGold),
            const SizedBox(height: 24),
            Text(
              'Sign In to View Bookings',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkGrey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Access your reservations and manage your stays',
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
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

  Widget _buildAuthenticatedContent() {
    return SingleChildScrollView(
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
                  _buildMiniStat('TOTAL STAYS', '${_allBookings.length.toString().padLeft(2, '0')}', darkGrey),
                  const SizedBox(width: 12),
                  _buildMiniStat('UPCOMING', '${_upcomingBookings.length.toString().padLeft(2, '0')}', brandGold),
                  const SizedBox(width: 12),
                  _buildMiniStat('TOTAL SPENT', '\$${_totalSpent.toStringAsFixed(0)}', Colors.blueGrey),
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
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: CircularProgressIndicator(color: brandGold),
                    ),
                  )
                : _errorMessage != null
                    ? _buildErrorState()
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _selectedTab == 0
                            ? (_upcomingBookings.isEmpty
                                ? _buildEmptyState()
                                : ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: _upcomingBookings.length,
                                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                                    itemBuilder: (_, index) => _buildBookingCard(_upcomingBookings[index]),
                                  ))
                            : _selectedTab == 1
                                ? (_pastBookings.isEmpty
                                    ? _buildEmptyState()
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _pastBookings.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                                        itemBuilder: (_, index) => _buildBookingCard(_pastBookings[index]),
                                      ))
                                : (_cancelledBookings.isEmpty
                                    ? _buildEmptyState()
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: _cancelledBookings.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                                        itemBuilder: (_, index) => _buildBookingCard(_cancelledBookings[index]),
                                      )),
                      ),

            const SizedBox(height: 120),
          ],
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

  Widget _buildBookingCard(BookingListItem booking) {
    final statusColor = booking.isCancelled 
        ? Colors.red.shade600 
        : booking.status == 'confirmed' 
            ? Colors.green.shade600 
            : Colors.blue.shade600;
    
    final statusText = booking.isCancelled ? 'Cancelled' : (booking.status[0].toUpperCase() + booking.status.substring(1));
    
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
                  booking.roomImage,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: _statusBadge(statusText, statusColor),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.roomName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkGrey,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _dateInfo('CHECK-IN', _formatDate(booking.checkInDate)),
                    Container(height: 30, width: 1, color: Colors.grey.shade100),
                    _dateInfo('CHECK-OUT', _formatDate(booking.checkOutDate)),
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
                        Text('\$${booking.totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: darkGrey)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final index = _allBookings.indexWhere((b) => b.checkinCode == booking.checkinCode);
                        if (index != -1) _showManageBookingSheet(context, index);
                      },
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

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Error loading bookings',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                  _bookingsFuture = _fetchBookings();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'RETRY',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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

  void _showManageBookingSheet(BuildContext context, int bookingIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => _buildManageBookingSheet(
          bookingIndex,
          setSheetState,
          () => setState(() {}), // callback to refresh parent
        ),
      ),
    );
  }

  Widget _buildManageBookingSheet(int bookingIndex, StateSetter setSheetState, VoidCallback refreshParent) {
    final booking = _allBookings[bookingIndex];
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Booking',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: darkGrey,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Booking Info Card
                  _buildInfoCard(booking),
                  const SizedBox(height: 24),

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildActionButton(
                    icon: Icons.edit_calendar_outlined,
                    title: 'Modify Dates',
                    subtitle: 'Change check-in or check-out dates',
                    color: brandGold,
                    onTap: () => _showModifyDatesDialog(context, bookingIndex, setSheetState, refreshParent),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    icon: Icons.group_outlined,
                    title: 'Update Guests',
                    subtitle: 'Change number of guests',
                    color: Colors.blue,
                    onTap: () => _showUpdateGuestsDialog(context, bookingIndex, setSheetState, refreshParent),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    icon: Icons.receipt_long_outlined,
                    title: 'View Confirmation',
                    subtitle: 'Booking ID: ${booking.checkinCode.substring(0, 8).toUpperCase()}',
                    color: Colors.green,
                    onTap: () => _showConfirmationDialog(context, booking),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Support',
                    subtitle: 'Get help with your booking',
                    color: Colors.purple,
                    onTap: () => _showContactSupportDialog(context, booking),
                  ),
                  const SizedBox(height: 24),

                  // Danger Zone
                  Text(
                    'Cancellation',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkGrey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildActionButton(
                    icon: Icons.cancel_outlined,
                    title: 'Cancel Booking',
                    subtitle: 'Free cancellation until ${_formatDate(booking.checkInDate.subtract(const Duration(days: 2)))}',
                    color: Colors.red,
                    onTap: () => _showCancelBookingDialog(context, booking.checkinCode),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BookingListItem booking) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [brandGold.withOpacity(0.1), brandGold.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: brandGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hotel_outlined, color: brandGold, size: 20),
              const SizedBox(width: 8),
              Text(
                booking.roomName,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHECK-IN',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(booking.checkInDate),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CHECK-OUT',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(booking.checkOutDate),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.people_outline, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                '${booking.checkOutDate.difference(booking.checkInDate).inDays} night(s)',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _showModifyDatesDialog(BuildContext context, int bookingIndex, StateSetter setSheetState, VoidCallback refreshParent) {
    final booking = _allBookings[bookingIndex];
    DateTime checkInDate = booking.checkInDate;
    DateTime checkOutDate = booking.checkOutDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Modify Dates - ${booking.roomName}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update check-in and check-out dates',
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),
                
                // Check-in Date Selector
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: checkInDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2026, 12, 31),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(primary: brandGold),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setDialogState(() {
                        checkInDate = picked;
                        if (checkOutDate.isBefore(checkInDate.add(const Duration(days: 1)))) {
                          checkOutDate = checkInDate.add(const Duration(days: 1));
                        }
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: brandGold, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CHECK-IN',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${checkInDate.day} ${_getMonthName(checkInDate.month)} ${checkInDate.year}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.edit_calendar, color: Colors.grey.shade400, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Check-out Date Selector
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: checkOutDate,
                      firstDate: checkInDate.add(const Duration(days: 1)),
                      lastDate: DateTime(2026, 12, 31),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(primary: brandGold),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setDialogState(() => checkOutDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: brandGold, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CHECK-OUT',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${checkOutDate.day} ${_getMonthName(checkOutDate.month)} ${checkOutDate.year}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.edit_calendar, color: Colors.grey.shade400, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Duration Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: brandGold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.nights_stay, color: brandGold, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '${checkOutDate.difference(checkInDate).inDays} night(s) • Estimated: \$${checkOutDate.difference(checkInDate).inDays * 250}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: darkGrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL', style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close Modify Dates dialog
                
                try {
                  // Show loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Updating dates...',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ],
                      ),
                      backgroundColor: brandGold,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                  
                  // Call API to update booking
                  await _bookingService.updateBooking(
                    checkinCode: booking.checkinCode,
                    checkInDate: checkInDate,
                    checkOutDate: checkOutDate,
                    numberOfGuests: booking.checkinCode.length,
                    adults: 0,
                    children: 0,
                  );
                  
                  // Refresh the specific booking data from API
                  final updatedBookingDetail = await _bookingService.findBooking(booking.checkinCode);
                  
                  // Update the local list
                  final index = _allBookings.indexWhere((b) => b.checkinCode == booking.checkinCode);
                  if (index != -1 && mounted) {
                    setSheetState(() {
                      _allBookings[index] = BookingListItem(
                        checkinCode: updatedBookingDetail.checkinCode,
                        roomCode: updatedBookingDetail.roomCode,
                        roomName: booking.roomName,
                        roomImage: booking.roomImage,
                        checkInDate: updatedBookingDetail.checkinDate,
                        checkOutDate: updatedBookingDetail.checkoutDate,
                        totalPrice: updatedBookingDetail.totalPayment,
                        status: booking.status,
                        isCheckout: updatedBookingDetail.isCheckout,
                        isCancelled: updatedBookingDetail.cancelledDate != null,
                      );
                    });
                    refreshParent();
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            Text(
                              'Dates updated successfully!',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to update dates: ${e.toString()}',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGold,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('SAVE CHANGES', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _showUpdateGuestsDialog(BuildContext context, int bookingIndex, StateSetter setSheetState, VoidCallback refreshParent) {
    final booking = _allBookings[bookingIndex];
    int adults = 2;
    int children = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Update Guests - ${booking.roomName}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adjust the number of guests for your stay',
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              
              // Adults Counter
              _buildGuestCounter(
                label: 'Adults',
                subtitle: 'Ages 13 or above',
                count: adults,
                onDecrement: () {
                  if (adults > 1) {
                    setDialogState(() => adults--);
                  }
                },
                onIncrement: () {
                  if (adults < 10) {
                    setDialogState(() => adults++);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Children Counter
              _buildGuestCounter(
                label: 'Children',
                subtitle: 'Ages 0-12',
                count: children,
                onDecrement: () {
                  if (children > 0) {
                    setDialogState(() => children--);
                  }
                },
                onIncrement: () {
                  if (children < 10) {
                    setDialogState(() => children++);
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Total Summary
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: brandGold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people, color: brandGold, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Total: ${adults + children} guest${adults + children != 1 ? 's' : ''}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: darkGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL', style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close Update Guests dialog
                
                try {
                  // Show loading indicator
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Updating guests...',
                            style: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ],
                      ),
                      backgroundColor: brandGold,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(seconds: 5),
                    ),
                  );
                  
                  // Call API to update booking
                  await _bookingService.updateBooking(
                    checkinCode: booking.checkinCode,
                    checkInDate: booking.checkInDate,
                    checkOutDate: booking.checkOutDate,
                    numberOfGuests: adults + children,
                    adults: adults,
                    children: children,
                  );
                  
                  // Refresh the specific booking data from API
                  final updatedBookingDetail = await _bookingService.findBooking(booking.checkinCode);
                  
                  // Update the local list and rebuild the sheet
                  if (mounted) {
                    setSheetState(() {
                      _allBookings[bookingIndex] = BookingListItem(
                        checkinCode: updatedBookingDetail.checkinCode,
                        roomCode: updatedBookingDetail.roomCode,
                        roomName: booking.roomName,
                        roomImage: booking.roomImage,
                        checkInDate: updatedBookingDetail.checkinDate,
                        checkOutDate: updatedBookingDetail.checkoutDate,
                        totalPrice: updatedBookingDetail.totalPayment,
                        status: booking.status,
                        isCheckout: updatedBookingDetail.isCheckout,
                        isCancelled: updatedBookingDetail.cancelledDate != null,
                      );
                    });
                    refreshParent();
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Guest count updated: $adults Adult${adults != 1 ? 's' : ''}, $children Child${children != 1 ? 'ren' : ''}',
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Failed to update guests: ${e.toString()}',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandGold,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('SAVE CHANGES', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestCounter({
    required String label,
    required String subtitle,
    required int count,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkGrey,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_circle_outline),
                color: count <= (label == 'Adults' ? 1 : 0) ? Colors.grey.shade300 : brandGold,
                iconSize: 28,
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkGrey,
                  ),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_circle_outline),
                color: count >= 10 ? Colors.grey.shade300 : brandGold,
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, BookingListItem booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Booking Confirmed',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfirmationRow('Booking ID', booking.checkinCode),
              _buildConfirmationRow('Room', booking.roomName),
              _buildConfirmationRow('Check-in', _formatDate(booking.checkInDate)),
              _buildConfirmationRow('Check-out', _formatDate(booking.checkOutDate)),
              _buildConfirmationRow('Duration', '${booking.checkOutDate.difference(booking.checkInDate).inDays} night(s)'),
              _buildConfirmationRow('Total', '\$${booking.totalPrice.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CLOSE', style: GoogleFonts.poppins(color: brandGold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context, BookingListItem booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Contact Support', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone, color: brandGold),
              title: Text('Call Us', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text('+1 (800) 555-LUXE', style: GoogleFonts.poppins(fontSize: 12)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.email, color: brandGold),
              title: Text('Email Support', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text('support@luxestay.com', style: GoogleFonts.poppins(fontSize: 12)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline, color: brandGold),
              title: Text('Live Chat', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              subtitle: Text('Available 24/7', style: GoogleFonts.poppins(fontSize: 12)),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CLOSE', style: GoogleFonts.poppins(color: brandGold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshBookingData(String checkinCode) async {
    try {
      final updatedBooking = await _bookingService.findBooking(checkinCode);
      
      // Update the local booking in the list
      final index = _allBookings.indexWhere((b) => b.checkinCode == checkinCode);
      if (index != -1) {
        setState(() {
          _allBookings[index] = BookingListItem(
            checkinCode: updatedBooking.checkinCode,
            roomCode: updatedBooking.roomCode,
            roomName: _allBookings[index].roomName,
            roomImage: _allBookings[index].roomImage,
            checkInDate: updatedBooking.checkinDate,
            checkOutDate: updatedBooking.checkoutDate,
            totalPrice: updatedBooking.totalPayment,
            status: _allBookings[index].status,
            isCheckout: updatedBooking.isCheckout,
            isCancelled: updatedBooking.cancelledDate != null,
          );
        });
      }
    } catch (e) {
      print('Error refreshing booking: $e');
    }
  }

  Future<void> _cancelBooking(String checkinCode) async {
    try {
      await _bookingService.cancelBooking(checkinCode);
      
      // Refresh the bookings list
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      await _fetchBookings();
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to cancel booking: ${e.toString()}',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _showCancelBookingDialog(BuildContext context, String checkinCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Booking?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel this booking?',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Free cancellation - Full refund will be processed within 3-5 business days',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.green.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('KEEP BOOKING', style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              
              // Show loading indicator
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Cancelling booking...',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ],
                  ),
                  backgroundColor: brandGold,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  duration: const Duration(seconds: 2),
                ),
              );
              
              // Cancel the booking
              await _cancelBooking(checkinCode);
              
              // Show success message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Text(
                          'Booking cancelled successfully',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
            child: Text('CANCEL BOOKING', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
