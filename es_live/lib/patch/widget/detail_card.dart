import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String gameName;
  final String? logoGame;
  final String time;
  final String summary;
  final String version;

  const DetailCard({
    super.key,
    required this.gameName,
    required this.logoGame,
    required this.time,
    required this.summary,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("logoGame", style: TextStyle(color: AppColors.main)),
                  Text(gameName, style: TextStyle(color: AppColors.main)),
                ],
              ),
              Text(time, style: TextStyle(color: AppColors.main)),
            ],
          ),
          Row(
            children: [
              Text(
                "Patch $version",
                style: TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(children: [Text(summary)]),
        ],
      ),
    );
  }
}
