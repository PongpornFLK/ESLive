import 'package:es_live/core/config/dio_config.dart';
import 'package:es_live/core/model/profile_data.dart';

Future<ProfileData> getProfile() async {
  final res = await dio.get("/user");
  return ProfileData.fromjson(res.data);
}

/// ส่งเฉพาะ field ที่จะแก้ ที่ไม่ส่งไปจะไม่ถูกแตะ (PATCH ไม่ใช่ PUT)
Future<ProfileData> patchProfile(Map<String, dynamic> data) async {
  final res = await dio.patch("/user", data: data);
  return ProfileData.fromjson(res.data);
}

/// ยิงแล้วไม่สนใจผล ใช้ตอนซิงก์ธีมกับภาษา
///
/// ค่าถูกเก็บลงเครื่องไปแล้ว ถ้า server ไม่รับก็ไม่ควรทำให้ UI สะดุด
/// และตอนยังไม่ล็อกอิน dio ไม่มี token แนบ จะได้ 401 เป็นเรื่องปกติ
Future<void> syncProfile(Map<String, dynamic> data) async {
  try {
    await dio.patch("/user", data: data);
  } catch (_) {
    // ตั้งใจเงียบ
  }
}
