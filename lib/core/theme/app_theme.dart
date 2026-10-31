import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();
  static ThemeData build(String themeName) => ThemeData(
    useMaterial3: true,
    fontFamily: 'Arial',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.gradient(themeName).colors[1],
      primary: AppColors.gradient(themeName).colors[1],
      secondary: AppColors.schoolGreen,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withValues(alpha: .86),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: AppColors.inputFocusBorder,
          width: 1.5,
        ),
      ),
    ),
  );
}
