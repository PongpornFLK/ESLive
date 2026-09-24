import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final theme = Theme.of(context);
    final isLight = theme.brightness == Brightness.light;

    // ตัวที่ยังไม่ถูกเลือก นั่งอยู่บนพื้นแถบ จึงเปลี่ยนสีตามธีม
    final idle = theme.colorScheme.onSurface;

    // ตัวที่ถูกเลือก นั่งอยู่บนเม็ดยาสีส้ม ซึ่งส้มทั้งสองโหมด จึงต้องขาวเสมอ
    const active = Colors.white;

    return Container(
      padding: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.orange, AppColors.gold]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            // พื้นสว่างสะท้อนแสงมากกว่า ถ้าใช้ความเข้มเท่าโหมดมืดจะกลายเป็นรอยเปื้อน
            color: AppColors.orange.withValues(alpha: isLight ? 0.45 : 1),
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
      ),
      // มุมโค้งต้องเล็กกว่ากรอบนอก (25) เท่ากับความหนาของกรอบ (3) ไม่งั้นจะเจียนเกิน
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        child: NavigationBar(
          labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              color: selected ? AppColors.orange : idle,
              fontWeight: FontWeight.bold,
            );
          }),

          selectedIndex: currentIndex,
          indicatorColor: AppColors.orange,
          backgroundColor: theme.cardColor,
          // เงาใช้ของ Container ชั้นนอกแล้ว ไม่ให้ NavigationBar ผสมสีพื้นเองอีก
          elevation: 0,
          onDestinationSelected: onTap,
          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.live_tv_rounded, color: active),
              icon: Icon(Icons.live_tv_rounded, color: idle),
              label: l10n.navLive,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.line_style_outlined, color: active),
              icon: Icon(Icons.line_style_outlined, color: idle),
              label: l10n.navTour,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.star_border, color: active),
              icon: Icon(Icons.star_border, color: idle),
              label: l10n.navFollow,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.note_outlined, color: active),
              icon: Icon(Icons.note_outlined, color: idle),
              label: l10n.navPatch,
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.settings, color: active),
              icon: Icon(Icons.settings, color: idle),
              label: l10n.navSetting,
            ),
          ],
        ),
      ),
    );
  }
}
