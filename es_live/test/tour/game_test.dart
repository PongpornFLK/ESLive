import 'package:es_live/tour/game.dart';
import 'package:es_live/tour/widgets/list_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap() => const MaterialApp(home: Scaffold(body: GameTour()));

  /// ย่อขยายหน้าจอจำลอง ส่งเป็นพิกเซลจริง หารด้วย devicePixelRatio ได้เป็น dp
  void setScreen(WidgetTester tester, {required double widthDp}) {
    tester.view.devicePixelRatio = 2.0;
    tester.view.physicalSize = Size(widthDp * 2, 1400);
    addTearDown(tester.view.reset);
  }

  testWidgets('กล่องโลโก้สูง 150 กว้าง 150', (tester) async {
    setScreen(tester, widthDp: 400);

    await tester.pumpWidget(wrap());
    await tester.pump();

    final box = tester.getSize(
      find
          .descendant(
            of: find.byType(ListGameTour).first,
            matching: find.byType(Container),
          )
          .first,
    );

    expect(box.height, 150);
    expect(box.width, 150);
  });

  // ช่องของ GridView คือเพดานจริงของกล่องรูป ถ้ากล่องสูงเกินช่องจะล้น
  // สองเคสนี้คือมุมที่แคบที่สุดกับฟอนต์ใหญ่สุด ซึ่งเป็นจุดที่จะล้นก่อนเพื่อน
  testWidgets('จอแคบ 360dp ไม่ล้น', (tester) async {
    setScreen(tester, widthDp: 360);

    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.byType(ListGameTour), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('จอแคบ 360dp พร้อมฟอนต์ใหญ่ 2 เท่า ไม่ล้น', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    setScreen(tester, widthDp: 360);

    await tester.pumpWidget(wrap());
    await tester.pump();

    expect(find.byType(ListGameTour), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
