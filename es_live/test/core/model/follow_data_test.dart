import 'package:es_live/core/model/follow_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FollowData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        'team_id': 'team-1',
        'team_name': 'Catboys',
        'logo_url': 'https://example.com/catboys.png',
      };

      final follow = FollowData.fromjson(json);

      expect(follow.teamId, 'team-1');
      expect(follow.teamName, 'Catboys');
      expect(follow.logoUrl, 'https://example.com/catboys.png');
    });

    test('logo_url เป็น null ได้ เพราะบางทีมไม่มีโลโก้', () {
      final json = {
        'team_id': 'team-2',
        'team_name': 'HooK Esport',
        'logo_url': null,
      };

      final follow = FollowData.fromjson(json);

      expect(follow.logoUrl, isNull);
      expect(follow.teamName, 'HooK Esport');
    });
  });
}
