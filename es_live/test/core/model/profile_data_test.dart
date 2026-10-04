import 'package:es_live/core/model/profile_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // group รวมเทสที่เกี่ยวกับเรื่องเดียวกันไว้ด้วยกัน ชื่อจะโผล่นำหน้าตอนรัน
  group('ProfileData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        'display_name': 'Pong',
        'theme': 'dark',
        'language': 'th',
        'notify_all_matches': true,
        'notify_before_minutes': 30,
      };

      final profile = ProfileData.fromjson(json);

      expect(profile.displayName, 'Pong');
      expect(profile.theme, 'dark');
      expect(profile.language, 'th');
      expect(profile.notifyAllMatches, true);
      expect(profile.notifyBeforeMinutes, 30);
    });

    test('display_name เป็น null ได้ เพราะผู้ใช้ยังไม่ได้ตั้งชื่อ', () {
      final json = {
        'display_name': null,
        'theme': 'light',
        'language': 'en',
        'notify_all_matches': false,
        'notify_before_minutes': 15,
      };

      final profile = ProfileData.fromjson(json);

      expect(profile.displayName, isNull);
      // อีก 4 field ต้องยังอ่านได้ตามปกติ ไม่ถูก null ตัวแรกทำพัง
      expect(profile.theme, 'light');
      expect(profile.notifyAllMatches, false);
    });
  });
}
