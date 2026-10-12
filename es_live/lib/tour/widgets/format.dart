import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Format extends StatelessWidget {
  final String? tourName;
  final String? leagueName;
  final String? startDate;
  final String? endDate;
  final String? type;
  final int? teamCount;
  final String? prizePool;

  const Format({
    super.key,
    required this.tourName,
    required this.leagueName,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.teamCount,
    required this.prizePool,
  });

  String _fmt(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    final date = DateTime.tryParse(iso);
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final info = TextStyle(color: onSurface, fontSize: 12);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  leagueName ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          Text(
            tourName ?? '-',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.grey, fontSize: 13),
          ),

          const SizedBox(height: 10),

          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              Text('${_fmt(startDate)} - ${_fmt(endDate)}', style: info),
              Text(l10n.teamCount(teamCount ?? 0), style: info),
              if (type != null && type!.isNotEmpty)
                Text(type!.toUpperCase(), style: info),
              // 19 จาก 41 serie ไม่มีเงินรางวัล ซ่อนไปเลยดีกว่าโชว์ขีด
              if (prizePool != null && prizePool!.isNotEmpty)
                Text(
                  prizePool!,
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
