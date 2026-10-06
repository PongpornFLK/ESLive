import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/homelive/widgets/match_card.dart';
import 'package:es_live/homelive/widgets/match_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // แมตช์ปลอม 2 นัด พอให้รู้ว่าเรียงเป็นกี่คอลัมน์
  MatchData makeMatch(String id) => MatchData.fromjson({
    'id': id,
    'status': 'live',
    'team_a': {'id': 'a$id', 'name': 'Catboys', 'logo_url': null},
    'team_b': {'id': 'b$id', 'name': 'HooK Esport', 'logo_url': null},
    'score_a': 1,
    'score_b': 0,
    'stream_url': null,
    'tournament': {
      'id': 'tour-1',
      'name': 'VCT Pacific',
      'league_name': 'VCT',
      'league_logo_url': null,
      'begin_at': null,
      'end_at': null,
      'region': null,
      'type': null,
      'team_count': null,
      'has_bracket': false,
      'prizepool': null,
    },
    'game': {'name': 'Valorant'},
    'begin_at': '2026-10-04T12:00:00+00:00',
    'analysis': null,
  });

  // matchProvider ตัวจริงยิง dio ไปหา server  ในเทสเราสับเปลี่ยนเป็นข้อมูลปลอม
  Widget wrap() => ProviderScope(
    overrides: [
      matchProvider.overrideWith(
        (ref) async => [makeMatch('1'), makeMatch('2')],
      ),
    ],
    child: const MaterialApp(
      home: Scaffold(
        body: MatchSection(status: 'live', emptyText: 'ไม่มีแมตช์'),
      ),
    ),
  );

  /// ย่อขยายหน้าจอจำลอง  ส่งเป็นพิกเซลจริง หารด้วย devicePixelRatio ได้เป็น dp
  void setScreen(WidgetTester tester, {required double widthDp}) {
    tester.view.devicePixelRatio = 2.0;
    tester.view.physicalSize = Size(widthDp * 2, 1200);
    addTearDown(tester.view.reset);
  }

  group('MatchSection ปรับคอลัมน์ตามความกว้างจอ', () {
    testWidgets('จอแคบ 400dp ได้ 1 คอลัมน์ การ์ดเรียงลงล่าง', (tester) async {
      setScreen(tester, widthDp: 400);

      await tester.pumpWidget(wrap());
      await tester.pump(); // รอ FutureProvider คืนข้อมูล

      final cards = find.byType(MatchCard);
      expect(cards, findsNWidgets(2));

      final first = tester.getTopLeft(cards.at(0));
      final second = tester.getTopLeft(cards.at(1));

      // คนละแถว = เรียงลงล่าง
      expect(second.dy, greaterThan(first.dy));
      expect(second.dx, first.dx);
    });

    testWidgets('จอกว้าง 1000dp การ์ดเรียงข้างกันในแถวเดียว', (tester) async {
      setScreen(tester, widthDp: 1000);

      await tester.pumpWidget(wrap());
      await tester.pump();

      final cards = find.byType(MatchCard);
      expect(cards, findsNWidgets(2));

      final first = tester.getTopLeft(cards.at(0));
      final second = tester.getTopLeft(cards.at(1));

      // แถวเดียวกัน = เรียงข้างกัน
      expect(second.dy, first.dy);
      expect(second.dx, greaterThan(first.dx));
    });

    testWidgets('ฟอนต์ใหญ่ 2 เท่า การ์ดต้องไม่ล้น', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      setScreen(tester, widthDp: 1000); // ← เคสหนักสุด
      await tester.pumpWidget(wrap());
      await tester.pump();

      expect(find.byType(MatchCard), findsNWidgets(2));
    });
  });
}
