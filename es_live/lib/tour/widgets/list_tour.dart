import 'package:es_live/tour/format.dart';
import 'package:flutter/material.dart';

class ListTour extends StatelessWidget {
  final String tourName;
  final String leagueName;
  final String leagueLogo;
  final DateTime startDate;
  final DateTime endDate;
  final String region;
  final String type;
  final int teamCount;
  final String prizePool;

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
    required this.prizePool,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            child: Center(child: Text(tourName)),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TourFormat()),
                ),
          ),
        ),
      ],
    );
  }
}
