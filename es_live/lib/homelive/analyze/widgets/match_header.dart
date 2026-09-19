import 'package:flutter/material.dart';

class MatchHeader extends StatelessWidget {
  const MatchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("Game")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("Tour")],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(""),
            Column(
              children: [
                Text("Time"),
                ElevatedButton(
                  onPressed:
                      () => showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            color: Colors.amber,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [],
                              ),
                            ),
                          );
                        },
                      ),
                  child: null,
                ),
              ],
            ),
            Image.network(""),
          ],
        ),
      ],
    );
  }
}
