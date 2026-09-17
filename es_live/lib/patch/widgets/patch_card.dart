import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/patch/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatchCard extends StatelessWidget {
  final String gameName;
  final String? logoGame;
  final String? time;
  final String? summary;
  final String version;
  final String content;
  final String? url;

  const PatchCard({
    super.key,
    required this.gameName,
    required this.logoGame,
    required this.time,
    required this.summary,
    required this.version,
    required this.content,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final t = time;
    final patchTime =
        t == null
            ? "--/--/--"
            : DateFormat(
              'HH.mm - dd/MM/yyyy',
            ).format(DateTime.parse(t).toLocal());

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
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
                  Text(gameName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                ],
              ),
              Text(patchTime, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Patch $version",
            style: TextStyle(
              color: AppColors.orange,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$summary",
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            style: const TextStyle(height: 1.4),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PatchDetail(
                            gameName: gameName,
                            logoGame: logoGame,
                            version: version,
                            time: patchTime,
                            content: content,
                            url: url,
                          ),
                    ),
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View All",
                    style: TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
