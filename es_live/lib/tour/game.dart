import 'package:es_live/core/model/game_data.dart';
import 'package:es_live/tour/widgets/list_game.dart';
import 'package:flutter/material.dart';

class GameTour extends StatefulWidget {
  const GameTour({super.key});

  @override
  State<GameTour> createState() => _GameTourState();
}

class _GameTourState extends State<GameTour> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 490),
          child: GridView.extent(
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            maxCrossAxisExtent: 250,
            children:
                data
                    .map(
                      (g) => ListGameTour(
                        logoGame: g.logo,
                        gameName: g.name,
                        slug: g.slug,
                      ),
                    )
                    .toList(),
          ),
        ),
      ),
    );
  }
}
