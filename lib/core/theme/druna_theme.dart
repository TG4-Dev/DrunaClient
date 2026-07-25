import 'package:flutter/material.dart';

abstract final class DrunaColors {
  static const background = Color(0xFF080808);
  static const surface = Color(0xFF111112);
  static const surfaceRaised = Color(0xFF1A1A1C);
  static const line = Color(0xFF2B2B2F);
  static const text = Color(0xFFF5F5F7);
  static const muted = Color(0xFF9A9AA1);
  static const accent = Color(0xFF8F68FF);
  static const accentSoft = Color(0xFFCBBaff);
  static const blue = Color(0xFF3975FF);
  static const coral = Color(0xFFFF5967);
  static const green = Color(0xFF16C978);
  static const gold = Color(0xFFF0BD00);
  static const pink = Color(0xFFED00C5);
}

ThemeData buildDrunaTheme() {
  final scheme = const ColorScheme.dark(
    primary: DrunaColors.text,
    onPrimary: DrunaColors.background,
    secondary: DrunaColors.accent,
    onSecondary: DrunaColors.text,
    surface: DrunaColors.surface,
    onSurface: DrunaColors.text,
    error: DrunaColors.coral,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DrunaColors.background,
    colorScheme: scheme,
    splashFactory: InkSparkle.splashFactory,
    fontFamily: 'SF Pro Display',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 39,
        height: 1.04,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.7,
      ),
      headlineLarge: TextStyle(
        fontSize: 30,
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.9,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.4),
      bodyMedium: TextStyle(fontSize: 14, height: 1.4),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.35,
        color: DrunaColors.muted,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: DrunaColors.muted,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DrunaColors.surfaceRaised,
      labelStyle: const TextStyle(color: DrunaColors.muted, fontSize: 12),
      hintStyle: const TextStyle(color: Color(0xFF73737A)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF686870)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: DrunaColors.coral),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: DrunaColors.text,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: DrunaColors.surfaceRaised,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: DrunaColors.background,
      surfaceTintColor: Colors.transparent,
    ),
  );
}

const personPalette = <Color>[
  DrunaColors.coral,
  DrunaColors.gold,
  DrunaColors.blue,
  DrunaColors.pink,
  DrunaColors.green,
  DrunaColors.accent,
];
