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

  Widget logoTeam(BuildContext context, String? url) {
    // โล่จาง ๆ ตอนไม่มีโลโก้ทีม ต้องจางลงจากสีตัวอักษรของธีม
    // ไม่ใช่สีขาวตายตัว ไม่งั้นโหมดสว่างจะขาวบนขาว
    final faded = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.3);

    if (url == null || url.isEmpty) {
      return Icon(Icons.shield_outlined, size: 36, color: faded);
    }
    return Image.network(
      url,
      width: 36,
      height: 36,
      fit: BoxFit.contain,
      errorBuilder:
          (_, _, _) => Icon(Icons.shield_outlined, size: 36, color: faded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: teamColumn(context, logoTeamA, teamAName)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "$scoreA  vs  $scoreB",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: teamColumn(context, logoTeamB, teamBName)),
      ],
    );
  }

  Widget teamColumn(BuildContext context, String? url, String name) {
    return Column(
      children: [
        logoTeam(context, url),
        const SizedBox(height: 4),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
