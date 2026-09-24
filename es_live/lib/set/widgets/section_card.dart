import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// กล่องหัวข้อการตั้งค่า 1 กลุ่ม เช่น Theme / Language / Account
/// รู้แค่ว่าต้องวาดหัวข้อกับกรอบ ไม่รู้ว่าข้างในเป็นตัวเลือกอะไร
class SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
