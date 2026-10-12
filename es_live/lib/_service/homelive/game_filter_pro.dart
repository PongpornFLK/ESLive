import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Select game filter
class GameFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  /// กดเกมที่เลือกอยู่ซ้ำ = ยกเลิกตัวกรอง กลับไปเห็นทุกเกม
  void toggle(String slug) => state = state == slug ? null : slug;
}

final gameFilterProvider = NotifierProvider<GameFilterNotifier, String?>(
  GameFilterNotifier.new,
);
