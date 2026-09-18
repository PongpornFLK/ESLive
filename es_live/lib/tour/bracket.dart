import 'package:es_live/_service/tour/bracket.dart';
import 'package:es_live/_service/tour/tour_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/widgets/format_bracket.dart';
import 'package:es_live/tour/widgets/line_bracket.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Bracket extends ConsumerStatefulWidget {
  final String tourId;
  const Bracket({super.key, required this.tourId});

  @override
  ConsumerState<Bracket> createState() => _BracketState();
}

class _BracketState extends ConsumerState<Bracket> {
  @override
  Widget build(BuildContext context) {
    final bracketAsync = ref.watch(bracketProvider(widget.tourId));
    final tourAsync = ref.watch(tourProvider);

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            tourAsync.when(
              data:
                  (data) => Column(
                    children:
                        data
                            .where((m) => m.tourId == widget.tourId)
                            .map(
                              (m) => FormatBracket(
                                startDate: m.startDate,
                                endDate: m.endDate,
                                leagueName: m.leagueName,
                                prizePool: m.prizePool,
                                teamCount: m.teamCount,
                                region: m.region,
                                tourName: m.tourName,
                                type: m.type,
                              ),
                            )
                            .toList(),
                  ),
              error:
                  (error, stackTrace) => Center(
                    child: Text(
                      "$error",
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 12),
            bracketAsync.when(
              data: (data) => BracketBoard(matches: data),
              error:
                  (error, stackTrace) => Center(
                    child: Text(
                      "$error",
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
              loading: () => Center(child: CircularProgressIndicator()),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
