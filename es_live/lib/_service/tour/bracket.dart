import 'package:es_live/core/config/dio_config.dart';
import 'package:es_live/core/model/bracket_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bracketProvider = FutureProvider.family<List<BracketData>,String>((ref,tourId) async {
  try {
    final res = await dio.get('/tournament/bracket/$tourId');
    final List<dynamic> bracketList = res.data;

    return bracketList.map((json) => BracketData.fromjson(json)).toList();
  } catch (e) {
    throw Exception("Fail to load data $e");
  }
});
