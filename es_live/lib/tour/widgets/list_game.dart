import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/tour.dart';
import 'package:flutter/material.dart';

class ListGameTour extends StatelessWidget {
  final String logoGame;
  final String gameName;

  const ListGameTour({
    super.key,
    required this.gameName,
    required this.logoGame,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          // height: 100,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tour()),
                ),
            child: Image.asset(logoGame, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 10),
        Text(
          gameName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
