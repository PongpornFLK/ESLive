import 'package:es_live/core/model/group.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GroupData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        'rank': 1,
        'team_name': 'Catboys',
        'team_logo': 'https://example.com/catboys.png',
        'matches_played': 10,
        'wins': 7,
        'losses': 3,
        'game_wins': 15,
        'game_losses': 8,
        'game_ties': 1,
      };

      final row = GroupData.fromjson(json);

      expect(row.rank, 1);
      expect(row.teamName, 'Catboys');
      expect(row.teamLogo, 'https://example.com/catboys.png');
      expect(row.matchePlay, 10);
      expect(row.win, 7);
      expect(row.loss, 3);
      expect(row.gameWin, 15);
      expect(row.gameLoss, 8);
      expect(row.gameTie, 1);
    });

    test('สถิติเป็น null ได้ทั้งหมด เพราะทัวร์ที่ยังไม่เริ่มยังไม่มีตัวเลข', () {
      final json = {
        'rank': 5,
        'team_name': 'HooK Esport',
        'team_logo': null,
        'matches_played': null,
        'wins': null,
        'losses': null,
        'game_wins': null,
        'game_losses': null,
        'game_ties': null,
      };

      final row = GroupData.fromjson(json);

      // rank กับ team_name ไม่มี ? จึงต้องมีค่าเสมอ
      expect(row.rank, 5);
      expect(row.teamName, 'HooK Esport');
      expect(row.teamLogo, isNull);
      expect(row.matchePlay, isNull);
      expect(row.win, isNull);
      expect(row.gameTie, isNull);
    });
  });
}
