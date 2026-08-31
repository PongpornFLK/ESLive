import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.orange, AppColors.gold]),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: AppColors.orange, spreadRadius: 1, blurRadius: 15),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.main,
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          child: NavigationBar(
            labelTextStyle: WidgetStateTextStyle.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                );
              }
              return TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              );
            }),

            selectedIndex: currentIndex,
            indicatorColor: AppColors.orange,
            backgroundColor: AppColors.main,
            onDestinationSelected: onTap,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.live_tv_rounded,
                  color: AppColors.main,
                ),
                icon: Icon(Icons.live_tv_rounded, color: Colors.white),
                label: "Live",
              ),
              NavigationDestination(
                selectedIcon: Icon(
                  Icons.line_style_outlined,
                  color: AppColors.main,
                ),
                icon: Icon(Icons.line_style_outlined, color: Colors.white),
                label: "Tour",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.star_border, color: AppColors.main),
                icon: Icon(Icons.star_border, color: Colors.white),
                label: "Follow",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.note_outlined, color: AppColors.main),
                icon: Icon(Icons.note_outlined, color: Colors.white),
                label: "Patch",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.settings, color: AppColors.main),
                icon: Icon(Icons.settings, color: Colors.white),
                label: "Setting",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
