import 'package:es_live/_service/tour/group.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/widgets/table_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ตารางคะแนน
class GroupStage extends ConsumerWidget {
  final String tourId;

  const GroupStage({super.key, required this.tourId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupProvider(tourId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: groupAsync.when(
        data: (data) => TableGroup(rows: data),
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
      ),
    );
  }
}
