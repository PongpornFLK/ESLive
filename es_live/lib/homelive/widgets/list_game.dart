import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

class ListGame extends StatelessWidget {
  const ListGame({super.key, required this.game});

  final String game;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Center(child: Text(game)),
    );
  }
}
