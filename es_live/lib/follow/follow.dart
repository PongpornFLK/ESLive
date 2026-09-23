import 'package:es_live/_service/follow/follow_pro.dart';
import 'package:es_live/follow/widgets/follow_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Follow extends ConsumerStatefulWidget {
  const Follow({super.key});

  @override
  ConsumerState<Follow> createState() => _FollowState();
}

class _FollowState extends ConsumerState<Follow> {
  @override
  Widget build(BuildContext context) {
    final followAsync = ref.watch(followProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          followAsync.when(
            data:
                (data) =>
                    data.isEmpty
                        ? Center(child: Text("You are not following yet."))
                        : Column(
                          children:
                              data
                                  .map(
                                    (e) => FollowCard(
                                      logoUrl: e.logoUrl,
                                      teamName: e.teamName,
                                      onRemove:
                                          () => ref
                                              .read(followProvider.notifier)
                                              .untoggle(e.teamId),
                                    ),
                                  )
                                  .toList(),
                        ),
            error:
                (error, stackTrace) => Center(
                  child: Text(
                    "$error",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
            loading: () => Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
