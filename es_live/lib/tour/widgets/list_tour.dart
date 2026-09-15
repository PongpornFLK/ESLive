import 'package:es_live/tour/format.dart';
import 'package:flutter/material.dart';

class ListTour extends StatelessWidget {
  final String tourName;
  const ListTour({super.key, required this.tourName});

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
            child: Center(child: Text("Tour Name")),
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
