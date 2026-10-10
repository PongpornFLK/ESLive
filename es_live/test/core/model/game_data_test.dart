import 'package:es_live/core/model/game_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameData.fromjson', () {
    test('แปลง JSON ของเกมได้ถูกต้อง', () {
      final json = {'name': 'Valorant', 'slug': 'valorant'};

      final game = GameData.fromjson(json);

      expect(game.gameName, 'Valorant');
      expect(game.slug, 'valorant');
    });
  });

  group('gameBySlug', () {
    test('slug ที่รองรับ คืนเกมพร้อม path โลโก้', () {
      expect(
        gameBySlug('valorant')?.logo,
        'assests/img/list_game/valorant.png',
      );
      expect(
        gameBySlug('league-of-legends')?.logo,
        'assests/img/list_game/league-of-legends.png',
      );
    });

    test('slug ที่ไม่รองรับ คืน null ให้คนเรียกไปตั้งค่าสำรองเอง', () {
      expect(gameBySlug('pubg'), isNull);
      expect(gameBySlug('cs-go'), isNull);
    });
  });
}
