import 'dart:convert';

import 'package:es_live/core/model/noti_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _listKey = 'noti_list';
const _unreadKey = 'noti_unread';

/// เก็บไว้ 30 
const _maxKeep = 30;

Future<List<NotiItem>> getAll() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_listKey);
  if (raw == null) return [];

  final List<dynamic> list = jsonDecode(raw);
  return list.map((e) => NotiItem.fromjson(e)).toList();
}

Future<void> saveAll(List<NotiItem> items) async {
  final prefs = await SharedPreferences.getInstance();
  final keep = items.take(_maxKeep).toList();

  await prefs.setString(
    _listKey,
    jsonEncode(keep.map((e) => e.toJson()).toList()),
  );
}

Future<bool> getUnread() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_unreadKey) ?? false;
}

Future<void> setUnread(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_unreadKey, value);
}
