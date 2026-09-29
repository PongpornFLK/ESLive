import 'package:es_live/_service/noti/noti_switch_pro.dart';
import 'package:es_live/core/lang/locale_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/core/theme/theme_pro.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/set/widgets/account_tile.dart';
import 'package:es_live/set/widgets/lang_tile.dart';
import 'package:es_live/set/widgets/noti_tile.dart';
import 'package:es_live/set/widgets/section_card.dart';
import 'package:es_live/set/widgets/theme_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// หน้าตั้งค่า ทำหน้าที่ประกอบ section เท่านั้น
/// หน้าตาของแต่ละแถวอยู่ใน set/widgets/
class Setting extends ConsumerWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final notiOn = ref.watch(notiSwitchProvider);
    final l10n = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        Text(
          l10n.settings,
          style: const TextStyle(
            color: AppColors.orange,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),

        SectionCard(
          title: l10n.theme,
          subtitle: l10n.themeSubtitle,
          children: [
            ThemeTile(
              mode: ThemeMode.system,
              current: mode,
              icon: Icons.brightness_auto_rounded,
              label: l10n.themeSystem,
              detail: l10n.themeSystemDetail,
            ),
            ThemeTile(
              mode: ThemeMode.light,
              current: mode,
              icon: Icons.light_mode_rounded,
              label: l10n.themeLight,
              detail: l10n.themeLightDetail,
            ),
            ThemeTile(
              mode: ThemeMode.dark,
              current: mode,
              icon: Icons.dark_mode_rounded,
              label: l10n.themeDark,
              detail: l10n.themeDarkDetail,
            ),
          ],
        ),
        const SizedBox(height: 16),

        SectionCard(
          title: l10n.language,
          subtitle: l10n.languageSubtitle,
          children: [
            LangTile(
              locale: const Locale('en'),
              current: locale,
              label: l10n.langEnglish,
              detail: l10n.langEnglishDetail,
            ),
            LangTile(
              locale: const Locale('th'),
              current: locale,
              label: l10n.langThai,
              detail: l10n.langThaiDetail,
            ),
          ],
        ),
        const SizedBox(height: 16),

        SectionCard(
          title: l10n.notifications,
          subtitle: l10n.notiSubtitle,
          children: [
            NotiTile(
              value: true,
              current: notiOn,
              icon: Icons.notifications_active_rounded,
              label: l10n.notiOn,
              detail: l10n.notiOnDetail,
            ),
            NotiTile(
              value: false,
              current: notiOn,
              icon: Icons.notifications_off_rounded,
              label: l10n.notiOff,
              detail: l10n.notiOffDetail,
            ),
          ],
        ),
        const SizedBox(height: 16),

        SectionCard(
          title: l10n.account,
          subtitle: l10n.accountSubtitle,
          children: const [AccountTile()],
        ),
      ],
    );
  }
}
