import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// THEME APP ( DARK & LIGHT )
/// อ่านสีจาก Theme.of(context)
class AppTheme {
  AppTheme._();

  // ===== Dark with light
  static const Color _darkSurface = Color(0xFF232849);

  // ===== Light Mode
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.orange,
      surface: Colors.white,
      onSurface: AppColors.main,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF1F2F6),
      cardColor: Colors.white,
      dividerColor: Colors.black12,
      iconTheme: IconThemeData(color: AppColors.main),
      textTheme: Typography.blackMountainView.apply(
        bodyColor: AppColors.main,
        displayColor: AppColors.main,
      ),
    );
  }

  // ===== Dark Mode
  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.orange,
      surface: _darkSurface,
      onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.secondmain,
      cardColor: _darkSurface,
      dividerColor: Colors.white24,
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: Typography.whiteMountainView.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}
