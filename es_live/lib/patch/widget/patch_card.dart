import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/patch/detail.dart';
import 'package:flutter/material.dart';

class PatchCard extends StatelessWidget {
  final String gameName;
  final String? logoGame;
  final String time;
  final String summary;
  final String version;

  const PatchCard({
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
      height: 200,
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
          Row(
            children: [
              Text(summary, overflow: TextOverflow.ellipsis, maxLines: 3),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PatchDetail()),
                    ),
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: TextStyle(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
