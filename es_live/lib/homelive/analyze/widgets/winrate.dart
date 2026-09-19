import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Winrate extends StatelessWidget {
  const Winrate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Text("Win Rate%"),
          // Image.network(""),
          LinearPercentIndicator(barRadius: Radius.circular(50)),
          // Image.network(""),
        ],
      ),
    );
  }
}
