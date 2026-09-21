import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

class AnalysisBox extends StatelessWidget {
  final String? reason;

  const AnalysisBox({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final hasReason = reason != null && reason!.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.gold, size: 18),
              const SizedBox(width: 6),
              Text(
                "AI Analysis",
                style: TextStyle(
                  color: onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            hasReason ? reason! : "ยังไม่มีผลวิเคราะห์สำหรับแมตช์นี้",
            style: TextStyle(
              color: hasReason ? onSurface : AppColors.grey,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
