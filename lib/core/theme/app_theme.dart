import 'package:flutter/material.dart';

/// Defines the official Empiricus color palette for the light theme.
///
/// This class centralizes all primary colors used throughout the application,
/// ensuring consistency and easy management of the app's visual identity.
class AppColors {
  static const Color redPower = Color(0xFFE02020);
  static const Color deepBlack = Color(0xFF0D0D0D);
  static const Color graphite = Color(0xFF4A4A4A);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF9F9F9);
  static const Color border = Color(0xFFEEEEEE);
  static const Color error = Color(0xFFE02020);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
}

/// Defines the application's themes.
///
/// This class provides static [ThemeData] instances, starting with a light theme,
/// configured according to the Empiricus branding guidelines.
abstract final class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.redPower,
      onPrimary: Colors.white,
      secondary: AppColors.deepBlack,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.deepBlack,
      error: AppColors.error,
      onError: Colors.white,
      tertiary: AppColors.graphite,
      onTertiary: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.deepBlack,
      centerTitle: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: AppColors.deepBlack,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.redPower,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      hintStyle: const TextStyle(color: AppColors.graphite),
      labelStyle: const TextStyle(color: AppColors.graphite),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: AppColors.redPower, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: AppColors.error, width: 2),
      ),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: AppColors.deepBlack,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      headlineMedium: TextStyle(
        color: AppColors.deepBlack,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      bodyLarge: TextStyle(color: AppColors.graphite, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.graphite, fontSize: 14),
      labelLarge: TextStyle(
        color: AppColors.deepBlack,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),

    dividerColor: AppColors.border,
    cardColor: AppColors.surface,
  );
}
