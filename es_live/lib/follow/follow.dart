import 'package:es_live/core/media/text_scale.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/_service/follow/follow_pro.dart';
import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/follow/widgets/follow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Follow extends ConsumerStatefulWidget {
  const Follow({super.key});

  @override
  ConsumerState<Follow> createState() => _FollowState();
}

class _FollowState extends ConsumerState<Follow> {
  /// นัดถัดไปของทีมนี้ ไม่มี -> null
  /// ตัดนัดที่เวลาผ่านไปแล้วทิ้ง เพราะบางแมตช์ PandaScore ไม่อัปเดตสถานะ
  /// ยังค้างเป็น upcoming ทั้งที่แข่งจบไปนานแล้ว
  MatchData? _nextMatch(String teamId, List<MatchData> matches) {
    final now = DateTime.now();

    final mine =
        matches.where((m) {
          if (m.teamA.teamId != teamId && m.teamB.teamId != teamId) {
            return false;
          }
          if (m.status == "live") return true;
          return DateTime.parse(m.beginAt).toLocal().isAfter(now);
        }).toList();

    if (mine.isEmpty) return null;

    mine.sort(
      (a, b) => DateTime.parse(a.beginAt).compareTo(DateTime.parse(b.beginAt)),
    );
    return mine.first;
  }

  /// กล่องกลางจอสำหรับข้อความสั้น ๆ ใช้ร่วมกันทั้ง ว่าง / กำลังโหลด / error
  Widget _notice(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 30),
    child: Center(child: child),
  );

  @override
  Widget build(BuildContext context) {
    // เก็บทั้งก้อนไว้ ไม่ดึง .value ออกมาเลย จะได้แยก loading กับ ว่าง ออกจากกันได้
    final followAsync = ref.watch(followProvider);
    final matchAsync = ref.watch(matchProvider);
    final l10n = AppLocalizations.of(context);

    // ยังโหลดแมตช์ไม่เสร็จก็แสดงรายชื่อทีมไปก่อน บรรทัดนัดหน้าค่อยเติมทีหลัง
    final matches = matchAsync.value ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.following,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),

          if (matchAsync.isLoading) const LinearProgressIndicator(),
          if (matchAsync.hasError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                l10n.cantLoadSchedule,
                style: const TextStyle(color: AppColors.red, fontSize: 12),
              ),
            ),

          followAsync.when(
            data: (follows) {
              // ทีมที่มีนัดใกล้สุดอยู่บน ทีมที่ไม่มีนัดตกไปท้ายสุด
              final sorted = [...follows];
              sorted.sort((a, b) {
                final na = _nextMatch(a.teamId, matches);
                final nb = _nextMatch(b.teamId, matches);

                if (na == null && nb == null) return 0;
                if (na == null) return 1;
                if (nb == null) return -1;

                return DateTime.parse(
                  na.beginAt,
                ).compareTo(DateTime.parse(nb.beginAt));
              });

              if (sorted.isEmpty) {
                return _notice(
                  Text(
                    l10n.notFollowingYet,
                    style: const TextStyle(color: AppColors.grey),
                  ),
                );
              }

              return GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 450,
                  mainAxisExtent: scaledHeight(context, 115),
                  crossAxisSpacing: 10,
                ),
                children:
                    sorted
                        .map(
                          (f) => FollowCard(
                            teamId: f.teamId,
                            teamName: f.teamName,
                            logoUrl: f.logoUrl,
                            nextMatch: _nextMatch(f.teamId, matches),
                            onRemove:
                                () => ref
                                    .read(followProvider.notifier)
                                    .untoggle(f.teamId),
                          ),
                        )
                        .toList(),
              );
            },
            loading: () => _notice(const CircularProgressIndicator()),
            error:
                (error, stackTrace) => _notice(
                  Text(
                    l10n.somethingWrong,
                    style: const TextStyle(color: AppColors.red),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
