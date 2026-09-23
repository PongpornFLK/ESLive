import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/homelive/analyze/analyze.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';

/// 1 การ์ด = 1 ทีมที่ติดตาม พร้อมนัดถัดไปของทีมนั้น
class FollowCard extends StatelessWidget {
  final String teamId;
  final String teamName;
  final String? logoUrl;
  final VoidCallback onRemove;
  final MatchData? nextMatch; // null = ทีมนี้No upcoming match

  const FollowCard({
    super.key,
    required this.teamId,
    required this.teamName,
    required this.logoUrl,
    required this.onRemove,
    required this.nextMatch,
  });

  Widget _logo(BuildContext context, String? url, double size) {
    final faded = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.3);

    if (url == null || url.isEmpty) {
      return Icon(Icons.shield_outlined, size: size, color: faded);
    }
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder:
          (_, _, _) => Icon(Icons.shield_outlined, size: size, color: faded),
    );
  }

  /// วันนี้ -> 20:00 / พรุ่งนี้ -> พรุ่งนี้ 20:00 / เกินนั้น -> 26/09 20:00
  String _when(String iso) {
    final t = DateTime.parse(iso).toLocal();
    final now = DateTime.now();
    final days =
        DateTime(
          t.year,
          t.month,
          t.day,
        ).difference(DateTime(now.year, now.month, now.day)).inDays;

    final hm =
        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

    if (days == 0) return hm;
    if (days == 1) return "Tomorrow $hm";
    return "${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')} $hm";
  }

  /// บรรทัดล่างของการ์ด เปลี่ยนตาม 3 สถานะ ไม่มีนัด / กำลังแข่ง / รอแข่ง
  Widget _nextLine(BuildContext context) {
    final m = nextMatch;

    if (m == null) {
      return const Text(
        "No upcoming match",
        style: TextStyle(color: AppColors.grey, fontSize: 12),
      );
    }

    // ทีมที่ติดตามอยู่ฝั่งไหน อีกฝั่งคือคู่แข่ง
    final isA = m.teamA.teamId == teamId;
    final opponent = isA ? m.teamB : m.teamA;
    final isLive = m.status == "live";

    return Row(
      children: [
        if (isLive) ...[const LiveCircle(), const SizedBox(width: 6)],
        Expanded(
          child: Text(
            "vs ${opponent.teamName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          _when(m.beginAt),
          style: TextStyle(
            color: isLive ? AppColors.red : AppColors.grey,
            fontWeight: isLive ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = nextMatch;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        // ไม่มีนัด = กดไม่ได้ onTap เป็น null ทำให้ไม่มี ripple ด้วย
        onTap:
            m == null
                ? null
                : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchAnalyze(match: m),
                  ),
                ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  _logo(context, logoUrl, 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      teamName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.star, color: AppColors.gold),
                    tooltip: "Unfollow",
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _nextLine(context),
            ],
          ),
        ),
      ),
    );
  }
}
