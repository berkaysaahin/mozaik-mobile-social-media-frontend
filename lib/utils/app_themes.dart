import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozaik/app_colors.dart';

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      focusColor: AppColors.platinum,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      textTheme: _buildSpectralTextTheme(Colors.black, Colors.grey[700]!),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      primaryColor: AppColors.primaryDark,
      focusColor: AppColors.platinumDark,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      textTheme: _buildSpectralTextTheme(Colors.white, Colors.grey[400]!),
    );
  }

  static TextTheme _buildSpectralTextTheme(
      Color primaryColor, Color secondaryColor) {
    return TextTheme(
      headlineSmall: GoogleFonts.outfit(
        fontSize: 23,
        fontWeight: FontWeight.w800,
        color: primaryColor,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 21,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 19,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.5,
        letterSpacing: 0.5,
        color: primaryColor,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: primaryColor,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
}
