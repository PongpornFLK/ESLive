import 'package:es_live/_service/follow/follow_store.dart' as store;
import 'package:es_live/core/model/follow_data.dart';
import 'package:es_live/core/model/team_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final followProvider = AsyncNotifierProvider<FollowNotifier, List<FollowData>>(
  FollowNotifier.new,
);

class FollowNotifier extends AsyncNotifier<List<FollowData>> {
  @override
  Future<List<FollowData>> build() => store.getAll();

  bool isFollow(String teamId) {
    final list = state.value ?? [];
    return list.any((f) => f.teamId == teamId);
  }

  Future<void> toggle(TeamData team) async {
    await store.add(team);

    state = AsyncData(await store.getAll());
  }

  Future<void> untoggle(String teamId) async {
    await store.remove(teamId);

    state = AsyncData(await store.getAll());
  }
}
