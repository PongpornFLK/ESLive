import 'package:es_live/core/model/game_data.dart';

class PatchData {
  final String version;
  final GameData game;
  final String? time;
  final String? summaryEng;
  final String? summaryTh;
  final String content;
  final String? url;

  const PatchData({
    required this.version,
    required this.time,
    required this.game,
    required this.summaryEng,
    required this.summaryTh,
    required this.content,
    required this.url,
  });

  factory PatchData.fromjson(Map<String, dynamic> json) {
    return PatchData(
      game: GameData.fromjson(json['game']),
      time: json['published_at'],
      version: json['version'],
      summaryEng: json['ai_summary_eng'],
      summaryTh: json['ai_summary_th'],
      content: json['raw_content'],
      url: json['raw_source_url'],
    );
  }

  /// เลือกข้อความตามภาษาที่ผู้ใช้เลือกอยู่ ไม่มีก็ใช้อังกฤษ
  String? summaryFor(String langCode) {
    if (langCode == 'th') return summaryTh ?? summaryEng;

    return summaryEng;
  }
}
