import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String gameName;
  final String? logoGame;
  final String? time;
  // final String? summary;
  final String version;
  final String content;
  final String? url;

  const DetailCard({
    super.key,
    required this.gameName,
    required this.logoGame,
    required this.time,
    // required this.summary,
    required this.version,
    required this.content,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.asset(
                      "$logoGame",
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.videogame_asset,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    gameName,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                "$time",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.patchVersion(version),
            style: TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          MarkdownBody(
            data: content,
            styleSheet: MarkdownStyleSheet.fromTheme(
              Theme.of(context),
            ).copyWith(
              h1: Theme.of(context).textTheme.headlineMedium,
              code: const TextStyle(
                fontFamily: 'monospace',
                backgroundColor: Color(0x11000000),
              ),
              blockquotePadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
