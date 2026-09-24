class FollowData {
  final String teamId;
  final String teamName;
  final String? logoUrl;

  const FollowData({
    required this.teamId,
    required this.logoUrl,
    required this.teamName,
  });

  // อ่านจาก API
  factory FollowData.fromjson(Map<String, dynamic> json) {
    return FollowData(
      teamId: json['team_id'],
      logoUrl: json['logo_url'],
      teamName: json['team_name'],
    );
  }
}
