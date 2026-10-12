import 'package:es_live/core/model/tour_data.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/tour/bracket.dart';
import 'package:es_live/tour/group.dart';
import 'package:es_live/tour/widgets/format.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// หน้ารายละเอียด(serie)
class TourDetail extends ConsumerWidget {
  final SerieData serie;

  const TourDetail({super.key, required this.serie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    Widget notice(String text) => Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.grey, fontSize: 13),
        ),
      ),
    );

    Widget heading(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        text,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );

    // ใส่หัวข้อถ้า่มีมากกว่าหนึ่งสเตจ
    Widget matches(
      List<TournamentData> stages,
      String emptyText, {
      String? lastSection,
    }) {
      if (stages.isEmpty) return notice(emptyText);

      return ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          for (final s in stages) ...[
            if (stages.length > 1) heading(s.tourName),
            Bracket(tourId: s.tourId, lastSection: lastSection),
          ],
        ],
      );
    }

    return DefaultTabController(
      length: 2,
      initialIndex: serie.playoffStages.isEmpty ? 1 : 0,
      child: Scaffold(
        appBar: CustomAppBar(),
        body: NestedScrollView(
          headerSliverBuilder:
              (context, _) => [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),

                      Format(
                        tourName: serie.serieName,
                        leagueName: serie.leagueName,
                        startDate: serie.beginAt,
                        endDate: serie.endAt,
                        type: serie.type,
                        teamCount: serie.teamCount,
                        prizePool: serie.prizePool,
                      ),

                      // ตารางคะแนน
                      for (final g in serie.groupStages) ...[
                        heading(g.tourName),
                        GroupStage(tourId: g.tourId),
                      ],

                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedTabBar(
                    background: theme.scaffoldBackgroundColor,
                    child: _TabSwitch(
                      first: l10n.tabPlayoff,
                      second: l10n.tabGroup,
                    ),
                  ),
                ),
              ],
          body: TabBarView(
            children: [
              matches(serie.playoffStages, l10n.noPlayoffStage),
              matches(
                serie.groupStages,
                l10n.noGroupStage,
                lastSection: l10n.sectionQualify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ตัวห่อให้แถบแท็บติดอยู่บนสุดได้
class _PinnedTabBar extends SliverPersistentHeaderDelegate {
  final Widget child;
  final Color background;

  const _PinnedTabBar({required this.child, required this.background});

  /// สวิตช์สูง 54 (ขอบใน 4 + Tab 46) บวกระยะห่างบนล่างอีก 16
  static const double _height = 70;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    // ต้องมีพื้นหลังทึบ ไม่งั้นเนื้อหาที่เลื่อนผ่านจะทะลุขึ้นมาซ้อนแถบแท็บ
    return Container(
      color: background,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_PinnedTabBar old) =>
      old.child != child || old.background != background;
}

/// สวิตช์สองช่องทรงแคปซูล ช่องที่เลือกเป็นแคปซูลสีส้ม
class _TabSwitch extends StatelessWidget {
  final String first;
  final String second;

  const _TabSwitch({required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: TabBar(
          isScrollable: false,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: AppColors.grey,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: [Tab(text: first), Tab(text: second)],
        ),
      ),
    );
  }
}
