class BracketData {
  final String name;
  final int bestGame;
  final String status;
  final String? beginAt;
  final String? teamA;
  final String? teamB;
  final int scoreA;
  final int scoreB;
  final List<PreMatches> fromMatches;
  final String? winnerTeam;

  const BracketData({
    required this.name,
    required this.bestGame,
    required this.status,
    required this.beginAt,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.fromMatches,
    required this.winnerTeam,
  });

  factory BracketData.fromjson(Map<String, dynamic> json) {
    return BracketData(
      name: json['name'],
      bestGame: json['best_of_game'],
      status: json['status'],
      beginAt: json['begin_at'],
      teamA: json['team_a_name'],
      teamB: json['team_b_name'],
      scoreA: json['score_a'],
      scoreB: json['score_b'],
      winnerTeam: json['winner_team'],
      fromMatches:
          (json['from_matches'] as List)
              .map((e) => PreMatches.fromjson(e))
              .toList(),
    );
  }
}

class PreMatches {
  final String type;
  final int macthId;

  const PreMatches({required this.type, required this.macthId});
  factory PreMatches.fromjson(Map<String, dynamic> json) {
    return PreMatches(macthId: json['match_id'], type: json['type']);
  }
}
