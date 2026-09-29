import 'package:flutter/material.dart';

/// กุญแจของ Navigator ตัวหลัก
/// ใช้เปิดหน้าใหม่จากที่ที่ไม่มี BuildContext เช่นตอนผู้ใช้กดแจ้งเตือนขณะแอปปิดอยู่
final navigatorKey = GlobalKey<NavigatorState>();
