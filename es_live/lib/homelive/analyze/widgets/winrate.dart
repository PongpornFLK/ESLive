import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Winrate extends StatelessWidget {
  final double winRateA;
  final double winRateB;
  final String logoTeamAUrl;
  final String logoTeamBUrl;

  const Winrate({
    super.key,
    required this.winRateA,
    required this.winRateB,
    required this.logoTeamAUrl,
    required this.logoTeamBUrl,
  });

  /// โลโก้ทีม ใช้ไอคอนโล่จาง ๆ แทนเมื่อไม่มีรูป (กติกาเดียวกับ build_team.dart)
  Widget _logo(BuildContext context, String url) {
    final faded = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.3);

    if (url.isEmpty) {
      return Icon(Icons.shield_outlined, size: 32, color: faded);
    }
    return Image.network(
      url,
      width: 32,
      height: 32,
      fit: BoxFit.contain,
      errorBuilder:
          (_, _, _) => Icon(Icons.shield_outlined, size: 32, color: faded),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    // ยังไม่ได้วิเคราะห์จะได้ 0 ทั้งคู่ อย่าโชว์ "0% - 0%" ให้เหมือนทีมไม่มีโอกาสชนะ
    final hasData = winRateA + winRateB > 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.winRate,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _logo(context, logoTeamAUrl),
                  const SizedBox(width: 8),
                  Text(
                    hasData ? "${winRateA.toStringAsFixed(0)}%" : "-",
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    hasData ? "${winRateB.toStringAsFixed(0)}%" : "-",
                    style: TextStyle(
                      color: onSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _logo(context, logoTeamBUrl),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 10,
            barRadius: const Radius.circular(50),
            percent: (winRateA / 100).clamp(0.0, 1.0), // widget รับ 0.0-1.0
            progressColor: AppColors.orange,
            backgroundColor: onSurface.withValues(alpha: 0.15),
          ),
          if (!hasData) ...[
            const SizedBox(height: 8),
            Text(
              l10n.noAnalysisYet,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
