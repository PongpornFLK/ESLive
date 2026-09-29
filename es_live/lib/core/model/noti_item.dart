/// แจ้งเตือน 1 ใบที่เคยเข้ามา เก็บไว้ในเครื่องเพื่อแสดงเป็นรายการย้อนหลัง
class NotiItem {
  final String title;
  final String body;

  /// null = แจ้งเตือนที่ไม่ได้ผูกกับแมตช์ เช่นข่าวอัปเดตแอป กดแล้วไม่ไปไหน
  final String? matchId;
  final DateTime receivedAt;

  const NotiItem({
    required this.title,
    required this.body,
    required this.matchId,
    required this.receivedAt,
  });

  factory NotiItem.fromjson(Map<String, dynamic> json) {
    return NotiItem(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      matchId: json['match_id'],
      receivedAt: DateTime.parse(json['received_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'match_id': matchId,
      'received_at': receivedAt.toIso8601String(),
    };
  }
}
