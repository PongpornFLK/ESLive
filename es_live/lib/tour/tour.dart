import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/tour/widgets/list_tour.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class Tour extends StatelessWidget {
  const Tour({super.key});

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
            
            ListTour(tourName: ""),
          ],
        ),
      ),
    );
  }
}
