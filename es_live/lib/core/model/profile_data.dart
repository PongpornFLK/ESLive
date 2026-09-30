/// ค่าตั้งค่าของผู้ใช้ที่เก็บบน server ไม่ใช่ในเครื่อง
///
/// ต่างจากธีมกับภาษาที่เก็บใน prefs ด้วย เพราะค่าพวกนี้ server เป็นคนอ่านไปใช้
/// ตอนตัดสินใจว่าจะส่งแจ้งเตือนให้ใครเมื่อไหร่
class ProfileData {
  final String? displayName;
  final String theme;
  final String language;
  final bool notifyAllMatches;
  final int notifyBeforeMinutes;

  const ProfileData({
    required this.displayName,
    required this.theme,
    required this.language,
    required this.notifyAllMatches,
    required this.notifyBeforeMinutes,
  });

  factory ProfileData.fromjson(Map<String, dynamic> json) {
    return ProfileData(
      displayName: json['display_name'],
      theme: json['theme'],
      language: json['language'],
      notifyAllMatches: json['notify_all_matches'],
      notifyBeforeMinutes: json['notify_before_minutes'],
    );
  }
}
