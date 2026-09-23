import 'package:es_live/core/model/team_data.dart';

class FollowData {
  final String teamId;
  final String teamName;
  final String? logoUrl;

  const FollowData({
    required this.teamId,
    required this.logoUrl,
    required this.teamName,
  });

  // รับข้อมูล Team
  factory FollowData.fromTeam(TeamData team) {
    return FollowData(
      teamId: team.teamId,
      logoUrl: team.logoUrl,
      teamName: team.teamName,
    );
  }

  // Map data ลง Prefs
  Map<String, dynamic> toJson() {
    return {"team_id": teamId, "team_name": teamName, "logo_url": logoUrl};
  }

  // อ่านจาก Prefs
  factory FollowData.fromjson(Map<String, dynamic> json) {
    return FollowData(
      teamId: json['team_id'],
      logoUrl: json['logo_url'],
      teamName: json['team_name'],
    );
  }
}
