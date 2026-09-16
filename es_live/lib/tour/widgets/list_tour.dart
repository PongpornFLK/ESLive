import 'package:es_live/tour/bracket.dart';
import 'package:es_live/tour/group.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTour extends StatelessWidget {
  final String tourName;
  final String leagueName;
  final String? leagueLogo;
  final String? startDate;
  final String? endDate;
  final String region;
  final String type;
  final int teamCount;
  final bool hasBracket;
  final String? prizePool;

  const ListTour({
    super.key,
    required this.tourName,
    required this.leagueName,
    required this.leagueLogo,
    required this.startDate,
    required this.endDate,
    required this.region,
    required this.type,
    required this.teamCount,
    required this.hasBracket,
    required this.prizePool,
  });

  @override
  Widget build(BuildContext context) {
    final startTime = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.parse("$startDate").toLocal());

    final endTime = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.parse("$endDate").toLocal());

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 150,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${type.toUpperCase()} - $teamCount Team"),
                    Text("$startTime - $endTime"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(leagueName, style: TextStyle(fontSize: 32))],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(!hasBracket ? "Group Stage" : "Playoffs")],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(region)],
                ),
              ],
            ),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => !hasBracket ? GroupStage() : Bracket(),
                  ),
                ),
          ),
        ),
      ],
    );
  }
}
