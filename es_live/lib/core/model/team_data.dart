class TeamData{
  final String teamId;
  final String teamName;
  final String? logoUrl;

  const TeamData({required this.teamId ,required this.logoUrl ,required this.teamName});

  factory TeamData.fromjson(Map<String , dynamic> json){
    return TeamData(
      teamId: json['id'],
      teamName: json['name'],
      logoUrl:json['logo_url'] 
      );
  }
}
