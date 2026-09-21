import 'package:es_live/core/model/match_data.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/widgets/live_circle.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchHeader extends StatelessWidget {
  final MatchData match;
  const MatchHeader({super.key, required this.match});

  /// Logo Team
  Widget _logo(BuildContext context, String? url, double size) {
    final faded = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.3);

    if (url == null || url.isEmpty) {
      return Icon(Icons.shield_outlined, size: size, color: faded);
    }
    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder:
          (_, _, _) => Icon(Icons.shield_outlined, size: size, color: faded),
    );
  }

  Widget _team(BuildContext context, String? logo, String name) {
    return Column(
      children: [
        _logo(context, logo, 64),
        const SizedBox(height: 8),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  /// เปิด Live ของ app นั้น
  Future<void> _openStream(BuildContext context, String url) async {
    final messenger = ScaffoldMessenger.of(context);
    var opened = false;

    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {
      opened = false;
    }

    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text("เปิดลิงก์ถ่ายทอดไม่ได้")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    final isLive = match.status == "live";
    final streamUrl = match.streamUrl; // แมตช์ที่ยังไม่เริ่มจะดัก null ไว้

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                match.game.gameName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            if (isLive) const LiveCircle(),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                match.tournament.leagueName ?? match.tournament.tourName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _team(context, match.teamA.logoUrl, match.teamA.teamName),
            ),
            Column(
              children: [
                Text(
                  "${match.scoreA}  -  ${match.scoreB}",
                  style: TextStyle(
                    color: onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),

                const SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.grey.withValues(
                      alpha: 0.3,
                    ),
                    disabledForegroundColor: AppColors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  // onPressed เป็น null = ปุ่มกดไม่ได้ Flutter หรี่สีให้เอง
                  onPressed:
                      streamUrl == null || streamUrl.isEmpty
                          ? null
                          : () => _openStream(context, streamUrl),
                  label: const Text(
                    "Stream URL",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _team(context, match.teamB.logoUrl, match.teamB.teamName),
            ),
          ],
        ),
      ],
    );
  }
}
