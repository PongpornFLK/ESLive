import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

class LiveCircle extends StatelessWidget {
  const LiveCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color.fromARGB(52, 205, 0, 0),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 5,
          child: Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }
}
