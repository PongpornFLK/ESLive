class TournamentData {
  final String tourName;

  const TournamentData({required this.tourName});

  factory TournamentData.fromjson(Map<String, dynamic> json) {
    return TournamentData(tourName: json['name']);
  }
}
