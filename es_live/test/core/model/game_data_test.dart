import 'package:es_live/core/model/game_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameData.fromjson', () {
    test('แปลง JSON ที่มี field เดียวได้ถูกต้อง', () {
      final json = {'name': 'Valorant'};

      final game = GameData.fromjson(json);

      expect(game.gameName, 'Valorant');
    });
  });
}
