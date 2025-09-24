import 'package:flutter/material.dart';

/// ===============================
///   INDIAN RAILWAYS APP THEME
///   ===============================
/// Defines a clean, professional, and elegant light theme
/// inspired by the Indian Railways aesthetic.
/// The dark theme is designed to be a "Control Room" style.
class AppColors {
  // Primary & Accent Colors
  static const Color primaryBlue = Color(0xFF2E3B55); // A deep, professional navy
  static const Color accentRed = Color(0xFFE20000); // A bold red accent, reminiscent of the IR logo

  // Background & Surface Colors
  static const Color lightBackground = Color(0xFFF7F9FC); // A very subtle off-white background
  static const Color lightSurface = Colors.white; // Clean white surface for cards and sheets
  static const Color darkBackground = Color(0xFF121212); // A deep, non-pure black for a dramatic effect
  static const Color darkSurface = Color(0xFF1E1E1E); // A slightly lighter surface for contrast

  // Text Colors
  static const Color lightTextPrimary = Color(0xFF1A1A1A); // Dark text for readability on a white background
  static const Color lightTextSecondary = Color(0xFF4C4C4C); // Dark gray for body text
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.white70;

  // Status Colors
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color error = Color(0xFFB00020);
}

/// ===============================
///   TEXT STYLES
/// ===============================
class AppTextStyles {
  // Text styles for light theme
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryBlue,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryBlue,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryBlue,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryBlue,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.lightTextPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextSecondary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryBlue,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryBlue,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryBlue,
    ),
  );

  // Text styles for dark theme
  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextPrimary,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextPrimary,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondary,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondary,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.accentRed,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.accentRed,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.accentRed,
    ),
  );
}

/// ===============================
///   SPACING CONSTANTS
/// ===============================
class AppSpacing {
  static const double xSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xLarge = 32.0;
}

/// ===============================
///   MAIN THEMES
/// ===============================
class AppTheme {
  /// LIGHT THEME (Dashboard / IRCTC style)
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.accentRed,
      onSecondary: Colors.white,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      background: AppColors.lightBackground,
      error: AppColors.error,
      onError: Colors.white,
    ),
    textTheme: AppTextStyles.lightTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      elevation: 2,
      iconTheme: IconThemeData(color: AppColors.primaryBlue),
      titleTextStyle: TextStyle(
        color: AppColors.primaryBlue,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 1.0,
      color: AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large, vertical: AppSpacing.medium),
        elevation: 2,
        textStyle: AppTextStyles.lightTextTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        side: const BorderSide(color: AppColors.primaryBlue, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large, vertical: AppSpacing.medium),
        textStyle: AppTextStyles.lightTextTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF0F2F5), // A very light gray fill
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.medium, horizontal: AppSpacing.medium),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      labelStyle: const TextStyle(color: AppColors.lightTextSecondary),
      hintStyle: const TextStyle(color: Color(0xFFB0B0B0)),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.primaryBlue,
      unselectedLabelColor: Colors.grey,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.primaryBlue,
          width: 3.0,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentRed,
      foregroundColor: Colors.white,
    ),
  );

  /// DARK THEME (Control Room style)
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentRed,
      onPrimary: Colors.white,
      secondary: AppColors.primaryBlue,
      onSecondary: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      background: AppColors.darkBackground,
      error: AppColors.error,
      onError: Colors.white,
    ),
    textTheme: AppTextStyles.darkTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      color: AppColors.darkSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large, vertical: AppSpacing.medium),
        elevation: 2,
        textStyle: AppTextStyles.darkTextTheme.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.accentRed,
        side: const BorderSide(color: AppColors.accentRed, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large, vertical: AppSpacing.medium),
        textStyle: AppTextStyles.darkTextTheme.labelLarge,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.medium, horizontal: AppSpacing.medium),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.accentRed, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
      hintStyle: const TextStyle(color: Colors.white38),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: AppColors.accentRed,
      unselectedLabelColor: Colors.grey,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.accentRed,
          width: 3.0,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
    ),
  );
}
