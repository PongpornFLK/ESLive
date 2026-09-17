class TournamentData {
  final String tourId;
  final String tourName;
  final String leagueName;
  final String? leagueLogo;
  final String? startDate;
  final String? endDate;
  final String region;
  final String type;
  final int teamCount;
  final bool hasBracket;
  final String? prizePool;

  const TournamentData({
    required this.tourId,
    required this.tourName,
    required this.leagueName,
    required this.leagueLogo,
    required this.startDate,
    required this.endDate,
    required this.region,
    required this.type,
    required this.teamCount,
    required this.hasBracket,
    required this.prizePool,
  });

  factory TournamentData.fromjson(Map<String, dynamic> json) {
    return TournamentData(
      tourId: json['id'],
      tourName: json['name'],
      leagueName: json['league_name'],
      leagueLogo: json['league_logo_url'],
      startDate: json['begin_at'],
      endDate: json['end_at'],
      region: json['region'],
      type: json['type'],
      teamCount: json['team_count'],
      hasBracket: json['has_bracket'],
      prizePool: json['prizepool'],
    );
  }
}
