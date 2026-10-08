import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/homelive/widgets/list_game.dart';
import 'package:es_live/homelive/widgets/match_section.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/model/game_data.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(matchProvider);
        await ref.read(matchProvider.future);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
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
              MatchSection(status: "live", emptyText: l10n.noLiveNow),
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
              MatchSection(status: "upcoming", emptyText: l10n.noUpcomingMatch),
            ],
          ),
        ),
      ),
    );
  }
}
