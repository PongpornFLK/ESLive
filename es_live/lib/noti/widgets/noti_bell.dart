import 'package:es_live/_service/noti/noti_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/noti/widgets/noti_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Icon Bell Noti
class NotiBell extends ConsumerWidget {
  const NotiBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUnread = ref.watch(notiProvider).value?.hasUnread ?? false;

    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => showNotiSheet(context, ref),

      // Badge Alert
      icon: Badge(
        isLabelVisible: hasUnread,
        backgroundColor: AppColors.red,
        smallSize: 9,
        child: ShaderMask(
          shaderCallback:
              (bounds) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.gold, AppColors.orange],
              ).createShader(bounds),
          child: const Icon(Icons.notifications, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
