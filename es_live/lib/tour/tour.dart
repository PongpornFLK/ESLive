import 'package:es_live/_service/tour/tour_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/widgets/list_tour.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tour extends ConsumerStatefulWidget {
  const Tour({super.key});

  @override
  ConsumerState<Tour> createState() => _TourState();
}

class _TourState extends ConsumerState<Tour> {
  @override
  Widget build(BuildContext context) {
    final tourAsync = ref.watch(tourProvider);

    return Scaffold(
      backgroundColor: AppColors.secondmain,
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            tourAsync.when(
              data:
                  (data) => Column(
                    children:
                        data
                            .map(
                              (m) => ListTour(
                                tourId: m.tourId,
                                tourName: m.tourName,
                                leagueName: m.leagueName,
                                leagueLogo: m.leagueLogo,
                                startDate: m.startDate,
                                endDate: m.endDate,
                                region: m.region,
                                type: m.type,
                                teamCount: m.teamCount,
                                prizePool: m.prizePool,
                                hasBracket: m.hasBracket,
                              ),
                            )
                            .toList(),
                  ),
              error:
                  (error, stackTrace) => Center(
                    child: Text(
                      "$error",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
