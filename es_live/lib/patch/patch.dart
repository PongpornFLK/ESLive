import 'package:es_live/patch/widget/patch_card.dart';
import 'package:flutter/material.dart';

class Patch extends StatefulWidget {
  const Patch({super.key});

  @override
  State<Patch> createState() => _PatchState();
}

class _PatchState extends State<Patch> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          PatchCard(
            gameName: "gameName",
            logoGame: "logoGame",
            time: "time",
            summary: "summary",
            version: "version",
          ),
        ],
      ),
    );
  }
}
