class MatchAnalyzeData {
  final double? winRateA;
  final double? winRateB;
  final String? reasonEng;
  final String? reasonTh;
  final String status;

  const MatchAnalyzeData({
    required this.winRateA,
    required this.winRateB,
    required this.reasonEng,
    required this.reasonTh,
    required this.status,
  });

  factory MatchAnalyzeData.fromjson(Map<String, dynamic> json) {
    return MatchAnalyzeData(
      winRateA: json["win_pct_a"],
      winRateB: json["win_pct_b"],
      reasonEng: json["reasoning_eng"],
      reasonTh: json["reasoning_th"],
      status: json["status"],
    );
  }

  /// เลือกข้อความตามภาษาที่ผู้ใช้เลือกอยู่
  String? reasonFor(String langCode) {
    if (langCode == 'th') return reasonTh ?? reasonEng;

    return reasonEng;
  }
}
