import 'package:es_live/_service/user/profile_pro.dart';
import 'package:es_live/set/widgets/option_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ตัวเลือกว่าจะเตือนแมตช์ไหนบ้าง ต่อ OptionRow เข้ากับ profileProvider
class NotiScopeTile extends ConsumerWidget {
  /// true = ทุกแมตช์  false = เฉพาะทีมที่ติดตาม
  final bool allMatches;
  final bool current;
  final IconData icon;
  final String label;
  final String detail;

  const NotiScopeTile({
    super.key,
    required this.allMatches,
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
      selected: allMatches == current,
      onTap:
          () => ref.read(profileProvider.notifier).save({
            'notify_all_matches': allMatches,
          }),
    );
  }
}
