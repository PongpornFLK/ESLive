import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// แถวตัวเลือก 1 อัน ไอคอน + ชื่อ + คำอธิบาย + วงกลมติ๊กถูก
///
/// ไม่รู้จัก provider ไหนเลย รับแค่ว่า "ถูกเลือกอยู่ไหม" กับ "กดแล้วทำอะไร"
/// จึงใช้ได้ทั้งเลือกธีมและเลือกภาษา และวันหลังจะเพิ่มกลุ่มอื่นก็ใช้ตัวนี้ได้อีก
class OptionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onTap;

  const OptionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.detail,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.orange : AppColors.grey,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: const TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.orange,
                size: 20,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: AppColors.grey.withValues(alpha: 0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
