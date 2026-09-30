import 'package:es_live/_service/user/user_store.dart' as store;
import 'package:es_live/core/model/profile_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ค่าตั้งค่าฝั่ง server อ่านครั้งเดียวตอนเปิดหน้า Setting แล้วแก้ผ่าน update()
final profileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileData>(
  ProfileNotifier.new,
);

class ProfileNotifier extends AsyncNotifier<ProfileData> {
  @override
  Future<ProfileData> build() => store.getProfile();

  /// ส่งเฉพาะ field ที่จะแก้ แล้วเอาค่าที่ server ตอบกลับมาเป็น state ใหม่
  /// จะได้ไม่ต้องเดาว่า server บันทึกอะไรไปจริง ๆ
  Future<void> save(Map<String, dynamic> data) async {
    state = AsyncData(await store.patchProfile(data));
  }
}
