import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatGroup extends StatelessWidget {
  final String tourName;
  final String leagueName;
  final String? leagueLogo;
  final String? startDate;
  final String? endDate;
  final String region;
  final String type;
  final int teamCount;
  final String? prizePool;

  const FormatGroup({
    super.key,
    required this.tourName,
    required this.leagueName,
    required this.leagueLogo,
    required this.startDate,
    required this.endDate,
    required this.region,
    required this.type,
    required this.teamCount,
    required this.prizePool,
  });

  @override
  Widget build(BuildContext context) {
    final startTime =
        startDate == null || startDate!.isEmpty
            ? "-"
            : DateFormat(
              'dd/MM/yyyy',
            ).format(DateTime.parse(startDate!).toLocal());
    final endTime =
        endDate == null || endDate!.isEmpty
            ? "-"
            : DateFormat(
              'dd/MM/yyyy',
            ).format(DateTime.parse(endDate!).toLocal());

    return Scaffold(
      backgroundColor: AppColors.secondmain,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leagueName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    tourName,
                    style: TextStyle(color: AppColors.grey, fontSize: 13),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      Text(
                        "$startTime - $endTime",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        "$teamCount Team",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      Text(
                        region,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      if (prizePool != null && prizePool!.isNotEmpty)
                        Text(
                          prizePool!,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Standings",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                "#",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "Team",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "W-L",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Diff",
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
