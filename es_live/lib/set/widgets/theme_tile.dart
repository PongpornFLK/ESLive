import 'package:es_live/core/theme/theme_pro.dart';
import 'package:es_live/set/widgets/option_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ตัวเลือกโหมดสี 1 อัน ต่อ OptionRow เข้ากับ themeModeProvider
class ThemeTile extends ConsumerWidget {
  final ThemeMode mode;
  final ThemeMode current;
  final IconData icon;
  final String label;
  final String detail;

  const ThemeTile({
    super.key,
    required this.mode,
    required this.current,
    required this.icon,
    required this.label,
    required this.detail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptionRow(
      icon: icon,
      label: label,
      detail: detail,
      selected: mode == current,
      onTap: () => ref.read(themeModeProvider.notifier).setMode(mode),
    );
  }
}
