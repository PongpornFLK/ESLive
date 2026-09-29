import 'package:es_live/_service/homelive/match_pro.dart';
import 'package:es_live/_service/noti/noti_store.dart' as store;
import 'package:es_live/core/config/nav_key.dart';
import 'package:es_live/core/model/noti_item.dart';
import 'package:es_live/homelive/analyze/analyze.dart';
import 'package:es_live/noti/widgets/noti_banner.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// สถานะของกระดิ่ง = รายการที่เคยได้รับ + มีใบที่ยังไม่ได้เปิดดูไหม
class NotiState {
  final List<NotiItem> items;
  final bool hasUnread;

  const NotiState({required this.items, required this.hasUnread});
}

final notiProvider = AsyncNotifierProvider<NotiNotifier, NotiState>(
  NotiNotifier.new,
);

class NotiNotifier extends AsyncNotifier<NotiState> {
  @override
  Future<NotiState> build() async {
    // listen FCM : App เปิดค้างอยู่ -> onMessage
    final onMsg = FirebaseMessaging.onMessage.listen(_onForeground);
    // อยู่นอก App : กด Noti -> onMessageOpenedApp
    final onOpen = FirebaseMessaging.onMessageOpenedApp.listen(_onOpened);

    ref.onDispose(() {
      onMsg.cancel();
      onOpen.cancel();
    });

    // แอปถูกปิดสนิทแล้วผู้ใช้กดแจ้งเตือนจนแอปเปิดขึ้นมา
    FirebaseMessaging.instance.getInitialMessage().then((msg) {
      if (msg != null) _onOpened(msg);
    });

    return NotiState(
      items: await store.getAll(),
      hasUnread: await store.getUnread(),
    );
  }

  /// แปลงข้อความจาก FCM เป็น NotiItem แล้วเก็บไว้บนสุดของรายการ
  Future<NotiItem> _save(RemoteMessage msg) async {
    final item = NotiItem(
      title: msg.notification?.title ?? '',
      body: msg.notification?.body ?? '',
      matchId: msg.data['match_id'],
      receivedAt: DateTime.now(),
    );

    final items = <NotiItem>[item, ...?state.value?.items];
    await store.saveAll(items);
    await store.setUnread(true);

    state = AsyncData(NotiState(items: items, hasUnread: true));
    return item;
  }

  Future<void> _onForeground(RemoteMessage msg) async {
    final item = await _save(msg);

    // ตอนแอปเปิดค้างอยู่ Android ไม่เด้งให้เอง ต้องวาดแถบเอง
    showNotiBanner(
      title: item.title,
      body: item.body,
      onTap: item.matchId == null ? null : () => openMatch(item.matchId!),
    );
  }

  Future<void> _onOpened(RemoteMessage msg) async {
    final item = await _save(msg);
    if (item.matchId != null) await openMatch(item.matchId!);
  }

  /// ไปหน้า MatchAnalyze ต้องการ MatchData ทั้งก้อนลยต้องไปหาจาก provider ก่อน
  Future<void> openMatch(String matchId) async {
    final nav = navigatorKey.currentState;
    if (nav == null) return;

    final matches = await ref.read(matchProvider.future);
    final found = matches.where((m) => m.id == matchId);
    if (found.isEmpty) return;

    nav.push(
      MaterialPageRoute(builder: (_) => MatchAnalyze(match: found.first)),
    );
  }

  /// ผู้ใช้เปิดรายการดูแล้ว จุดแดงบนกระดิ่งหายไป
  Future<void> markRead() async {
    await store.setUnread(false);
    final items = state.value?.items ?? <NotiItem>[];
    state = AsyncData(NotiState(items: items, hasUnread: false));
  }

  Future<void> clearAll() async {
    await store.saveAll([]);
    await store.setUnread(false);
    state = const AsyncData(NotiState(items: [], hasUnread: false));
  }
}
