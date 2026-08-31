import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/homelive/widgets/list_game.dart';
import 'package:es_live/homelive/widgets/match_card.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';

import '../core/model/game_data.dart';

class Live extends StatefulWidget {
  const Live({super.key});

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  bool isHaveLive = true;
  bool isHaveComingSoon = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  "Game",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children:
                  data
                      .map((g) => ListGame(logo: g.logo, gameName: g.gameName))
                      .toList(),
            ),
            Divider(),
            Row(
              children: [
                Text(
                  "Match ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Live! ",
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                LiveCircle(),
              ],
            ),
            isHaveLive
                ? MatchCard(
                  gameName: "Game",
                  tourName: "TourName",
                  teamAName: "TeamAName",
                  teamBName: "TeamBName",
                  isLive: true,
                  time: "23.00",
                  logoTeamA: "LogoA",
                  logoTeamB: "LogoB",
                )
                : Center(
                  child: Text(
                    "Not Found",
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
            Divider(),
            Row(
              children: [
                Text(
                  "Coming Soon",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            isHaveComingSoon
                ? MatchCard(
                  gameName: "Game",
                  tourName: "TourName",
                  teamAName: "TeamAName",
                  teamBName: "TeamBName",
                  isLive: false,
                  time: "23.00",
                  logoTeamA: "LogoA",
                  logoTeamB: "LogoB",
                )
                : Center(
                  child: Text(
                    "Not Found",
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
          ],
        ),
      ),
    );
    // CustomListView(
    //   itemCount: mockMatches.length,
    //   itemBuilder: (context,index) =>

    // );
  }
}
