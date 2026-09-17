import 'package:es_live/core/model/bracket_data.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ===== ตัวช่วยจัดกลุ่ม =====

const _sectionOrder = ['UPPER BRACKET', 'LOWER BRACKET', 'GRAND FINAL'];

/// ชื่อแมตช์บอกสายอยู่แล้ว เช่น "Upper Bracket Final: TBD vs TBD"
String _sectionOf(String name) {
  final n = name.toLowerCase();
  if (n.startsWith('upper bracket')) return 'UPPER BRACKET';
  if (n.startsWith('lower bracket')) return 'LOWER BRACKET';
  return 'GRAND FINAL';
}

/// ตัดชื่อทีมและเลขลำดับออก เหลือแค่ชื่อรอบ
/// "Upper Bracket Quarterfinal 1: A vs B"  -> "Upper Bracket Quarterfinal"
/// "Lower Bracket Round 1 match 2: A vs B" -> "Lower Bracket Round 1"
String _roundOf(String name) {
  var head = name.split(':').first.trim();
  final matchN = RegExp(r'\s+match\s+\d+$', caseSensitive: false);
  if (matchN.hasMatch(head)) {
    head = head.replaceAll(matchN, '');
  } else {
    head = head.replaceAll(RegExp(r'\s+\d+$'), '');
  }
  return head;
}

/// ลำดับของรอบในสายเดียวกัน
int _roundRank(String round) {
  final r = round.toLowerCase();
  if (r.contains('round 1')) return 1;
  if (r.contains('quarterfinal')) return 2;
  if (r.contains('semifinal')) return 3;
  if (r.contains('final')) return 4;
  return 5;
}

/// ป้ายหัวคอลัมน์ ไม่ต้ต้องำชื่อสายเพราะมีหัวข้อใหญ่อยู่แล้ว
String _shortRound(String round) =>
    round
        .replaceAll(
          RegExp(r'^(upper|lower)\s+bracket\s*', caseSensitive: false),
          '',
        )
        .trim();

Map<String, List<BracketData>> _groupBy(
  List<BracketData> list,
  String Function(String) keyOf,
  List<String> Function(Iterable<String>) sortKeys,
) {
  final bucket = <String, List<BracketData>>{};
  for (final m in list) {
    bucket.putIfAbsent(keyOf(m.name), () => []).add(m);
  }
  return {for (final k in sortKeys(bucket.keys)) k: bucket[k]!};
}

// ===== ผังทั้งหมด =====

class BracketBoard extends StatelessWidget {
  final List<BracketData> matches;

  const BracketBoard({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    final sections = _groupBy(
      matches,
      _sectionOf,
      (keys) => _sectionOrder.where(keys.contains).toList(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          sections.entries.map((section) {
            final rounds = _groupBy(
              section.value,
              _roundOf,
              (keys) =>
                  keys.toList()
                    ..sort((a, b) => _roundRank(a).compareTo(_roundRank(b))),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Text(
                    section.key,
                    style: TextStyle(
                      color: AppColors.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        rounds.entries
                            .map(
                              (r) =>
                                  _RoundColumn(label: r.key, matches: r.value),
                            )
                            .toList(),
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}

// ===== หนึ่งคอลัมน์ = หนึ่งรอบ =====

class _RoundColumn extends StatelessWidget {
  final String label;
  final List<BracketData> matches;

  const _RoundColumn({required this.label, required this.matches});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(
              _shortRound(label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          ...matches.map((m) => _MatchCard(match: m)),
        ],
      ),
    );
  }
}

// ===== การ์ดแมตช์เดียว =====

class _MatchCard extends StatelessWidget {
  final BracketData match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    final isDone = match.status == 'finished';
    final t = match.beginAt;
    final time =
        t == null
            ? '-'
            : DateFormat('dd/MM HH:mm').format(DateTime.parse(t).toLocal());
    final winner = match.winnerTeam;

    return Container(
      width: 170,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TeamRow(
            name: match.teamA,
            score: match.scoreA,
            isWinner: winner != null && winner == match.teamA,
            showScore: isDone,
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 7),
            color: Colors.black12,
          ),
          _TeamRow(
            name: match.teamB,
            score: match.scoreB,
            isWinner: winner != null && winner == match.teamB,
            showScore: isDone,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BO${match.bestGame}',
                style: TextStyle(fontSize: 10, color: AppColors.grey),
              ),
              Text(
                isDone ? 'Finished' : time,
                style: TextStyle(fontSize: 10, color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===== หนึ่งแถว = หนึ่งทีม =====

class _TeamRow extends StatelessWidget {
  final String? name;
  final int score;
  final bool isWinner;
  final bool showScore;

  const _TeamRow({
    required this.name,
    required this.score,
    required this.isWinner,
    required this.showScore,
  });

  @override
  Widget build(BuildContext context) {
    final isTbd = name == null;

    return Row(
      children: [
        Expanded(
          child: Text(
            name ?? 'TBD',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: isTbd ? AppColors.grey : AppColors.main,
              fontWeight: isWinner ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          showScore ? '$score' : '-',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isWinner ? AppColors.orange : AppColors.grey,
          ),
        ),
      ],
    );
  }
}
