import 'package:es_live/core/model/game_data.dart';
import 'package:es_live/core/model/patch_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PatchData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        'id': 'patch-1',
        'version': '13.06',
        // game เป็นก้อนซ้อนข้างใน ไม่ใช่ค่าเดี่ยว
        'game': {'name': 'Valorant', 'slug': 'valorant'},
        'published_at': '2026-10-01T00:00:00+00:00',
        'ai_summary_eng': 'Agent balance changes.',
        'ai_summary_th': 'ปรับสมดุลตัวละคร',
        'raw_source_url': 'https://playvalorant.com/patch-notes',
        'raw_content': 'เนื้อหาเต็มของแพตช์',
      };

      final patch = PatchData.fromjson(json);

      expect(patch.patchId, 'patch-1');
      expect(patch.version, '13.06');
      // ก้อนซ้อนต้องถูกแปลงเป็น GameData ไม่ใช่ปล่อยเป็น Map
      expect(patch.game.gameName, 'Valorant');
      expect(patch.time, '2026-10-01T00:00:00+00:00');
      expect(patch.summaryEng, 'Agent balance changes.');
      expect(patch.summaryTh, 'ปรับสมดุลตัวละคร');
      expect(patch.url, 'https://playvalorant.com/patch-notes');
      expect(patch.content, 'เนื้อหาเต็มของแพตช์');
    });

    test('raw_content ไม่มี เพราะ GET /patch ตัดออกเพื่อลดขนาด', () {
      final json = {
        'id': 'patch-2',
        'version': '13.07',
        'game': {'name': 'Valorant', 'slug': 'valorant'},
        'published_at': null,
        'ai_summary_eng': null,
        'ai_summary_th': null,
        'raw_source_url': null,
        'raw_content': null,
      };

      final patch = PatchData.fromjson(json);

      expect(patch.content, isNull);
      expect(patch.summaryEng, isNull);
      expect(patch.version, '13.07');
    });
  });

  group('PatchData.summaryFor', () {
    PatchData make({String? th, String? eng}) => PatchData(
      patchId: 'patch-1',
      version: '13.06',
      time: null,
      game: const GameData(gameName: 'Valorant', slug: 'valorant'),
      summaryEng: eng,
      summaryTh: th,
      url: null,
      content: null,
    );

    test('ภาษาไทย ได้ข้อความไทย', () {
      expect(make(th: 'ไทย', eng: 'English').summaryFor('th'), 'ไทย');
    });

    test('ภาษาอังกฤษ ได้ข้อความอังกฤษ', () {
      expect(make(th: 'ไทย', eng: 'English').summaryFor('en'), 'English');
    });

    test('ภาษาไทยแต่ยังไม่มีคำแปลไทย ถอยไปใช้อังกฤษ', () {
      expect(make(th: null, eng: 'English').summaryFor('th'), 'English');
    });
  });
}
