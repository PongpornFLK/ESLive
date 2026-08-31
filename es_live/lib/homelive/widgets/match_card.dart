import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/homelive/widgets/build_team.dart';
import 'package:es_live/homelive/widgets/build_topic.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.gameName,
    required this.tourName,
    required this.teamAName,
    required this.teamBName,
    required this.logoTeamA,
    required this.logoTeamB,
    required this.isLive,
    required this.time,
  });

  final String gameName;
  final String tourName;
  final String teamAName;
  final String teamBName;
  final String logoTeamA;
  final String logoTeamB;
  final bool isLive;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        children: [
          BuildTopic(
            tourName: tourName,
            gameName: gameName,
            isLive: isLive,
            time: time,
          ),
          BuildTeam(
            teamAName: teamAName,
            teamBName: teamBName,
            logoTeamA: logoTeamA,
            logoTeamB: logoTeamB,
          ),
        ],
      ),
    );
  }
}
