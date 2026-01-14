import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your screens
import 'package:booking_app/screens/splash_screen.dart';

void main() {
  runApp(const LuxeStayApp());
}

class LuxeStayApp extends StatelessWidget {
  const LuxeStayApp({super.key});

  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuxeStay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Material 3 Color Configuration
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandGold,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,

        // Clean, Premium Typography
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),

        // Global Navigation Style
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: brandGold,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 10,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}