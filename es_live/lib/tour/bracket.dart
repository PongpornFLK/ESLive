import 'package:es_live/_service/tour/bracket.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/widgets/line_bracket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// รายการแมตช์ของสเตจหนึ่งอัน
class Bracket extends ConsumerWidget {
  final String tourId;
  final String? lastSection;

  const Bracket({super.key, required this.tourId, this.lastSection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bracketAsync = ref.watch(bracketProvider(tourId));

    return bracketAsync.when(
      data:
          (data) =>
              lastSection == null
                  ? BracketBoard(matches: data)
                  : BracketBoard(matches: data, lastSection: lastSection!),
      error:
          (error, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                '$error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.red, fontSize: 13),
              ),
            ),
          ),
      loading:
          () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
