import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';

/// จุดแดงบอกว่ากำลังถ่ายทอดสด วงจางรอบนอกขยายออกแล้วหุบเข้าเป็นจังหวะ
///
/// ใช้ ScaleTransition ไม่ใช่ setState ทุกเฟรม
/// ScaleTransition ขยับแค่ค่า transform ตอนวาด ไม่ build widget ข้างในใหม่
class LiveCircle extends StatefulWidget {
  const LiveCircle({super.key});

  @override
  State<LiveCircle> createState() => _LiveCircleState();
}

class _LiveCircleState extends State<LiveCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // vsync: this มาจาก SingleTickerProviderStateMixin
    // ผูกจังหวะเข้ากับรอบวาดจอ พอแอปถูกพับลงพื้นหลัง ticker หยุดเอง ไม่กินแบต
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true); // 0 -> 1 -> 0 -> 1 ขยายออกแล้วหุบเข้า

    // easeInOut ทำให้ช้าลงตอนสุดปลายทั้งสองข้าง ดูเหมือนหายใจ ไม่ใช่กระตุก
    _scale = Tween(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    // ปิด ticker ทิ้งเสมอ ไม่งั้นมันวิ่งต่อหลัง widget ถูกถอดออกจากจอไปแล้ว
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // วงจางรอบนอก ตัวเดียวที่ขยับ
        ScaleTransition(
          scale: _scale,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: const Color.fromARGB(52, 205, 0, 0),
            ),
          ),
        ),
        // จุดแดงตรงกลางอยู่นิ่ง ถ้าขยับทั้งก้อนจะเด้งจนรำคาญตา
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
