class TournamentData {
  final String tourName;
  final String leagueName;
  final String leagueLogo;
  final DateTime startDate;
  final DateTime endDate;
  final String region;
  final String type;
  final int teamCount;
  final String prizePool;

  const TournamentData({
    required this.tourName,
    required this.leagueName,
    required this.leagueLogo,
    required this.startDate,
    required this.endDate,
    required this.region,
    required this.type,
    required this.teamCount,
    required this.prizePool,
  });

  factory TournamentData.fromjson(Map<String, dynamic> json) {
    return TournamentData(
      tourName: json['name'],
      leagueName: json['league_name'],
      leagueLogo: json['league_logo_url'],
      startDate: DateTime.parse(json['begin_at']),
      endDate: DateTime.parse(json['end_at']),
      region: json['region'],
      type: json['type'],
      teamCount: json['team_count'],
      prizePool: json['prizepool'],
    );
  }
}
