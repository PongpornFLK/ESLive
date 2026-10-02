import 'package:es_live/l10n/app_localizations.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailCard extends StatelessWidget {
  final String gameName;
  final String? logoGame;
  final String? time;
  // final String? summary;
  final String version;
  final String? url;
  final String content;

  const DetailCard({
    super.key,
    required this.gameName,
    required this.logoGame,
    required this.time,
    // required this.summary,
    required this.version,
    required this.url,
    required this.content,
  });

  /// เปิดหน้าต้นฉบับในเบราว์เซอร์ ท่าเดียวกับปุ่ม Stream URL ใน match_header
  Future<void> _openSource(
    BuildContext context,
    String link,
    String error,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;

    try {
      opened = await launchUrl(
        Uri.parse(link),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }

    if (!opened) {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  l10n.patchVersion(version),
                  style: const TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                // ไม่มีลิงก์ = onPressed เป็น null Flutter หรี่สีให้เอง
                onPressed:
                    (url == null || url!.isEmpty)
                        ? null
                        : () => _openSource(context, url!, l10n.cantOpenLink),
                icon: const Icon(Icons.open_in_new_rounded, size: 20),
                color: AppColors.orange,
                tooltip: l10n.viewSource,
                visualDensity: VisualDensity.compact,
              ),
            ],
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
