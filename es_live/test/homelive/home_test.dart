import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/homelive/home.dart';
import 'package:es_live/homelive/widgets/list_game.dart';
import 'package:es_live/homelive/widgets/match_card.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MatchData makeMatch(
    String id, {
    String gameName = 'Valorant',
    String gameSlug = 'valorant',
  }) => MatchData.fromjson({
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
    'game': {'name': gameName, 'slug': gameSlug},
    'begin_at': '2026-10-04T12:00:00+00:00',
    'analysis': null,
  });

  // ไม่ override gameFilterProvider เลย ใช้ตัวจริง
  // เทสนี้จึงพิสูจน์สายไฟครบเส้น กดไอคอน -> provider -> รายการแมตช์
  Widget wrap(List<MatchData> matches) => ProviderScope(
    overrides: [matchProvider.overrideWith((ref) async => matches)],
    child: MaterialApp(
      locale: const Locale('th'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: Home()),
    ),
  );

  void setScreen(WidgetTester tester) {
    tester.view.devicePixelRatio = 2.0;
    // จอสูงไว้ก่อน หน้า Live มีสองช่องเรียงลงล่าง ถ้าเตี้ยไปจะล้น
    tester.view.physicalSize = const Size(800, 4000);
    addTearDown(tester.view.reset);
  }

  testWidgets('กดไอคอนเกม แล้วรายการแมตช์เหลือเฉพาะเกมนั้น', (tester) async {
    setScreen(tester);

    await tester.pumpWidget(
      wrap([
        makeMatch('1'),
        makeMatch(
          '2',
          gameName: 'League of Legends',
          gameSlug: 'league-of-legends',
        ),
      ]),
    );
    await tester.pump();

    // ตั้งต้นเห็นทั้งสองเกม
    expect(find.byType(MatchCard), findsNWidgets(2));

    // ชื่อที่ขึ้นใต้ไอคอนมาจาก game_data.dart ไม่ใช่ชื่อที่ API ส่งมา
    await tester.tap(find.widgetWithText(ListGame, 'LoL'));
    await tester.pump();

    expect(find.byType(MatchCard), findsOneWidget);
    expect(find.text('League of Legends'), findsOneWidget);

    // กดเกมเดิมซ้ำ = เลิกกรอง กลับมาเห็นทั้งสอง
    await tester.tap(find.widgetWithText(ListGame, 'LoL'));
    await tester.pump();

    expect(find.byType(MatchCard), findsNWidgets(2));
  });

  testWidgets('กดเกมอื่นทับ ตัวกรองย้ายไปเกมใหม่ ไม่ใช่เลือกค้างสองเกม', (
    tester,
  ) async {
    setScreen(tester);

    await tester.pumpWidget(
      wrap([
        makeMatch('1'),
        makeMatch(
          '2',
          gameName: 'League of Legends',
          gameSlug: 'league-of-legends',
        ),
      ]),
    );
    await tester.pump();

    await tester.tap(find.widgetWithText(ListGame, 'LoL'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ListGame, 'Valorant'));
    await tester.pump();

    expect(find.byType(MatchCard), findsOneWidget);
    expect(find.text('Valorant'), findsWidgets);

    // ไอคอนที่ถูกเลือกต้องเหลือใบเดียว
    final selected =
        tester
            .widgetList<ListGame>(find.byType(ListGame))
            .where((g) => g.selected)
            .toList();
    expect(selected.length, 1);
    expect(selected.first.gameName, 'Valorant');
  });
}
