// ignore_for_file: avoid_print

import 'package:es_live/core/config/dio_config.dart';
import 'package:es_live/core/model/match_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final matchProvider = FutureProvider<List<MatchData>>((ref) async {
  try {
    final res = await dio.get('/matchcoming');
    final List<dynamic> matchList = res.data;

    print(matchList);

    return matchList.map((json) => MatchData.fromjson(json)).toList();
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
});
