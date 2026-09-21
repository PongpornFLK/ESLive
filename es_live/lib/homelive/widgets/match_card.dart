import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/homelive/analyze/analyze.dart';
import 'package:es_live/homelive/widgets/build_team.dart';
import 'package:es_live/homelive/widgets/build_topic.dart';
import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String gameName;
  final String leagueName;
  final String teamAName;
  final String teamBName;
  final String? logoTeamA;
  final String? logoTeamB;
  final int scoreA;
  final int scoreB;
  final bool isLive;
  final String time;
  final MatchData match; // จังหวะส่งต่อ

  const MatchCard({
    super.key,
    required this.gameName,
    required this.leagueName,
    required this.teamAName,
    required this.teamBName,
    required this.logoTeamA,
    required this.logoTeamB,
    required this.scoreA,
    required this.scoreB,
    required this.isLive,
    required this.time,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MatchAnalyze(match: match),
              ),
            ),
        child: Column(
          children: [
            BuildTopic(
              leagueName: leagueName,
              gameName: gameName,
              isLive: isLive,
              time: time,
            ),
            const SizedBox(height: 10),
            BuildTeam(
              teamAName: teamAName,
              teamBName: teamBName,
              logoTeamA: logoTeamA,
              logoTeamB: logoTeamB,
              scoreA: scoreA,
              scoreB: scoreB,
            ),
          ],
        ),
      ),
    );
  }
}
