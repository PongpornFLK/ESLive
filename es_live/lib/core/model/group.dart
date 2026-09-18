class GroupData {
  final int rank;
  final String teamName;
  final String? teamLogo;
  final int? matchePlay;
  final int? win;
  final int? loss;
  final int? gameWin;
  final int? gameLoss;
  final int? gameTie;

  const GroupData({
    required this.rank,
    required this.teamName,
    required this.teamLogo,
    required this.matchePlay,
    required this.win,
    required this.loss,
    required this.gameWin,
    required this.gameLoss,
    required this.gameTie,
  });

  factory GroupData.fromjson(Map<String, dynamic> json) {
    return GroupData(
      rank: json['rank'],
      teamName: json['team_name'],
      teamLogo: json['team_logo'],
      matchePlay: json['matches_played'],
      win: json['wins'],
      loss: json['losses'],
      gameWin: json['game_wins'],
      gameLoss: json['game_losses'],
      gameTie: json['game_ties'],
    );
  }
}
