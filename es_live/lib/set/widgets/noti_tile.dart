import 'package:es_live/_service/noti/noti_switch_pro.dart';
import 'package:es_live/set/widgets/option_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ตัวเลือกเปิดหรือปิดแจ้งเตือน 1 อัน ต่อ OptionRow เข้ากับ notiSwitchProvider
class NotiTile extends ConsumerWidget {
  final bool value;
  final bool current;
  final IconData icon;
  final String label;
  final String detail;

  const NotiTile({
    super.key,
    required this.value,
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
      selected: value == current,
      onTap: () => ref.read(notiSwitchProvider.notifier).setEnabled(value),
    );
  }
}
