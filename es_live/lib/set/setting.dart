import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/core/theme/theme_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Setting extends ConsumerWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        Text(
          'SETTINGS',
          style: TextStyle(
            color: AppColors.orange,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),

        _SectionCard(
          title: 'Theme',
          subtitle: 'เลือกโหมดสีของแอป',
          children: [
            _ThemeTile(
              mode: ThemeMode.system,
              current: mode,
              icon: Icons.brightness_auto_rounded,
              label: 'ตามระบบ',
              detail: 'เปลี่ยนตามการตั้งค่าของเครื่อง',
            ),
            _ThemeTile(
              mode: ThemeMode.light,
              current: mode,
              icon: Icons.light_mode_rounded,
              label: 'สว่าง',
              detail: 'พื้นหลังสีอ่อน',
            ),
            _ThemeTile(
              mode: ThemeMode.dark,
              current: mode,
              icon: Icons.dark_mode_rounded,
              label: 'มืด',
              detail: 'พื้นหลังสีเข้ม',
            ),
          ],
        ),
      ],
    );
  }
}

// ===== กล่องหัวข้อการตั้งค่า =====

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: AppColors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...children,
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ===== หนึ่งตัวเลือกโหมด =====

class _ThemeTile extends ConsumerWidget {
  final ThemeMode mode;
  final ThemeMode current;
  final IconData icon;
  final String label;
  final String detail;

  const _ThemeTile({
    required this.mode,
    required this.current,
    required this.icon,
    required this.label,
    required this.detail,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selected = mode == current;

    return InkWell(
      onTap: () => ref.read(themeModeProvider.notifier).setMode(mode),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.orange : AppColors.grey,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: TextStyle(fontSize: 11, color: AppColors.grey),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle_rounded, color: AppColors.orange, size: 20)
            else
              Icon(
                Icons.circle_outlined,
                color: AppColors.grey.withValues(alpha: 0.5),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
