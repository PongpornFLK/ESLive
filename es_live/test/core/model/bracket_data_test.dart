import 'package:es_live/core/model/bracket_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BracketData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        "name": "Upper Final",
        "best_of_game": 3,
        "status": "finished",
        "begin_at": "2026-10-04T12:00:00+00:00",
        "team_a_name": "Catboys",
        "team_b_name": "HooK Esport",
        "score_a": 2,
        "score_b": 1,
        "winner_team": "Catboys",
        "from_matches": [
          {"match_id": 1, "type": "winner"},
          {"match_id": 2, "type": "loser"},
        ],
      };

      final data = BracketData.fromjson(json);

      expect(data.name, "Upper Final");
      expect(data.bestGame, 3);
      expect(data.status, "finished");
      expect(data.scoreA, 2);
      expect(data.scoreB, 1);
      expect(data.teamA, "Catboys");
      expect(data.teamB, "HooK Esport");
      expect(data.winnerTeam, "Catboys");
      expect(data.beginAt, "2026-10-04T12:00:00+00:00");
      // from_matches เป็นลิสต์ของก้อนซ้อน เทียบกับ "" ตรง ๆ ไม่ได้
      expect(data.fromMatches.length, 2);
      expect(data.fromMatches[0].macthId, 1);
      expect(data.fromMatches[1].type, "loser");
    });

    test('ตรวจสอบข้อมูลที่เป็นแบบ null สามารถรับได้ทั้งหมด', () {
      final json = {
        "name": "Grand Final",
        "best_of_game": 5,
        "status": "not_started",
        "begin_at": null,
        "team_a_name": null,
        "team_b_name": null,
        "score_a": 0,
        "score_b": 0,
        "winner_team": null,
        "from_matches": [],
      };

      final data = BracketData.fromjson(json);

      // 4 ช่องนี้ไม่มี ? จึงต้องมีค่าเสมอ แม้รอบนี้ยังไม่รู้คู่แข่ง
      expect(data.name, "Grand Final");
      expect(data.bestGame, 5);
      expect(data.status, "not_started");
      expect(data.scoreA, 0);
      expect(data.scoreB, 0);
      expect(data.teamA, isNull);
      expect(data.teamB, isNull);
      expect(data.winnerTeam, isNull);
      expect(data.beginAt, isNull);
      expect(data.fromMatches, isEmpty);
    });
  });
}
