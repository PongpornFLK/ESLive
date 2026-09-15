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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GridView.count(
        primary: false,
        crossAxisCount: 2,
        children:
            data
                .map((g) => ListGameTour(logoGame: g.logo, gameName: g.name))
                .toList(),
      ),
    );
  }
}
