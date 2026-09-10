class TeamData{
  final String teamName;
  final String? logoUrl;

  const TeamData({required this.logoUrl ,required this.teamName});

  factory TeamData.fromjson(Map<String , dynamic> json){
    return TeamData(
      teamName: json['name'],
      logoUrl:json['logo_url'] 
      );
  }
}
