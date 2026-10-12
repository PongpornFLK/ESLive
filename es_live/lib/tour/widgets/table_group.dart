import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/core/model/group.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

// ความกว้างของคอลัมน์ตัวเลข ประกาศไว้ที่เดียวเพื่อให้หัวตารางกับแถวข้อมูลตรงกัน
const double _kRankWidth = 26;
const double _kLogoSize = 22;
const double _kWinLossWidth = 46;
const double _kGamesWidth = 54;

/// ตารางคะแนนของรอบแบ่งกลุ่ม
class TableGroup extends StatelessWidget {
  final List<GroupData> rows;

  const TableGroup({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (rows.isEmpty) {
      return _Note(l10n.noStandingYet);
    }

    final hasStats = rows.any((r) => r.win != null || r.loss != null);
    final divider = Divider(
      height: 16,
      thickness: 1,
      color: Theme.of(context).dividerColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              if (hasStats) ...[const _HeaderRow(), divider],
              for (int i = 0; i < rows.length; i++) ...[
                _TeamRow(data: rows[i], hasStats: hasStats),
                if (i != rows.length - 1) divider,
              ],
            ],
          ),
        ),
        if (!hasStats) ...[
          const SizedBox(height: 8),
          Text(
            l10n.rankOnlyNoStats,
            style: TextStyle(color: AppColors.grey, fontSize: 11),
          ),
        ],
      ],
    );
  }
}

// ===== หัวตาราง =====

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: AppColors.grey,
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );

    return Row(
      children: [
        SizedBox(width: _kRankWidth, child: Text('#', style: style)),
        Expanded(child: Text('TEAM', style: style)),
        SizedBox(
          width: _kWinLossWidth,
          child: Text('W-L', style: style, textAlign: TextAlign.center),
        ),
        SizedBox(
          width: _kGamesWidth,
          child: Text('GAMES', style: style, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

// ===== หนึ่งแถว = หนึ่งทีม =====

class _TeamRow extends StatelessWidget {
  final GroupData data;
  final bool hasStats;

  const _TeamRow({required this.data, required this.hasStats});

  /// แพ้ชนะระดับแมตช์ เช่น "2-0"
  String get _winLoss {
    if (data.win == null && data.loss == null) return '-';
    return '${data.win ?? '-'}-${data.loss ?? '-'}';
  }

  /// แพ้ชนะระดับเกมย่อย เช่น "4-1" หรือ "4-1-2" ถ้ามีเสมอ
  String get _games {
    if (data.gameWin == null && data.gameLoss == null) return '-';
    final base = '${data.gameWin ?? 0}-${data.gameLoss ?? 0}';
    final ties = data.gameTie ?? 0;
    return ties > 0 ? '$base-$ties' : base;
  }

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isLeader = data.rank == 1;

    return Row(
      children: [
        SizedBox(
          width: _kRankWidth,
          child: Text(
            '${data.rank}',
            style: TextStyle(
              color: isLeader ? AppColors.gold : AppColors.grey,
              fontSize: 13,
              fontWeight: isLeader ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
        ),
        _TeamLogo(url: data.teamLogo),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            data.teamName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: onSurface,
              fontSize: 13,
              fontWeight: isLeader ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        if (hasStats) ...[
          SizedBox(
            width: _kWinLossWidth,
            child: Text(
              _winLoss,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: _kGamesWidth,
            child: Text(
              _games,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }
}

// ===== โลโก้ทีม =====

class _TeamLogo extends StatelessWidget {
  final String? url;

  const _TeamLogo({required this.url});

  @override
  Widget build(BuildContext context) {
    // โล่จาง ๆ ใช้ทั้งตอนไม่มีลิงก์ และตอนโหลดรูปไม่สำเร็จ
    final fallback = Icon(
      Icons.shield_outlined,
      size: _kLogoSize - 2,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
    );

    return SizedBox(
      width: _kLogoSize,
      height: _kLogoSize,
      child:
          (url == null || url!.isEmpty)
              ? fallback
              : Image.network(
                url!,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => fallback,
              ),
    );
  }
}

// ===== กล่องข้อความตอนไม่มีข้อมูล =====

class _Note extends StatelessWidget {
  final String text;

  const _Note(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: AppColors.grey, fontSize: 13),
        ),
      ),
    );
  }
}
