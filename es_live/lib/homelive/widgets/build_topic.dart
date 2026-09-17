import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildTopic extends StatelessWidget {
  const BuildTopic({
    super.key,
    required this.isLive,
    required this.time,
    required this.gameName,
    required this.tourName,
  });

  final bool isLive;
  final String time;
  final String gameName;
  final String tourName;

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
            isLive
                ? const LiveCircle()
                : Text(
                  matchTime,
                  style: TextStyle(color: AppColors.grey, fontSize: 12),
                ),
          ],
        ),
        Text(
          tourName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: AppColors.grey, fontSize: 10),
        ),
      ],
    );
  }
}
