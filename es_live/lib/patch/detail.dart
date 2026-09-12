import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/patch/widget/detail_card.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class PatchDetail extends StatelessWidget {
  final String gameName;
  final String? logoGame;
  final String? time;
  final String? summary;
  final String version;

  const PatchDetail({
    super.key,
    required this.gameName,
    required this.logoGame,
    required this.time,
    required this.summary,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondmain,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        // padding: EdgeInsets.all(10),
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
            DetailCard(
              gameName: gameName,
              logoGame: logoGame,
              time: time,
              summary: summary,
              version: version,
            ),
          ],
        ),
      ),
    );
  }
}
