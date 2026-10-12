import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// รู้จัก provider รับมาว่าถูกเลือกไหม
class ListGame extends StatelessWidget {
  const ListGame({
    super.key,
    required this.logo,
    required this.gameName,
    required this.selected,
    required this.onTap,
  });

  final String logo;
  final String gameName;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: 75,
          height: 75,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.cardColor,
            border:
                selected ? Border.all(color: AppColors.orange, width: 3) : null,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(logo, fit: BoxFit.cover),
              Material(color: Colors.transparent, child: InkWell(onTap: onTap)),
            ],
          ),
        ),
        Text(
          gameName,
          style: TextStyle(
            color: selected ? AppColors.orange : theme.colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
