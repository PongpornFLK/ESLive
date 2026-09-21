class MatchAnalyzeData {
  final double? winRateA;
  final double? winRateB;
  final String? reason;
  final String status;

  const MatchAnalyzeData({
    required this.winRateA,
    required this.winRateB,
    required this.reason,
    required this.status,
  });

  factory MatchAnalyzeData.fromjson(Map<String, dynamic> json) {
    return MatchAnalyzeData(
      winRateA: json["win_pct_a"],
      winRateB: json["win_pct_b"],
      reason: json["reasoning"],
      status: json["status"],
    );
  }
}
