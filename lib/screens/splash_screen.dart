import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:booking_app/screens/login_screen.dart';
import 'package:booking_app/screens/home_screen.dart';
import 'package:booking_app/services/auth_service.dart';
import 'package:booking_app/utils/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final tokenValidation = await _authService.checkToken();
    if (!mounted) return;

    if (tokenValidation != null && tokenValidation.data.valid) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hotel_class, size: 100, color: AppColors.brandGold),
            const SizedBox(height: 24),
            Text("LUXESTAY", style: AppTextStyles.heading.copyWith(letterSpacing: 4)),
            const SizedBox(height: 8),
            Text("Premium Hotel Bookings", style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}