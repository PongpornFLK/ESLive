import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';

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
    return !isLive
        ? Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(gameName, style: TextStyle(color: Colors.white)),
                Text(time, style: TextStyle(color: AppColors.grey)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(tourName, style: TextStyle(color: AppColors.grey)),
              ],
            ),
          ],
        )
        : Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(gameName, style: TextStyle(color: Colors.white)),
                LiveCircle(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text(tourName, style: TextStyle(color: Colors.white))],
            ),
          ],
        );
  }
}
