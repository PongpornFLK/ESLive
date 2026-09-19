import 'package:flutter/material.dart';

class ListGame extends StatelessWidget {
  const ListGame({super.key, required this.logo, required this.gameName});

  final String logo;
  final String gameName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          width: 75,
          height: 75,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).cardColor,
          ),
          child: Image.asset(logo, fit: BoxFit.cover),
        ),
        Text(
          gameName,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ],
    );
  }
}
