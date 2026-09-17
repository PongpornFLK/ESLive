import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// คีย์ที่ใช้เก็บลงเครื่อง
const _prefKey = 'theme_mode';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  /// ค่าเริ่มต้นก่อนอ่านของที่เคยบันทึกไว้
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  /// อ่านค่าที่เคยเลือกไว้จากเครื่อง (ทำทีหลังเพราะต้องรอ)
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved == null) return;

    state = ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  /// เปลี่ยนโหมด แล้วบันทึกลงเครื่องทันที
  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
