import 'package:es_live/_service/tour/tour_pro.dart';
import 'package:es_live/tour/widgets/list_tour.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tour extends ConsumerStatefulWidget {
  final String slug;

  const Tour({super.key, required this.slug});

  @override
  ConsumerState<Tour> createState() => _TourState();
}

class _TourState extends ConsumerState<Tour> {
  @override
  Widget build(BuildContext context) {
    final tourAsync = ref.watch(tourProviderGameId(widget.slug));

    return Scaffold(
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
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            tourAsync.when(
              data:
                  (data) => Column(
                    children: data.map((m) => ListTour(serie: m)).toList(),
                  ),
              error:
                  (error, stackTrace) => Center(
                    child: Text(
                      "$error",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
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
