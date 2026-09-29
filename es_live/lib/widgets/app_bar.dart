import 'package:es_live/noti/widgets/noti_bell.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border(bottom: BorderSide(color: theme.dividerColor)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // โลโก้ = รูปไอคอน + ตัวอักษรที่เขียนด้วยโค้ด
            // แยกกันแบบนี้เพื่อให้ตัวอักษรเปลี่ยนสีตามธีมได้ (ในไฟล์รูปเปลี่ยนไม่ได้)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assests/img/bg-joingame.png', height: 30),
                const SizedBox(width: 8),
                Text(
                  'ES-Live',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontFamily: 'Genos',
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const NotiBell(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
