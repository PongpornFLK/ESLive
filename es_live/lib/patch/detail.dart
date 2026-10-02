import 'package:es_live/_service/patch/patch_pro.dart';
import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/patch/widgets/detail_card.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// หน้าแพตช์โน้ตแบบเต็ม
///
/// รับมาแค่ patchId แล้วไปขอเนื้อเต็มเอง เพราะ GET /patch ไม่ส่ง raw_content มาแล้ว
class PatchDetail extends ConsumerWidget {
  final String patchId;
  final String gameName;
  final String? logoGame;
  final String? time;
  final String version;
  final String? url;

  const PatchDetail({
    super.key,
    required this.patchId,
    required this.gameName,
    required this.logoGame,
    required this.time,
    required this.version,
    required this.url,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patchAsync = ref.watch(patchDetailProvider(patchId));

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

            patchAsync.when(
              data:
                  (patch) => DetailCard(
                    content: patch.content ?? "",
                    gameName: gameName,
                    logoGame: logoGame,
                    time: time,
                    version: version,
                    url: url,
                  ),
              loading:
                  () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              error:
                  (error, stackTrace) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "$error",
                        style: const TextStyle(color: AppColors.red),
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
