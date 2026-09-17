import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// รวมค่าสีของทั้งแอปไว้ที่เดียว แยกเป็นโหมดสว่าง/มืด
///
/// หน้าจอควรอ่านสีจาก Theme.of(context) แทนการเขียน AppColors ตรง ๆ
/// เพื่อให้สลับโหมดแล้วเปลี่ยนตามได้
class AppTheme {
  AppTheme._();

  // ===== โหมดสว่าง =====
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

  // ===== โหมดมืด (หน้าตาเดิมของแอป) =====
  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.orange,
      surface: AppColors.main,
      onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.secondmain,
      cardColor: AppColors.main,
      dividerColor: Colors.white24,
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: Typography.whiteMountainView.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }
}
