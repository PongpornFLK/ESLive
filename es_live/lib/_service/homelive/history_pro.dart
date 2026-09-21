import 'package:es_live/core/config/dio_config.dart';
import 'package:es_live/core/model/match_history.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// endpoint คืน object
final historyProvider = FutureProvider.family<HistoryObj, String>((
  ref,
  matchId,
) async {
  try {
    final res = await dio.get("/match/history/$matchId");

    return HistoryObj.fromjson(res.data);
  } catch (e) {
    throw Exception(e);
  }
});
