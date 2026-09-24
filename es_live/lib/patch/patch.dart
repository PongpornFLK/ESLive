import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/_service/patch/patch_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/patch/widgets/patch_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Patch extends ConsumerStatefulWidget {
  const Patch({super.key});

  @override
  ConsumerState<Patch> createState() => _PatchState();
}

class _PatchState extends ConsumerState<Patch> {
  bool isHavePatch = true;

  @override
  Widget build(BuildContext context) {
    final patchAsync = ref.watch(patchProvider);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          isHavePatch
              ? patchAsync.when(
                data:
                    (data) => Column(
                      children:
                          data
                              .map(
                                (g) => PatchCard(
                                  gameName: g.game.gameName,
                                  logoGame:
                                      g.game.gameName == "Valorant"
                                          ? "assests/img/list_game/valorant.png"
                                          : "assests/img/error/err.png",
                                  time: g.time ?? "-",
                                  summary: g.summary,
                                  version: g.version,
                                  content: g.content,
                                  url: g.url,
                                ),
                              )
                              .toList(),
                    ),
                error:
                    (error, stackTrace) =>
                        Text("$error", style: TextStyle(color: AppColors.red)),
                loading: () => Center(child: CircularProgressIndicator()),
              )
              : Text(l10n.notFound),
        ],
      ),
    );
  }
}
