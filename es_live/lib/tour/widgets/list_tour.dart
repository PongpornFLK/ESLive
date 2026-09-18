import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/bracket.dart';
import 'package:es_live/tour/group.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTour extends StatelessWidget {
  final String tourId;
  final String tourName;
  final String leagueName;
  final String? leagueLogo;
  final String? startDate;
  final String? endDate;
  final String region;
  final String type;
  final int teamCount;
  final bool hasBracket;
  final String? prizePool;

  const ListTour({
    super.key,
    required this.tourId,
    required this.tourName,
    required this.leagueName,
    required this.leagueLogo,
    required this.startDate,
    required this.endDate,
    required this.region,
    required this.type,
    required this.teamCount,
    required this.hasBracket,
    required this.prizePool,
  });

  /// วันที่จาก backend เป็น null ได้ ต้องกันก่อนแปลง
  String _fmt(String? iso) {
    if (iso == null) return '-';
    return DateFormat('dd/MM/yyyy').format(DateTime.parse(iso).toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final stage = hasBracket ? 'Playoffs' : 'Group Stage';
    final logo = leagueLogo;
    final prize = prizePool;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: Material(
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          hasBracket
                              ? Bracket(tourId: tourId)
                              : GroupStage(tourId: tourId),
                ),
              ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== แถวบน : โลโก้ + ชื่อลีก + สเตจ + ป้ายภูมิภาค =====
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child:
                          logo == null
                              ? Icon(
                                Icons.emoji_events,
                                color: AppColors.gold,
                                size: 28,
                              )
                              : Image.network(
                                logo,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) => Icon(
                                      Icons.emoji_events,
                                      color: AppColors.gold,
                                      size: 28,
                                    ),
                              ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leagueName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            stage,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _Chip(text: region),
                  ],
                ),

                const SizedBox(height: 12),
                Container(height: 1, color: Theme.of(context).dividerColor),
                const SizedBox(height: 10),

                // ===== แถวล่าง : วันที่ + รายละเอียด =====
                _InfoRow(
                  icon: Icons.calendar_today_rounded,
                  text: '${_fmt(startDate)}  -  ${_fmt(endDate)}',
                ),
                const SizedBox(height: 6),
                _InfoRow(
                  icon: Icons.groups_rounded,
                  text: '$teamCount Teams  ·  ${type.toUpperCase()}',
                ),
                if (prize != null) ...[
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.payments_rounded,
                    text: prize,
                    highlight: true,
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

// ===== ป้ายเล็ก ๆ เช่น ASIA / OCE =====

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).cardColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ===== หนึ่งบรรทัดข้อมูล : ไอคอน + ข้อความ =====

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool highlight;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColors.gold : AppColors.grey;

    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color:
                  highlight
                      ? Theme.of(context).colorScheme.onSurface
                      : AppColors.grey,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
