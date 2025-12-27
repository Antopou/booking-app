import 'package:flutter/material.dart';
import 'package:booking_agency/theme/app_theme.dart';
import 'package:booking_agency/screens/room_listing_screen.dart';

void main() {
  runApp(const LuxeStayApp());
}

class LuxeStayApp extends StatelessWidget {
  const LuxeStayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuxeStay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoomListingScreen(),
    );
  }
}