import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// คีย์ที่ใช้เก็บลงเครื่อง
const _prefKey = 'app_lang';

/// ภาษาที่แอปรองรับ ต้องตรงกับไฟล์ .arb ใน lib/l10n
const supportedLangs = [Locale('en'), Locale('th')];

/// เก็บภาษาที่ผู้ใช้เลือก แล้วส่งให้ MaterialApp.locale
///
/// ถึงจะใช้ i18n มาตรฐานแล้วก็ยังต้องมีตัวนี้ เพราะ AppLocalizations
/// อ่านภาษาจาก MaterialApp เท่านั้น ไม่ได้เก็บว่าผู้ใช้กดเลือกอะไรไว้
class LocaleNotifier extends Notifier<Locale> {
  /// ค่าเริ่มต้นเป็นอังกฤษ ไม่ตามเครื่อง เพราะกำหนดไว้ว่า default = English
  @override
  Locale build() {
    _load();
    return const Locale('en');
  }

  /// อ่านค่าที่เคยเลือกไว้จากเครื่อง (ทำทีหลังเพราะต้องรอ)
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    if (saved == null) return;

    // เทียบกับรายการที่รองรับก่อน กันค่าเพี้ยนในเครื่องทำให้แอปพัง
    final match = supportedLangs.where((l) => l.languageCode == saved);
    if (match.isNotEmpty) state = match.first;
  }

  /// เปลี่ยนภาษา แล้วบันทึกลงเครื่องทันที
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, locale.languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
