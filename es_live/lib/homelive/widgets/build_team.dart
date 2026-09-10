import 'package:flutter/material.dart';

class BuildTeam extends StatelessWidget {
  const BuildTeam({
    super.key,
    required this.teamAName,
    required this.teamBName,
    required this.logoTeamA,
    required this.logoTeamB,
    required this.scoreA,
    required this.scoreB,
  });

  final String teamAName;
  final String teamBName;
  final String? logoTeamA;
  final String? logoTeamB;
  final int scoreA;
  final int scoreB;

  Widget logoTeam(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(Icons.shield_outlined, size: 36, color: Colors.white38);
    }
    return Image.network(
      url,
      width: 36,
      height: 36,
      fit: BoxFit.contain,
      errorBuilder:
          (_, _, _) => const Icon(
            Icons.shield_outlined,
            size: 36,
            color: Colors.white38,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: teamColumn(logoTeamA, teamAName)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "$scoreA  vs  $scoreB",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: teamColumn(logoTeamB, teamBName)),
      ],
    );
  }

  Widget teamColumn(String? url, String name) {
    return Column(
      children: [
        logoTeam(url),
        const SizedBox(height: 4),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
}
