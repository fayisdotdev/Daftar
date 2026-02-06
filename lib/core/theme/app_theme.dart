import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // UAE Theme Colors
  static const Color primary = Color(0xFF00732F); // UAE Green
  static const Color secondary = Color(0xFF1A1A1A); // Black (UAE)
  static const Color accent = Color(0xFFFF0000); // UAE Red
  static const Color highlight = Color(0xFF0096D6); // Modern Blue Touch

  // Neutrals
  static const Color white = Colors.white;
  static const Color lightGrey = Color(0xFFF4F4F4);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF4F4F4F);

  // Status
  static const Color danger = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
}

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightGrey,
    fontFamily: GoogleFonts.poppins().fontFamily,

    /// ---------------------------
    /// TEXT THEMES
    /// ---------------------------
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.secondary,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.secondary,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: AppColors.darkGrey,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        color: AppColors.darkGrey,
      ),
      labelSmall: GoogleFonts.poppins(
        fontSize: 12,
        color: AppColors.grey,
      ),
    ),

    /// ---------------------------
    /// BUTTON THEMING
    /// ---------------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primary, width: 1.4),
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        textStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    /// ---------------------------
    /// INPUT FIELDS
    /// ---------------------------
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      hintStyle: GoogleFonts.poppins(
        fontSize: 14,
        color: AppColors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),

    /// ---------------------------
    /// ICON BUTTONS
    /// ---------------------------
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    /// ---------------------------
    /// CARD + CONTAINER STYLES
    /// ---------------------------
 cardTheme: CardThemeData(
  color: AppColors.white,
  elevation: 2,
  margin: const EdgeInsets.all(10),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
),


    /// TABLES (For Inventory, Billing, Reports)
    dataTableTheme: const DataTableThemeData(
      headingRowColor: WidgetStatePropertyAll(AppColors.primary),
      headingTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      dataTextStyle: TextStyle(
        fontSize: 14,
      ),
    ),
  );
}
