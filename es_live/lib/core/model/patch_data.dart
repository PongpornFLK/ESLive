import 'package:es_live/core/model/game_data.dart';

class PatchData {
  final String version;
  final GameData game;
  final String? time;
  final String? summary;

  const PatchData({
    required this.version,
    required this.time,
    required this.game,
    required this.summary,
  });

  factory PatchData.fromjson(Map<String, dynamic> json) {
    return PatchData(
      game: GameData.fromjson(json['game']),
      time: json['published_at'],
      version: json['version'],
      summary: json['ai_summary']
    );
  }
}
