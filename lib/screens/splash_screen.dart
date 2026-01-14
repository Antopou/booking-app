import 'dart:async';
import 'dart:math' as math;

import 'package:booking_app/screens/login_screen.dart';
import 'package:booking_app/screens/home_screen.dart';
import 'package:booking_app/services/auth_service.dart';
import 'package:booking_app/utils/route_transitions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);
    final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
      _checkTokenAndNavigate();
  }

    Future<void> _checkTokenAndNavigate() async {
      // Wait a bit for splash effect
      await Future.delayed(const Duration(milliseconds: 1600));
    
    if (!mounted) return;
    
      // Check if token is valid
      final tokenValidation = await _authService.checkToken();
    
      if (!mounted) return;
    
      if (tokenValidation != null && tokenValidation.data.valid) {
        // Token is valid, go to home screen
        Navigator.of(context).pushReplacement(
          RouteTransitions.fadeIn(const HomeScreen()),
        );
      } else {
        // Token is invalid or doesn't exist, go to login
        Navigator.of(context).pushReplacement(
          RouteTransitions.fadeIn(const LoginScreen()),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48,
              width: 48,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const GoldSpinner(size: 48, color: brandGold),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: brandGold, width: 1.2),
                    ),
                    child: const Icon(
                      Icons.star_rate_rounded,
                      color: brandGold,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LuxeStay',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: darkGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GoldSpinner extends StatefulWidget {
  final double size;
  final Color color;
  const GoldSpinner({super.key, this.size = 48, required this.color});

  @override
  State<GoldSpinner> createState() => _GoldSpinnerState();
}

class _GoldSpinnerState extends State<GoldSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _SpinnerPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _SpinnerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 1.4;
    final rect = Offset.zero & size;
    final radiusInset = strokeWidth;
    final arcRect = Rect.fromLTWH(
      rect.left + radiusInset,
      rect.top + radiusInset,
      rect.width - 2 * radiusInset,
      rect.height - 2 * radiusInset,
    );

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(0.18);

    // base faint ring
    canvas.drawArc(arcRect, 0, 2 * math.pi, false, base);

    final arcPaint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(0.9);

    final arcPaint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = color.withOpacity(0.6);

    final angle = 2 * math.pi * progress;

    // long arc sweeps around
    const sweep1 = 1.6; // ~90 degrees
    canvas.drawArc(arcRect, angle, sweep1, false, arcPaint1);

    // short arc trail
    const sweep2 = 0.7; // ~40 degrees
    canvas.drawArc(arcRect, angle - 1.2, sweep2, false, arcPaint2);
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
