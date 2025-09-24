import 'package:flutter/material.dart';

/// Indian Railways Professional Light Theme
class IRColors {
  // Core IR colors
  static const Color navy = Color(0xFF1A3E5C); // Primary blue/navy
  static const Color maroon = Color(0xFF800000); // IR Maroon
  static const Color blue = Color(0xFF3A9BDC); // Secondary blue (buttons/highlights)
  static const Color yellow = Color(0xFFFFD700); // Signal Yellow
  static const Color green = Color(0xFF388E3C); // Success Green
  static const Color orange = Color(0xFFFFA000); // Warning Orange
  static const Color error = Color(0xFFD32F2F); // Error Red
  static const Color info = Color(0xFF1976D2); // Info Blue
  static const Color divider = Color(0xFFB0BEC5); // Light divider
  static const Color background = Color(0xFFF7F9FC); // Very light BG
  static const Color surface = Colors.white; // Card background
  static const Color surfaceLight = Color(0xFFE8F0FA); // Soft blue panel
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4C4C4C);
  static const Color textInverse = Colors.white;
  static const Color blockOccupied = Color(0xFFD32F2F); // Red
  static const Color blockFree = Color(0xFF388E3C); // Green
  static const Color signalActive = Color(0xFFFFD700); // Yellow
  static const Color signalInactive = Color(0xFFB0BEC5); // Grey
}

class IRSpacing {
  static const double xSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double xLarge = 32.0;
  static const double sectionGap = 40.0;
}

class IRTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: IRColors.background,
        colorScheme: ColorScheme.light(
          primary: IRColors.navy,
          secondary: IRColors.maroon,
          background: IRColors.background,
          surface: IRColors.surface,
          error: IRColors.error,
          onPrimary: IRColors.yellow,
          onSecondary: IRColors.yellow,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: IRColors.navy,
          elevation: 3,
          iconTheme: IconThemeData(color: IRColors.yellow),
          titleTextStyle: TextStyle(
            color: IRColors.yellow,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          color: IRColors.surface,
          shadowColor: IRColors.navy.withOpacity(0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: IRColors.divider, width: 1),
          ),
          margin: EdgeInsets.all(IRSpacing.medium),
        ),
        dividerColor: IRColors.divider,
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: IRColors.navy),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: IRColors.navy),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: IRColors.maroon),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: IRColors.navy),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: IRColors.maroon),
          bodyLarge: TextStyle(fontSize: 16, color: IRColors.textPrimary),
          bodyMedium: TextStyle(fontSize: 14, color: IRColors.textSecondary),
          bodySmall: TextStyle(fontSize: 12, color: IRColors.textSecondary),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: IRColors.navy),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: IRColors.maroon,
          foregroundColor: IRColors.yellow,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: IRColors.blue,
            foregroundColor: IRColors.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: IRSpacing.large, vertical: IRSpacing.medium),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: IRColors.surface,
          contentPadding: EdgeInsets.symmetric(vertical: IRSpacing.medium, horizontal: IRSpacing.medium),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: IRColors.divider, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: IRColors.blue, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: IRColors.divider, width: 1),
          ),
          labelStyle: TextStyle(color: IRColors.textSecondary),
          hintStyle: TextStyle(color: IRColors.divider),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: IRColors.navy,
          unselectedLabelColor: IRColors.divider,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: IRColors.blue,
              width: 3.0,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: IRColors.surface,
          selectedColor: IRColors.blue,
          labelStyle: TextStyle(color: IRColors.navy),
          secondaryLabelStyle: TextStyle(color: IRColors.yellow),
          padding: EdgeInsets.symmetric(horizontal: IRSpacing.small, vertical: IRSpacing.xSmall),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: IRColors.surfaceLight,
          selectedTileColor: IRColors.blue.withOpacity(0.08),
          iconColor: IRColors.navy,
          textColor: IRColors.textPrimary,
        ),
      );
}
