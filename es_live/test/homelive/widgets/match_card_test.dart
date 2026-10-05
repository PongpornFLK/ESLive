import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/homelive/widgets/match_card.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // MatchCard ต้องการ MatchData 1 ก้อนเพื่อส่งต่อตอนกดเข้าหน้า analyze
  // สร้างจาก fromjson เพราะพิมพ์สั้นกว่าประกอบ 4 โมเดลเองทีละตัว
  MatchData makeMatch() => MatchData.fromjson({
    'id': 'match-1',
    'status': 'live',
    'team_a': {'id': 'a', 'name': 'Catboys', 'logo_url': null},
    'team_b': {'id': 'b', 'name': 'HooK Esport', 'logo_url': null},
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

  // widget ที่วาดเดี่ยว ๆ ต้องมี MaterialApp ครอบ ไม่งั้นพังเพราะหา
  // Directionality กับ Theme ไม่เจอ ของจริงมี MaterialApp ครอบอยู่ที่ main.dart
  Widget wrap({required bool isLive, String? logoA}) => MaterialApp(
    home: Scaffold(
      body: MatchCard(
        gameName: 'Valorant',
        leagueName: 'VCT Pacific',
        teamAName: 'Catboys',
        teamBName: 'HooK Esport',
        logoTeamA: logoA,
        logoTeamB: null,
        scoreA: 1,
        scoreB: 0,
        isLive: isLive,
        time: '2026-10-04T12:00:00+00:00',
        match: makeMatch(),
      ),
    ),
  );

  group('MatchCard', () {
    testWidgets('แสดงชื่อเกม ชื่อลีก ชื่อทีม และสกอร์ครบ', (tester) async {
      await tester.pumpWidget(wrap(isLive: false));

      expect(find.text('Valorant'), findsOneWidget);
      expect(find.text('VCT Pacific'), findsOneWidget);
      expect(find.text('Catboys'), findsOneWidget);
      expect(find.text('HooK Esport'), findsOneWidget);
      // BuildTeam ต่อสกอร์เป็นข้อความเดียว เว้นวรรค 2 ช่องรอบคำว่า vs
      expect(find.text('1  vs  0'), findsOneWidget);
    });

    testWidgets('กำลังไลฟ์ โชว์จุดไลฟ์ ไม่โชว์เวลา', (tester) async {
      await tester.pumpWidget(wrap(isLive: true));
      // ใช้ pump ไม่ใช่ pumpAndSettle เพราะ LiveCircle หมุนไม่มีวันจบ
      // pumpAndSettle จะรอจนหมดเวลาแล้ว error
      await tester.pump();

      expect(find.byType(LiveCircle), findsOneWidget);
    });

    testWidgets('ยังไม่ไลฟ์ โชว์เวลา ไม่โชว์จุดไลฟ์', (tester) async {
      await tester.pumpWidget(wrap(isLive: false));

      expect(find.byType(LiveCircle), findsNothing);
      // เวลาต้องถูกจัดรูปแบบก่อนแสดง ไม่ใช่โยนข้อความดิบจาก server ขึ้นจอ
      expect(find.text('2026-10-04T12:00:00+00:00'), findsNothing);
    });

    testWidgets('ทีมที่ไม่มีโลโก้ แสดงไอคอนโล่แทน', (tester) async {
      // ส่ง null ทั้งสองทีม ต้องได้ไอคอนโล่ 2 อัน
      await tester.pumpWidget(wrap(isLive: false, logoA: null));

      expect(find.byIcon(Icons.shield_outlined), findsNWidgets(2));
    });
  });
}
