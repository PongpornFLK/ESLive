import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// ปุ่ม LinearGradient
class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const PillButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Container(
      decoration: BoxDecoration(
        boxShadow:
            enabled
                ? const [
                  BoxShadow(
                    color: AppColors.gold,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ]
                : null,
        gradient: LinearGradient(
          colors:
              enabled
                  ? const [AppColors.orange, AppColors.gold]
                  : const [AppColors.grey, AppColors.grey],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.secondmain,
              fontFamily: "Genos",
              fontWeight: FontWeight.w700,
              fontSize: 26,
            ),
          ),
        ),
      ),
    );
  }
}
