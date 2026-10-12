import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/homelive/widgets/list_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap({required bool selected, VoidCallback? onTap}) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: ListGame(
          logo: 'assests/img/list_game/valorant.png',
          gameName: 'Valorant',
          selected: selected,
          onTap: onTap ?? () {},
        ),
      ),
    ),
  );

  /// กรอบกล่องไอคอน
  BoxDecoration boxOf(WidgetTester tester) {
    final box = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(ListGame),
            matching: find.byType(Container),
          )
          .first,
    );
    return box.decoration! as BoxDecoration;
  }

  testWidgets('ยังไม่ถูกเลือก ไม่มีกรอบ ชื่อเกมเป็นสีปกติ', (tester) async {
    await tester.pumpWidget(wrap(selected: false));

    expect(boxOf(tester).border, isNull);

    final label = tester.widget<Text>(find.text('Valorant'));
    expect(label.style?.color, isNot(AppColors.orange));
    expect(label.style?.fontWeight, FontWeight.w400);
  });

  testWidgets('ถูกเลือก มีกรอบส้ม ชื่อเกมเป็นสีส้มตัวหนา', (tester) async {
    await tester.pumpWidget(wrap(selected: true));

    final border = boxOf(tester).border as Border;
    expect(border.top.color, AppColors.orange);
    expect(border.top.width, 3);

    final label = tester.widget<Text>(find.text('Valorant'));
    expect(label.style?.color, AppColors.orange);
    expect(label.style?.fontWeight, FontWeight.w700);
  });

  testWidgets('กดแล้วเรียก onTap หนึ่งครั้ง', (tester) async {
    var taps = 0;
    await tester.pumpWidget(wrap(selected: false, onTap: () => taps++));

    await tester.tap(find.byType(ListGame));
    await tester.pump();

    expect(taps, 1);
  });
}
