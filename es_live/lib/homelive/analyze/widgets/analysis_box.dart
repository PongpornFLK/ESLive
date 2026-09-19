import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

class AnalysisBox extends StatelessWidget {
  const AnalysisBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.orange),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.gold),
              Text("AI Analysis Match"),
              Text("summary", maxLines: 10),
            ],
          ),
        ],
      ),
    );
  }
}
