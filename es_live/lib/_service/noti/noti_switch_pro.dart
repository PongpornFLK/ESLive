import 'package:es_live/_service/noti/noti.dart';
import 'package:es_live/_service/noti/noti_store.dart' as store;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Switch noti - ปิด = ลบ token
class NotiSwitchNotifier extends Notifier<bool> {
  @override
  bool build() {
    _load();
    return true;
  }

  Future<void> _load() async {
    state = await store.getEnabled();
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    // บันทึกก่อนเสมอ เพราะ setupNoti อ่านค่านี้ตัดสินใจว่าจะลงทะเบียนไหม
    await store.setEnabled(value);

    if (value) {
      await setupNoti();
    } else {
      await removeNoti();
    }
  }
}

final notiSwitchProvider = NotifierProvider<NotiSwitchNotifier, bool>(
  NotiSwitchNotifier.new,
);
