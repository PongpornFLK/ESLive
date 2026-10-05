import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/patch/widgets/patch_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  Widget wrap({
    String? time = "2026-09-22 13:00:00+00",
    String? summary =
        '- Introduced a new 2900 credits rifle named Warden with a 2x scope and 18 bullets per magazine.',
    String? logoGame = 'valo.png',
  }) => MaterialApp(

    // เพิ่มระบบภาษา
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),

    // Widget
    home: Scaffold(
      body: PatchCard(
        gameName: "Valorant",
        logoGame: logoGame,
        patchId: "uuid",
        summary: summary,
        time: time,
        url:
            "https://playvalorant.com/en-us/news/game-updates/valorant-patch-notes-13-06/",
        version: "13.06",
      ),
    ),
  );

  group("PatchCard", () {
    testWidgets(
      "แสดงชื่อเกม สรุปการวิเคราะห์ เวอร์ชั่นของแพท วันเวลาที่ปล่อย และโลโก้เกม",
      (tester) async {
        await tester.pumpWidget(wrap());

        final ciTime = DateFormat(
          "HH.mm - dd/MM/yyyy",
        ).format(DateTime.parse('2026-09-22 13:00:00+00').toLocal());

        expect(find.text('Valorant'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
        expect(
          find.text(
            '- Introduced a new 2900 credits rifle named Warden with a 2x scope and 18 bullets per magazine.',
          ),
          findsOneWidget,
        );
        expect(find.text(ciTime), findsOneWidget);
        expect(find.text('Patch 13.06'), findsOneWidget);
      },
    );

    testWidgets(
      "ไม่มีข้อมูลการสรุป",
      (tester) async {
        await tester.pumpWidget(wrap(summary: null));

        expect(find.text("AI summary in progress"), findsOneWidget);
      },
    );
    
    testWidgets(
      "ไม่มี Logo game แสดง",
      (tester) async {
        await tester.pumpWidget(wrap(logoGame: null));
        await tester.pump();

        expect(find.byIcon(Icons.videogame_asset), findsOneWidget);
      },
    );

    testWidgets(
      "ไม่มีเวลาแสดงตามรูปแบบ",
      (tester) async {
        await tester.pumpWidget(wrap(time:null));

        expect(find.text("--/--/--"), findsOneWidget);
      },
    );
  });
}
