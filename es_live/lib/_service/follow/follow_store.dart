import 'dart:convert';
import 'package:es_live/core/model/follow_data.dart';
import 'package:es_live/core/model/team_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<FollowData>> getAll() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getStringList("follow_team") ?? [];

  return raw.map((s) => FollowData.fromjson(jsonDecode(s))).toList();
}

// private อยู่ในไฟล์นี้เท่านั้น ข้างนอกต้องผ่าน add / remove
Future<void> _save(List<FollowData> list) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setStringList(
    "follow_team",
    list.map((s) => jsonEncode(s.toJson())).toList(),
  );
}

Future<void> add(TeamData team) async {
  final list = await getAll();

  if (list.any((f) => f.teamId == team.teamId)) return;

  list.add(FollowData.fromTeam(team));

  await _save(list);
}

Future<void> remove(String teamId) async {
  final list = await getAll();

  list.removeWhere((f) => f.teamId == teamId);

  await _save(list);
}
