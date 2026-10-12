class TournamentData {
  final String tourId;
  final String tourName;
  final int? teamCount;
  final bool hasBracket;
  final String? prizePool;
  final String? leagueName;
  final String? leagueLogoUrl;
  final String? type;

  const TournamentData({
    required this.tourId,
    required this.tourName,
    required this.teamCount,
    required this.hasBracket,
    required this.prizePool,
    required this.leagueName,
    required this.leagueLogoUrl,
    required this.type,
  });

  factory TournamentData.fromjson(Map<String, dynamic> json) {
    return TournamentData(
      tourId: json['id'],
      tourName: json['name'],
      teamCount: json['team_count'],
      hasBracket: json['has_bracket'],
      prizePool: json['prizepool'],
      leagueName: json['league_name'],
      leagueLogoUrl: json['league_logo_url'],
      type: json['type'],
    );
  }
}

class SerieData {
  final int? serieId;
  final String? serieName;
  final String? region;
  final String? beginAt;
  final String? endAt;
  final String? leagueName;
  final String? leagueLogoUrl;
  final String? type;

  /// สองช่องนี้ backend คำนวณจากสเตจในกองให้แล้ว ไม่ได้ลอกจากสเตจใดสเตจหนึ่ง
  final String? prizePool;
  final int? teamCount;

  final List<TournamentData> playoffStages;
  final List<TournamentData> groupStages;

  const SerieData({
    required this.serieId,
    required this.serieName,
    required this.region,
    required this.beginAt,
    required this.endAt,
    required this.leagueName,
    required this.leagueLogoUrl,
    required this.type,
    required this.prizePool,
    required this.teamCount,
    required this.playoffStages,
    required this.groupStages,
  });

  factory SerieData.fromjson(Map<String, dynamic> json) {
    return SerieData(
      serieId: json['serie_id'],
      serieName: json['serie_name'],
      region: json['region'],
      beginAt: json['begin_at'],
      endAt: json['end_at'],
      leagueName: json['league_name'],
      leagueLogoUrl: json['league_logo_url'],
      type: json['type'],
      prizePool: json['prizepool'],
      teamCount: json['team_count'],
      playoffStages:
          (json['playoff_stages'] as List<dynamic>)
              .map((e) => TournamentData.fromjson(e))
              .toList(),
      groupStages:
          (json['group_stages'] as List<dynamic>)
              .map((e) => TournamentData.fromjson(e))
              .toList(),
    );
  }
}
