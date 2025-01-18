class StreetCred {
  final int id;
  final String skillType;
  final int credPoints;
  final String fullName;
  final String? avatarUrl;
  final String location;
  final List<String?> topPlayersAvatars;

  StreetCred({
    required this.id,
    required this.skillType,
    required this.credPoints,
    required this.fullName,
    this.avatarUrl,
    required this.location,
    required this.topPlayersAvatars,
  });

  factory StreetCred.fromJson(Map<String, dynamic> json) {
    return StreetCred(
      id: json['id'],
      skillType: json['skill_type'],
      credPoints: json['cred_points'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      location: json['location'],
      topPlayersAvatars: List<String?>.from(json['top_players_avatars']),
    );
  }

  String getSkillTypeDisplayName() {
    switch (skillType) {
      case 'atp':
        return 'ATP';
      case 'defense':
        return 'Phòng thủ';
      case 'drop_resets':
        return 'Drop Resets';
      case 'poaching':
        return 'Poaching';
      case 'driving':
        return 'Driving';
      case 'dinking':
        return 'Dinking';
      default:
        return skillType;
    }
  }
}