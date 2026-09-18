import 'package:es_live/_service/tour/group.dart';
import 'package:es_live/_service/tour/tour_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/widgets/format_group.dart';
import 'package:es_live/tour/widgets/table_group.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// หน้ารอบแบ่งกลุ่มของทัวร์หนึ่งรายการ
///
/// ใช้ ConsumerWidget ไม่ใช่ ConsumerStatefulWidget เพราะไม่มีสถานะที่เปลี่ยนเอง
/// ข้อมูลทั้งหมดมาจาก ref.watch ซึ่ง Riverpod จัดการให้แล้ว
class GroupStage extends ConsumerWidget {
  final String tourId;

  const GroupStage({super.key, required this.tourId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tourAsync = ref.watch(tourProvider);
    final groupAsync = ref.watch(groupProvider(tourId));

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== ส่วนหัว : ข้อมูลทัวร์ =====
            tourAsync.when(
              data:
                  (data) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        data
                            .where((m) => m.tourId == tourId)
                            .map(
                              (m) => FormatGroup(
                                tourName: m.tourName,
                                leagueName: m.leagueName,
                                leagueLogo: m.leagueLogo,
                                startDate: m.startDate,
                                endDate: m.endDate,
                                region: m.region,
                                type: m.type,
                                teamCount: m.teamCount,
                                prizePool: m.prizePool,
                              ),
                            )
                            .toList(),
                  ),
              error: (error, _) => _Message('$error', isError: true),
              loading: () => const _Loading(),
            ),

            // ===== ตารางคะแนน =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: groupAsync.when(
                data: (data) => TableGroup(rows: data),
                error: (error, _) => _Message('$error', isError: true),
                loading: () => const _Loading(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _Message extends StatelessWidget {
  final String text;
  final bool isError;

  const _Message(this.text, {this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isError ? AppColors.red : AppColors.grey,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
