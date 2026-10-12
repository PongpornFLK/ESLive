import 'package:badges/badges.dart' as badges;
import 'package:es_live/core/model/tour_data.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/tour_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTour extends StatelessWidget {
  final SerieData serie;

  const ListTour({super.key, required this.serie});

  /// Check date null
  String _fmt(String? iso) {
    if (iso == null) return '-';
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(iso).toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final logo = serie.leagueLogoUrl;

    // Check Logo
    final fallbackLogo = Icon(
      Icons.emoji_events,
      color: AppColors.gold,
      size: 28,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: Material(
        color: theme.cardColor,
        child: InkWell(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TourDetail(serie: serie),
                ),
              ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Head Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child:
                          logo == null
                              ? fallbackLogo
                              : Image.network(
                                logo,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => fallbackLogo,
                              ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serie.leagueName ?? '-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            serie.serieName ?? '-',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Badge
                    badges.Badge(
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.square,
                        borderRadius: BorderRadius.circular(20),
                        badgeColor: theme.colorScheme.onSurface,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                      ),
                      badgeContent: Text(
                        serie.region ?? '-',
                        style: TextStyle(
                          color: theme.cardColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Container(height: 1, color: theme.dividerColor),
                const SizedBox(height: 10),

                // Bottom Info
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_fmt(serie.beginAt)}  -  ${_fmt(serie.endAt)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.groups_rounded,
                      size: 14,
                      color: AppColors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.teamCount(serie.teamCount ?? 0),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),

                // 19 จาก 41 serie ไม่มีเงินรางวัล ซ่อนทั้งแถวดีกว่าโชว์ขีด
                if (serie.prizePool != null && serie.prizePool!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.payments_rounded,
                        size: 14,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          serie.prizePool!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
