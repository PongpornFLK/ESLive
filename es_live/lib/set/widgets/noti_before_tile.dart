import 'package:es_live/_service/user/profile_pro.dart';
import 'package:es_live/set/widgets/option_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ตัวเลือกเวลาแจ้งเตือนล่วงหน้า 1 อัน ต่อ OptionRow เข้ากับ profileProvider
class NotiBeforeTile extends ConsumerWidget {
  final int minutes;
  final int current;
  final String label;
  final String detail;

  const NotiBeforeTile({
    super.key,
    required this.minutes,
    required this.current,
    required this.label,
    required this.detail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OptionRow(
      icon: Icons.schedule_rounded,
      label: label,
      detail: detail,
      selected: minutes == current,
      onTap:
          () => ref.read(profileProvider.notifier).save({
            'notify_before_minutes': minutes,
          }),
    );
  }
}
