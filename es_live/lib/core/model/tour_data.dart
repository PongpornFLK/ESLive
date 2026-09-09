class Tournament {
  final String tourName;

  const Tournament({required this.tourName});

  factory Tournament.fromjson(Map<String, dynamic> json) {
    return Tournament(tourName: json['name']);
  }
}
