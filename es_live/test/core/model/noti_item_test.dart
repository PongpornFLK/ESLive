import 'package:es_live/core/model/noti_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NotiItem.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        'title': 'อีก 15 นาทีจะเริ่มแข่ง',
        'body': 'Catboys พบ HooK Esport',
        'match_id': 'match-1',
        'received_at': '2026-10-04T12:00:00.000Z',
      };

      final item = NotiItem.fromjson(json);

      expect(item.title, 'อีก 15 นาทีจะเริ่มแข่ง');
      expect(item.body, 'Catboys พบ HooK Esport');
      expect(item.matchId, 'match-1');
      // received_at ถูกแปลงจากข้อความเป็น DateTime ไม่ใช่เก็บเป็นข้อความต่อ
      expect(item.receivedAt, DateTime.parse('2026-10-04T12:00:00.000Z'));
    });

    test('ไม่มี title กับ body ได้ค่าว่าง ไม่ใช่ null', () {
      final json = {
        'match_id': null,
        'received_at': '2026-10-04T12:00:00.000Z',
      };

      final item = NotiItem.fromjson(json);

      // พิสูจน์ว่า ?? '' ทำงาน ถ้าไม่มีบรรทัดนั้นจะแครชเพราะ title ประกาศเป็น String
      expect(item.title, '');
      expect(item.body, '');
      expect(item.matchId, isNull);
    });

    test('แปลงออกแล้วแปลงกลับได้ค่าเดิม', () {
      final original = NotiItem(
        title: 'แมตช์กำลังจะเริ่ม',
        body: 'Catboys พบ HooK Esport',
        matchId: 'match-1',
        receivedAt: DateTime.parse('2026-10-04T12:00:00.000Z'),
      );

      // ถ้าใครแก้ชื่อ key ใน toJson แต่ลืมแก้ใน fromjson เทสนี้จะจับได้
      final copy = NotiItem.fromjson(original.toJson());

      expect(copy.title, original.title);
      expect(copy.body, original.body);
      expect(copy.matchId, original.matchId);
      expect(copy.receivedAt, original.receivedAt);
    });

    test('received_at ที่ไม่ใช่รูปแบบวันที่ ต้องโยน error', () {
      final json = {'title': 'a', 'body': 'b', 'received_at': 'ไม่ใช่วันที่'};

      expect(() => NotiItem.fromjson(json), throwsFormatException);
    });
  });
}
