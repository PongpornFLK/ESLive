import 'package:es_live/core/theme/root_colors.dart';
import 'package:es_live/follow/follow.dart';
import 'package:es_live/homelive/live.dart';
import 'package:es_live/patch/patch.dart';
import 'package:es_live/setting/setting.dart';
import 'package:es_live/tour/tour.dart';
import 'package:es_live/widgets/app_bar.dart';
import 'package:es_live/widgets/bottom_bar.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int currentIndex = 0;

  final List<Widget> page = [
    const Live(),
    const Tour(),
    const Follow(),
    const Patch(),
    const Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: BottomBar(
        currentIndex: currentIndex,
        onTap:
            (int nextIndex) => setState(() {
              currentIndex = nextIndex;
            }),
      ),
      body: page[currentIndex],
    );
  }
}
