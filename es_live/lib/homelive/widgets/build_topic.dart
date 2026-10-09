import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart' hide Badge;

class BuildTopic extends StatelessWidget {
  const BuildTopic({
    super.key,
    required this.isLive,
    required this.time,
    required this.gameName,
    required this.leagueName,
  });

  final String isLive;
  final String time;
  final String gameName;
  final String leagueName;

  @override
  Widget build(BuildContext context) {
    final matchTime = DateFormat(
      'HH.mm - dd/MM/yyyy',
    ).format(DateTime.parse(time).toLocal());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                gameName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            isLive == "live"
                ? const LiveCircle()
                : isLive == "canceled"
                ? badges.Badge(
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: AppColors.red,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  badgeContent: const Text(
                    'canceled',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                : Text(
                  matchTime,
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                ),
          ],
        ),
        Text(
          leagueName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.grey, fontSize: 10),
        ),
      ],
    );
  }
}
