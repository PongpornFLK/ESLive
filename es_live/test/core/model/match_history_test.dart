import 'package:es_live/core/model/match_history.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MatchHistoryData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        'result': 'win',
        'opponent_name': 'HooK Esport',
        'opponent_logo': 'https://example.com/hook.png',
        'score_team': 2,
        'score_opponent': 1,
      };

      final row = MatchHistoryData.fromjson(json);

      expect(row.result, 'win');
      expect(row.oppName, 'HooK Esport');
      expect(row.oppLogo, 'https://example.com/hook.png');
      expect(row.scoreTeam, 2);
      expect(row.scoreOpp, 1);
    });

    test('โลโก้และสกอร์เป็น null ได้', () {
      final json = {
        'result': 'loss',
        'opponent_name': 'Catboys',
        'opponent_logo': null,
        'score_team': null,
        'score_opponent': null,
      };

      final row = MatchHistoryData.fromjson(json);

      expect(row.oppLogo, isNull);
      expect(row.scoreTeam, isNull);
      expect(row.result, 'loss');
    });
  });

  group('HistoryObj.fromjson', () {
    test('แปลงรายการของทั้งสองทีมเป็น List ของ MatchHistoryData', () {
      final json = {
        'form_a': [
          {
            'result': 'win',
            'opponent_name': 'Team X',
            'opponent_logo': null,
            'score_team': 2,
            'score_opponent': 0,
          },
          {
            'result': 'loss',
            'opponent_name': 'Team Y',
            'opponent_logo': null,
            'score_team': 1,
            'score_opponent': 2,
          },
        ],
        'form_b': [
          {
            'result': 'win',
            'opponent_name': 'Team Z',
            'opponent_logo': null,
            'score_team': 2,
            'score_opponent': 1,
          },
        ],
      };

      final history = HistoryObj.fromjson(json);

      expect(history.formA.length, 2);
      expect(history.formB.length, 1);
      // ของในลิสต์ต้องเป็น MatchHistoryData แล้ว ไม่ใช่ Map ดิบ
      expect(history.formA[0].oppName, 'Team X');
      expect(history.formA[1].result, 'loss');
      expect(history.formB[0].scoreOpp, 1);
    });

    test('ทีมที่ยังไม่เคยแข่ง ได้ลิสต์ว่าง ไม่ใช่ null', () {
      final json = {'form_a': [], 'form_b': []};

      final history = HistoryObj.fromjson(json);

      expect(history.formA, isEmpty);
      expect(history.formB, isEmpty);
    });
  });
}
