import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/core/model/match_history.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// ฟอร์มล่าสุดของ 1 ทีม 1 แถว = 1 นัด
class HistoryMatch extends StatelessWidget {
  final String teamName;
  final List<MatchHistoryData> rows;

  const HistoryMatch({super.key, required this.teamName, required this.rows});

  Widget _logo(BuildContext context, String? url) {
    final faded = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.3);

    if (url == null || url.isEmpty) {
      return Icon(Icons.shield_outlined, size: 20, color: faded);
    }
    return Image.network(
      url,
      width: 20,
      height: 20,
      fit: BoxFit.contain,
      errorBuilder:
          (_, _, _) => Icon(Icons.shield_outlined, size: 20, color: faded),
    );
  }

  /// badge W / L
  Widget _badge(String result) {
    final isWin = result == "W";

    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isWin ? Colors.green : AppColors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        result,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            teamName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          if (rows.isEmpty)
            Text(
              l10n.noHistoryInSystem,
              style: const TextStyle(color: AppColors.grey, fontSize: 12),
            )
          else
            // จำนวนแถวมากสุด 5 ตามที่ backend จำกัดมา ใช้ Column ได้ไม่เปลือง
            ...rows.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    _badge(r.result),
                    const SizedBox(width: 10),
                    _logo(context, r.oppLogo),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        r.oppName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: onSurface, fontSize: 12),
                      ),
                    ),
                    Text(
                      "${r.scoreTeam ?? "-"} - ${r.scoreOpp ?? "-"}",
                      style: TextStyle(
                        color: onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
