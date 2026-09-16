import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatBracket extends StatelessWidget {
  final String tourName;
  final String leagueName;
  final String? leagueLogo;
  final String? startDate;
  final String? endDate;
  final String region;
  final String type;
  final int teamCount;
  final String? prizePool;

  const FormatBracket({
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
        startDate == null
            ? "-"
            : DateFormat(
              'dd/MM/yyyy',
            ).format(DateTime.parse(startDate!).toLocal());
    final endTime =
        endDate == null
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
                      if (prizePool != null)
                        Text(
                          prizePool!,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Bracket",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BracketRound
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _BracketRound extends StatelessWidget {
  final String label;
  final List<Map<String, dynamic>> matches;

  const _BracketRound({required this.label, required this.matches});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(label, style: TextStyle(color: AppColors.grey, fontSize: 11)),
        SizedBox(height: 8),
        ...matches.map(
          (m) => Container(
            width: 130,
            margin: EdgeInsets.symmetric(vertical: 6),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${m["teamA"]}", style: TextStyle(fontSize: 12)),
                    Text(
                      "${m["scoreA"] ?? "-"}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${m["teamB"]}", style: TextStyle(fontSize: 12)),
                    Text(
                      "${m["scoreB"] ?? "-"}",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
