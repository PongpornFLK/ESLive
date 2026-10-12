import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/tour.dart';
import 'package:flutter/material.dart';

class ListGameTour extends StatelessWidget {
  final String logoGame;
  final String gameName;
  final String slug;

  const ListGameTour({
    super.key,
    required this.gameName,
    required this.logoGame,
    required this.slug,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withValues(alpha: 0.5),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Tour(slug: slug)),
                ),
            child: Image.asset(logoGame, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 10),
        Flexible(
          child: Text(
            gameName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
