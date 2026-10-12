import 'package:es_live/core/config/dio_config.dart';
import 'package:es_live/core/model/tour_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tourProvider = FutureProvider<List<TournamentData>>((ref) async {
  try {
    final res = await dio.get('/tournament');
    final List<dynamic> tourList = res.data;

    return tourList.map((json) => TournamentData.fromjson(json)).toList();
  } catch (e) {
    throw Exception("Fail to load data $e");
  }
});

final tourProviderGameId = FutureProvider.family<List<SerieData>, String>((
  ref,
  gameId,
) async {
  try {
    final res = await dio.get(
      "/tournament",
      queryParameters: {"game_slug": gameId},
    );
    final List<dynamic> tourGroupList = res.data;

    return tourGroupList.map((json) => SerieData.fromjson(json)).toList();
  } catch (e) {
    throw Exception(e);
  }
});
