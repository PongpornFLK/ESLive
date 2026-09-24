import 'package:es_live/core/config/dio_config.dart';
import 'package:es_live/core/model/follow_data.dart';
import 'package:es_live/core/model/team_data.dart';

// เก็บบน server แล้ว ไม่ใช่ prefs อีก ทีมที่ติดตามจึงตามผู้ใช้ข้ามเครื่องได้
// token แนบให้อัตโนมัติโดย interceptor ใน dio_config.dart

Future<List<FollowData>> getAll() async {
  final res = await dio.get("/user/follow");
  final List<dynamic> data = res.data;

  return data.map((e) => FollowData.fromjson(e)).toList();
}

Future<void> add(TeamData team) async {
  await dio.post("/user/follow", data: {"team_id": team.teamId});
}

Future<void> remove(String teamId) async {
  await dio.delete("/user/follow/$teamId");
}
