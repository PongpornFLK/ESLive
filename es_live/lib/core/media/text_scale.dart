import 'package:flutter/material.dart';

double scaledHeight(BuildContext context, double base) {
  final scale = MediaQuery.textScalerOf(context).scale(1);

  return base *
      scale.clamp(
        1.0,
        1.5,
      ); // ต่ำกว่า 1.0 ดันขึ้นเป็น 1.0  เกิน 1.5 ตัดเหลือ 1.5
}
