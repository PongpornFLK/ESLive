import 'dart:ui';

import 'package:es_live/_service/noti/noti_pro.dart';
import 'package:es_live/core/model/noti_item.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// List-noti ปิดแล้วจุดแดงบนกระดิ่งหายไป
Future<void> showNotiSheet(BuildContext context, WidgetRef ref) async {
  await showDialog(
    context: context,
    // จางกว่าปกติ เพราะตัวแผงเบลอพื้นหลังอยู่แล้ว ทับสองชั้นจะมืดเกินไป
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => const _NotiSheet(),
  );

  await ref.read(notiProvider.notifier).markRead();
}

class _NotiSheet extends ConsumerWidget {
  const _NotiSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(notiProvider).value?.items ?? [];
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onGlass = theme.colorScheme.onSurface;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 56,
          left: 12,
          right: 12,
        ),
        child: Material(
          color: Colors.transparent,
          // ClipRRect ต้องครอบ BackdropFilter เสมอ ไม่งั้นความเบลอล้นออกนอกมุมโค้ง
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              // เบลอเพื่อกลบลายพื้นหลัง ไม่ใช่เพื่อความสวย
              // sigma 12 กลบได้พอ ๆ กับ 18 แต่ประหยัดกว่าเกือบครึ่ง
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                constraints: const BoxConstraints(maxHeight: 420),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // เบลอกลบลายให้ชั้นหนึ่งแล้ว สีพื้นจึงโปร่งได้โดยยังอ่านออก
                  // ไล่ทึบ -> จางแนวทแยง ให้ดูเหมือนแสงตกกระทบบนกระจก
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.cardColor.withValues(alpha: 0.82),
                      theme.cardColor.withValues(alpha: 0.62),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SheetHeader(
                      title: l10n.notifications,
                      clearLabel: l10n.clearAll,
                      textColor: onGlass,
                      onClear:
                          items.isEmpty
                              ? null
                              : () =>
                                  ref.read(notiProvider.notifier).clearAll(),
                    ),
                    const SizedBox(height: 8),
                    if (items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          l10n.noNotiYet,
                          style: TextStyle(
                            color: onGlass.withValues(alpha: 0.7),
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: items.length,
                          separatorBuilder:
                              (_, __) => Divider(
                                color: onGlass.withValues(alpha: 0.2),
                                height: 18,
                              ),
                          itemBuilder:
                              (_, i) => NotiRow(
                                item: items[i],
                                textColor: onGlass,
                                onTap: () {
                                  Navigator.pop(context);
                                  final id = items[i].matchId;
                                  if (id != null) {
                                    ref
                                        .read(notiProvider.notifier)
                                        .openMatch(id);
                                  }
                                },
                              ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.title,
    required this.clearLabel,
    required this.textColor,
    required this.onClear,
  });

  final String title;
  final String clearLabel;
  final Color textColor;

  /// null = ยังไม่มีอะไรให้ล้าง ปุ่มจะจางลงเองและกดไม่ได้
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: onClear,
          style: TextButton.styleFrom(
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            clearLabel,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

/// แจ้งเตือน 1 บรรทัดในรายการ
class NotiRow extends StatelessWidget {
  const NotiRow({
    super.key,
    required this.item,
    required this.textColor,
    required this.onTap,
  });

  final NotiItem item;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('HH.mm').format(item.receivedAt);

    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '• ${item.body}',
            style: TextStyle(
              color: textColor.withValues(alpha: 0.9),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
