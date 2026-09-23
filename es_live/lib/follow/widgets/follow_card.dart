import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// 1 การ์ด = 1 ทีมที่ติดตาม
class FollowCard extends StatelessWidget {
  final String teamName;
  final String? logoUrl;
  final VoidCallback onRemove;

  const FollowCard({
    super.key,
    required this.teamName,
    required this.logoUrl,
    required this.onRemove,
  });

  Widget _logo(BuildContext context, String? url) {
    final faded = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.3);

    if (url == null || url.isEmpty) {
      return Icon(Icons.shield_outlined, size: 40, color: faded);
    }
    return Image.network(
      url,
      width: 40,
      height: 40,
      fit: BoxFit.contain,
      errorBuilder:
          (_, _, _) => Icon(Icons.shield_outlined, size: 40, color: faded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          _logo(context, logoUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              teamName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.star, color: AppColors.gold),
          ),
        ],
      ),
    );
  }
}
