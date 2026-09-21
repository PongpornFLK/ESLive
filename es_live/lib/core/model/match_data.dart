import 'package:es_live/core/model/game_data.dart';
import 'package:es_live/core/model/match_analyze.dart';
import 'package:es_live/core/model/team_data.dart';
import 'package:es_live/core/model/tour_data.dart';

class MatchData {
  final String id;
  final String status;
  final GameData game;
  final TeamData teamA;
  final TeamData teamB;
  final int scoreA;
  final int scoreB;
  final String? streamUrl;
  final TournamentData tournament;
  final String beginAt;
  final MatchAnalyzeData? matchAnalyze;

  const MatchData({
    required this.id,
    required this.status,
    required this.teamA,
    required this.teamB,
    required this.scoreA,
    required this.scoreB,
    required this.streamUrl,
    required this.tournament,
    required this.game,
    required this.beginAt,
    required this.matchAnalyze,
  });

  factory MatchData.fromjson(Map<String, dynamic> json) {
    return MatchData(
      id : json["id"],
      status: json['status'],
      teamA: TeamData.fromjson(json["team_a"]),
      teamB: TeamData.fromjson(json["team_b"]),
      scoreA: json['score_a'],
      scoreB: json['score_b'],
      streamUrl: json['stream_url'],
      tournament: TournamentData.fromjson(json["tournament"]),
      game: GameData.fromjson(json["game"]),
      beginAt: json['begin_at'],
      matchAnalyze:
          json["analysis"] == null
              ? null
              : MatchAnalyzeData.fromjson(json["analysis"]),
    );
  }
}
