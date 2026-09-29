import 'package:es_live/_service/noti/noti_store.dart' as store;
import 'package:es_live/core/config/dio_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dart:developer' as dev;

/// No Provider
bool _started = false;

/// เปิด noti เรียกครั้งเดียวหลังจาก Login
Future<void> setupNoti() async {
  if (_started) return;

  _started = true;

  // ผู้ใช้ปิดไว้ในหน้าตั้งค่า อย่าลงทะเบียนเครื่องนี้
  if (!await store.getEnabled()) return;

  final settings = await FirebaseMessaging.instance.requestPermission();
  final status = settings.authorizationStatus;
  // dev.log("NOTI: permission = $status");

  if (status != AuthorizationStatus.authorized) {
    return;
  }

  final token = await FirebaseMessaging.instance.getToken();

  if (token == null) return;
  await _sendToken(token);

  FirebaseMessaging.instance.onTokenRefresh.listen(_sendToken);
}

Future<void> _sendToken(String token) async {
  await dio.post("/user/device", data: {"token": token});
}

Future<void> removeNoti() async {
  final token = await FirebaseMessaging.instance.getToken();
  if (token == null) return;

  _started = false;

  await dio.delete("/user/device/$token");
}
