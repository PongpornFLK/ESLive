import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/homelive/widgets/list_game.dart';
import 'package:es_live/homelive/widgets/match_card.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/model/game_data.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  bool isHaveLive = true;
  bool isHaveComingSoon = true;

  @override
  Widget build(BuildContext context) {
    final matchAsync = ref.watch(matchProvider);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  l10n.game,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children:
                  data
                      .map((g) => ListGame(logo: g.logo, gameName: g.name))
                      .toList(),
            ),
            Divider(),
            Row(
              children: [
                Text(
                  l10n.match,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n.live,
                  style: TextStyle(
                    color: AppColors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                LiveCircle(),
              ],
            ),
            isHaveLive
                ? matchAsync.when(
                  data:
                      (match) => Column(
                        children:
                            match
                                .where((m) => m.status == "live")
                                .map(
                                  (m) => MatchCard(
                                    gameName: m.game.gameName,
                                    leagueName:
                                        m.tournament.leagueName ??
                                        m.tournament.tourName,
                                    teamAName: m.teamA.teamName,
                                    teamBName: m.teamB.teamName,
                                    scoreA: m.scoreA,
                                    scoreB: m.scoreB,
                                    isLive: true,
                                    time: m.beginAt,
                                    logoTeamA: m.teamA.logoUrl,
                                    logoTeamB: m.teamB.logoUrl,
                                    match: m,
                                  ),
                                )
                                .toList(),
                      ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) => Text('$error'),
                )
                : Center(
                  child: Text(
                    l10n.notFound,
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
            Divider(),
            Row(
              children: [
                Text(
                  l10n.comingSoon,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            isHaveComingSoon
                ? matchAsync.when(
                  data:
                      (match) => Column(
                        children:
                            match
                                .where((m) => m.status == "upcoming")
                                .map(
                                  (m) => MatchCard(
                                    gameName: m.game.gameName,
                                    leagueName:
                                        m.tournament.leagueName ??
                                        m.tournament.tourName,
                                    teamAName: m.teamA.teamName,
                                    teamBName: m.teamB.teamName,
                                    scoreA: m.scoreA,
                                    scoreB: m.scoreB,
                                    isLive: false,
                                    time: m.beginAt,
                                    logoTeamA: m.teamA.logoUrl,
                                    logoTeamB: m.teamB.logoUrl,
                                    match: m,
                                  ),
                                )
                                .toList(),
                      ),
                  error: (error, stackTrace) => Text("$error"),
                  loading: () => CircularProgressIndicator(),
                )
                : Center(
                  child: Text(
                    l10n.notFound,
                    style: TextStyle(color: AppColors.grey),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
