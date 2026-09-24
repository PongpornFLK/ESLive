import 'package:es_live/core/lang/locale_pro.dart';
import 'package:es_live/set/widgets/option_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ตัวเลือกภาษา 1 อัน ต่อ OptionRow เข้ากับ localeProvider
class LangTile extends ConsumerWidget {
  final Locale locale;
  final Locale current;
  final String label;
  final String detail;

  const LangTile({
    super.key,
    required this.locale,
    required this.current,
    required this.label,
    required this.detail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptionRow(
      icon: Icons.translate_rounded,
      label: label,
      detail: detail,
      // เทียบแค่ languageCode ไม่เทียบทั้ง Locale เพราะอาจมี countryCode ติดมา
      selected: locale.languageCode == current.languageCode,
      onTap: () => ref.read(localeProvider.notifier).setLocale(locale),
    );
  }
}
