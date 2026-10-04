import 'package:es_live/core/model/match_analyze.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MatchAnalyzeData.fromjson', () {
    test('แปลง JSON ที่มีครบทุก field ได้ถูกต้อง', () {
      final json = {
        'win_pct_a': 62.5,
        'win_pct_b': 37.5,
        'reasoning_eng': 'Catboys has a stronger recent form.',
        'reasoning_th': 'Catboys ฟอร์มดีกว่าในช่วงหลัง',
        'status': 'ready',
      };

      final analyze = MatchAnalyzeData.fromjson(json);

      expect(analyze.winRateA, 62.5);
      expect(analyze.winRateB, 37.5);
      expect(analyze.reasonEng, 'Catboys has a stronger recent form.');
      expect(analyze.reasonTh, 'Catboys ฟอร์มดีกว่าในช่วงหลัง');
      expect(analyze.status, 'ready');
    });

    test('ตอน status เป็น pending ยังไม่มีผลวิเคราะห์ ทุกช่องเป็น null ได้', () {
      final json = {
        'win_pct_a': null,
        'win_pct_b': null,
        'reasoning_eng': null,
        'reasoning_th': null,
        'status': 'pending',
      };

      final analyze = MatchAnalyzeData.fromjson(json);

      expect(analyze.winRateA, isNull);
      expect(analyze.reasonEng, isNull);
      // status ไม่มี ? จึงต้องมีค่าเสมอ
      expect(analyze.status, 'pending');
    });
  });

  group('MatchAnalyzeData.reasonFor', () {
    // ตัวช่วยสร้างข้อมูลทดสอบ จะได้ไม่ต้องพิมพ์ 5 ช่องซ้ำทุกเทส
    MatchAnalyzeData make({String? th, String? eng}) => MatchAnalyzeData(
      winRateA: 50,
      winRateB: 50,
      reasonEng: eng,
      reasonTh: th,
      status: 'ready',
    );

    test('ภาษาไทย ได้ข้อความไทย', () {
      expect(make(th: 'ไทย', eng: 'English').reasonFor('th'), 'ไทย');
    });

    test('ภาษาอังกฤษ ได้ข้อความอังกฤษ', () {
      expect(make(th: 'ไทย', eng: 'English').reasonFor('en'), 'English');
    });

    test('ภาษาไทยแต่ไม่มีข้อความไทย ถอยไปใช้อังกฤษ', () {
      expect(make(th: null, eng: 'English').reasonFor('th'), 'English');
    });

    test('ภาษาอังกฤษไม่มีข้อความ ได้ null ไม่ถอยไปใช้ไทย', () {
      expect(make(th: 'ไทย', eng: null).reasonFor('en'), isNull);
    });
  });
}
