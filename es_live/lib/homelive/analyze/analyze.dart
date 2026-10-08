import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/_service/homelive/history_pro.dart';
import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/homelive/analyze/widgets/analysis_box.dart';
import 'package:es_live/homelive/analyze/widgets/history_match.dart';
import 'package:es_live/homelive/analyze/widgets/match_header.dart';
import 'package:es_live/homelive/analyze/widgets/winrate.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchAnalyze extends ConsumerStatefulWidget {
  final MatchData match;

  const MatchAnalyze({super.key, required this.match});

  @override
  ConsumerState<MatchAnalyze> createState() => _MatchAnalyzeState();
}

class _MatchAnalyzeState extends ConsumerState<MatchAnalyze> {
  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyProvider(widget.match.id));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
              child: Column(
                children: [
                  MatchHeader(match: widget.match),
                  SizedBox(height: 15),
                  Winrate(
                    winRateA: widget.match.matchAnalyze?.winRateA ?? 0,
                    winRateB: widget.match.matchAnalyze?.winRateB ?? 0,
                    logoTeamAUrl: widget.match.teamA.logoUrl ?? "",
                    logoTeamBUrl: widget.match.teamB.logoUrl ?? "",
                  ),
                  SizedBox(height: 15),
                  AnalysisBox(
                    // Localizations.localeOf อ่านภาษาจาก MaterialApp
                    reason: widget.match.matchAnalyze?.reasonFor(
                      Localizations.localeOf(context).languageCode,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    l10n.latestMatches(5),
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  historyAsync.when(
                    data:
                        (history) => LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth >= 600;

                            if (wide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: HistoryMatch(
                                      teamName: widget.match.teamA.teamName,
                                      rows: history.formA,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: HistoryMatch(
                                      teamName: widget.match.teamB.teamName,
                                      rows: history.formB,
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                HistoryMatch(
                                  teamName: widget.match.teamA.teamName,
                                  rows: history.formA,
                                ),
                                SizedBox(height: 10),
                                HistoryMatch(
                                  teamName: widget.match.teamB.teamName,
                                  rows: history.formB,
                                ),
                              ],
                            );
                          },
                        ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => Text("$error"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
