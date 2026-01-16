import 'package:flutter/material.dart';
import 'package:booking_app/utils/app_constants.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text("My Bookings", style: AppTextStyles.heading),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.brandGold,
          unselectedLabelColor: AppColors.grey,
          indicatorColor: AppColors.brandGold,
          tabs: const [Tab(text: "Upcoming"), Tab(text: "Past"), Tab(text: "Cancelled")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBookingList("Upcoming"),
          _buildBookingList("Past"),
          _buildBookingList("Cancelled"),
        ],
      ),
    );
  }

  Widget _buildBookingList(String type) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 2,
      itemBuilder: (context, index) => _buildBookingCard(type),
    );
  }

  Widget _buildBookingCard(String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network("https://via.placeholder.com/60", width: 60, height: 60, fit: BoxFit.cover)),
            title: Text("Ocean View Resort", style: AppTextStyles.subHeading),
            subtitle: Text("Jan 15 - Jan 17 • 2 Nights", style: AppTextStyles.caption),
            trailing: Text("\$500", style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.brandGold)),
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Confirmed", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                TextButton(onPressed: () {}, child: const Text("View Details", style: TextStyle(color: AppColors.brandGold))),
              ],
            ),
          )
        ],
      ),
    );
  }
}