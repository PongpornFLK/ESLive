class GameInList {
  final String logo;
  final String name;
  final String slug;

  const GameInList({
    required this.logo,
    required this.name,
    required this.slug,
  });
}

final List<GameInList> data = [
  const GameInList(
    logo: 'assests/img/list_game/valorant.png',
    name: "Valorant",
    slug: "valorant",
  ),
  const GameInList(
    logo: 'assests/img/list_game/league-of-legends.png',
    name: "LoL",
    slug: "league-of-legends",
  ),
];

GameInList? gameBySlug(String slug) {
  for (final game in data) {
    if (game.slug == slug) return game;
  }
  return null;
}

class GameData {
  final String gameName;
  final String slug;

  const GameData({required this.gameName, required this.slug});
  factory GameData.fromjson(Map<String, dynamic> json) {
    return GameData(gameName: json['name'], slug: json['slug']);
  }
}
