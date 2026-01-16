import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color brandGold = Color(0xFFC5A368);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF8E8E8E);
  static const Color error = Color(0xFFD32F2F);
}

class AppTextStyles {
  static TextStyle heading = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.darkGrey,
  );

  static TextStyle subHeading = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGrey,
  );

  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.darkGrey,
  );

  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.grey,
  );
}