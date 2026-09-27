import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// เก็บผลไว้ให้เข้าหน้า Home จะใช้ของเดิม ไม่โหลดซ้ำ
class LiveCountText extends ConsumerWidget {
  const LiveCountText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchProvider);
    final l10n = AppLocalizations.of(context);

    // ระหว่างรอ ไม่โชว์
    final matches = matchAsync.value;
    if (matches == null) return const SizedBox.shrink();

    final liveCount = matches.where((m) => m.status == "live").length;

    return Text(
      l10n.liveCountNow(liveCount),
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.red, fontWeight: FontWeight.w900),
    );
  }
}
