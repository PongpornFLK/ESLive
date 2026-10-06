import 'package:es_live/core/theme/root_colors.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// เลขเวอร์ชันท้ายหน้าตั้งค่า
///
/// อ่านจากแอปที่ติดตั้งอยู่จริง ไม่ใช่ค่าที่พิมพ์ไว้ในโค้ด
/// เพราะเขียนเองมีโอกาสลืมอัปเดตแล้วแสดงเลขผิด
class VersionText extends StatelessWidget {
  const VersionText({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;

        // ระหว่างรอไม่ต้องโชว์อะไร เพราะเสร็จในเสี้ยววินาที
        // ใส่ spinner จะเห็นเป็นแค่การกะพริบ
        if (info == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Center(
            child: Text(
              // version = เลขที่คนอ่าน  buildNumber = เลขที่ Android ใช้เทียบว่าใหม่กว่าไหม
              'v${info.version} (${info.buildNumber})',
              style: const TextStyle(color: AppColors.grey, fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
