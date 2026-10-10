import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/homelive/widgets/match_card.dart';
import 'package:es_live/homelive/widgets/match_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // แมตช์ปลอม พอให้รู้ว่าเรียงเป็นกี่คอลัมน์
  // status แยกเป็น parameter เพราะเทสกลุ่มที่ 2 ต้องปน canceled เข้าไปด้วย
  MatchData makeMatch(String id, {String status = 'live'}) =>
      MatchData.fromjson({
        'id': id,
        'status': status,
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
  // sectionStatus คือค่าที่ home.dart ส่งเข้ามาบอกว่านี่คือช่องไหน
  // matches คือข้อมูลที่ provider คืนให้  ไม่ส่งมาก็ได้ live 2 นัดเป็นค่าตั้งต้น
  Widget wrap({String sectionStatus = 'live', List<MatchData>? matches}) =>
      ProviderScope(
        overrides: [
          matchProvider.overrideWith(
            (ref) async => matches ?? [makeMatch('1'), makeMatch('2')],
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MatchSection(status: sectionStatus, emptyText: 'ไม่มีแมตช์'),
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

  group('MatchSection คัดแมตช์เข้าช่อง', () {
    // แมตช์ที่ถูกยกเลิกไม่มีช่องของตัวเอง ต้องไปเกาะช่อง upcoming
    // ไม่งั้นคนที่รอดูคู่นั้นจะไม่รู้เลยว่าไม่ได้แข่งแล้ว
    testWidgets('ช่อง upcoming เอาแมตช์ที่ถูกยกเลิกมาแสดงด้วย', (tester) async {
      setScreen(tester, widthDp: 400);

      await tester.pumpWidget(
        wrap(
          sectionStatus: 'upcoming',
          matches: [
            makeMatch('1', status: 'upcoming'),
            makeMatch('2', status: 'canceled'),
          ],
        ),
      );
      await tester.pump();

      expect(find.byType(MatchCard), findsNWidgets(2));
      // ป้ายที่ BuildTopic วาดแทนเวลา เป็นหลักฐานว่า canceled ใบนั้นเข้ามาจริง
      expect(find.text('canceled'), findsOneWidget);
    });

    // ด่านคู่ของเทสบน กันตัวกรองกว้างเกินไปจนยกเลิกไปโผล่ใต้หัวข้อ Live
    testWidgets('ช่อง live ไม่เอาแมตช์ที่ถูกยกเลิก', (tester) async {
      setScreen(tester, widthDp: 400);

      await tester.pumpWidget(
        wrap(
          sectionStatus: 'live',
          matches: [makeMatch('1', status: 'canceled')],
        ),
      );
      await tester.pump();

      expect(find.byType(MatchCard), findsNothing);
      expect(find.text('ไม่มีแมตช์'), findsOneWidget);
    });
  });
}
