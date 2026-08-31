import 'package:flutter/material.dart';

class BuildTeam extends StatelessWidget {
  const BuildTeam({
    super.key,
    required this.teamAName,
    required this.teamBName,
    required this.logoTeamA,
    required this.logoTeamB,
  });

  final String teamAName;
  final String teamBName;
  final String logoTeamA;
  final String logoTeamB;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(logoTeamA, style: TextStyle(color: Colors.white)),
        Text(teamAName, style: TextStyle(color: Colors.white)),
        Text("vs", style: TextStyle(color: Colors.white)),
        Text(teamBName, style: TextStyle(color: Colors.white)),
        Text(logoTeamB, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
