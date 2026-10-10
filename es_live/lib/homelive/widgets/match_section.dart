import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/core/media/text_scale.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/homelive/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// เอาเฉพาะ status ยิง API ครั้งเดียว เพราะ FutureProvider เก็บผลแล้ว
class MatchSection extends ConsumerWidget {
  const MatchSection({
    super.key,
    required this.status,
    required this.emptyText,
  });

  final String status;
  final String emptyText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchProvider);

    return matchAsync.when(
      data: (matches) {
        final list =
            matches
                .where(
                  (m) =>
                      m.status == status ||
                      (status == "upcoming" && m.status == "canceled"),
                )
                .toList();

        // เช็คว่างได้ตรงนี้ที่เดียว ก่อนข้อมูลมาถึงยังไม่มีทางรู้ว่ามีกี่นัด
        if (list.isEmpty) return _notice(Text(emptyText, style: _greyText));

        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 450,
            mainAxisExtent: scaledHeight(context, 145),
            crossAxisSpacing: 10,
          ),
          children:
              list
                  .map(
                    (m) => MatchCard(
                      gameName: m.game.gameName,
                      leagueName:
                          m.tournament.leagueName ?? m.tournament.tourName,
                      teamAName: m.teamA.teamName,
                      teamBName: m.teamB.teamName,
                      scoreA: m.scoreA,
                      scoreB: m.scoreB,
                      isLive: m.status,
                      time: m.beginAt,
                      logoTeamA: m.teamA.logoUrl,
                      logoTeamB: m.teamB.logoUrl,
                      match: m,
                    ),
                  )
                  .toList(),
        );
      },
      loading: () => _notice(const CircularProgressIndicator()),
      error: (error, stackTrace) => _notice(Text('$error', style: _greyText)),
    );
  }

  /// Box Null / Loading / Err
  Widget _notice(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Center(child: child),
  );

  static const _greyText = TextStyle(color: AppColors.grey);
}
