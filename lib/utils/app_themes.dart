import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mozaik/app_colors.dart';

class AppThemes {
  static TextTheme get _baseTextTheme {
    return TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      primaryColor: AppColors.primary,
      focusColor: AppColors.platinum,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      textTheme: GoogleFonts.montserratTextTheme(_baseTextTheme).copyWith(
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.5,
          color: Colors.black87,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        labelMedium: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.platinum,
        selectionColor: AppColors.platinum,
        selectionHandleColor: AppColors.platinum,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primaryColor: AppColors.primaryDark,
      focusColor: AppColors.platinumDark,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      textTheme: GoogleFonts.montserratTextTheme(_baseTextTheme).copyWith(
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
          letterSpacing: 0.5,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        labelMedium: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[400],
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.platinumDark,
        selectionColor: AppColors.platinumDark,
        selectionHandleColor: AppColors.platinumDark,
      ),
    );
  }
}
