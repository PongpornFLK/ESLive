class GameInList {
  final String logo;
  final String name;

  const GameInList({required this.logo, required this.name});
}

final List<GameInList> data = [
  const GameInList(logo: 'assests/img/list_game/pubg.png', name: "PubG"),
  const GameInList(
    logo: 'assests/img/list_game/valorant.png',
    name: "Valorant",
  ),
];

class GameData {
  final String gameName;

  const GameData({required this.gameName});
  factory GameData.fromjson(Map<String, dynamic> json) {
    return GameData(gameName: json['name']);
  }
}
