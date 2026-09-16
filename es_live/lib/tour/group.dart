import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class GroupStage extends StatefulWidget {
  const GroupStage({super.key});

  @override
  State<GroupStage> createState() => _GroupStageState();
}

class _GroupStageState extends State<GroupStage> {
  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Text("Group Stage", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
