import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// พื้นหลัง + โลโก้ + หัวข้อ
class AuthShell extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const AuthShell({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondmain,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assests/img/bg-app.png',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.2),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.orange,
                  AppColors.secondmain.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset('assests/img/logo.png', height: 120),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Genos",
                      fontWeight: FontWeight.w700,
                      fontSize: 34,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...children,
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
