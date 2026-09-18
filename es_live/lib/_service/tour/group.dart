import 'package:es_live/core/config/dio_config.dart';
import 'package:es_live/core/model/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupProvider = FutureProvider.family<List<GroupData>, String>((
  ref,
  tourId,
) async {
  try {
    final res = await dio.get('/tournament/standing/$tourId');
    final List<dynamic> groupList = res.data;

    return groupList.map((json) => GroupData.fromjson(json)).toList();
  } catch (e) {
    throw Exception(e);
  }
});
