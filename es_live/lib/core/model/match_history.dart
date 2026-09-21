/// 1 แถว = 1 นัดที่ทีมนั้นเคยแข่ง
/// backend สลับฝั่งให้แล้ว scoreTeam จึงเป็นของทีมที่ถามเสมอ ไม่ใช่ score_a ดิบ
class MatchHistoryData {
  final String result;
  final String oppName;
  final String? oppLogo;
  final int? scoreTeam;
  final int? scoreOpp;

  const MatchHistoryData({
    required this.result,
    required this.oppName,
    required this.oppLogo,
    required this.scoreTeam,
    required this.scoreOpp,
  });

  factory MatchHistoryData.fromjson(Map<String, dynamic> json) {
    return MatchHistoryData(
      result: json["result"],
      oppName: json["opponent_name"],
      oppLogo: json["opponent_logo"],
      scoreTeam: json["score_team"],
      scoreOpp: json["score_opponent"],
    );
  }
}

/// ก้อนที่ /match/history/{id} ส่งกลับมา ฟอร์มของทั้ง 2 ทีม
class HistoryObj {
  final List<MatchHistoryData> formA;
  final List<MatchHistoryData> formB;

  const HistoryObj({required this.formA, required this.formB});

  factory HistoryObj.fromjson(Map<String, dynamic> json) {
    return HistoryObj(
      formA:
          (json["form_a"] as List<dynamic>)
              .map((e) => MatchHistoryData.fromjson(e))
              .toList(),
      formB:
          (json["form_b"] as List<dynamic>)
              .map((e) => MatchHistoryData.fromjson(e))
              .toList(),
    );
  }
}
