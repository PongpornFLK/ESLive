class GameData {
  final String logo;
  final String gameName;

  const GameData({required this.logo, required this.gameName});
}

final List<GameData> data = [
  const GameData(logo: 'assests/img/list_game/pubg.png', gameName: "PubG"),
  const GameData(
    logo: 'assests/img/list_game/valorant.png',
    gameName: "Valorant",
  ),
];
