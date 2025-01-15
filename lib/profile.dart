class Profile {
  final int id;
  final int userId;
  final String? fullName;
  final String? username;
  final String? bio;
  final String? gender;
  final String? ageGroup;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<int> preferredSports;
  final List<int> preferredCommunities;
  final int primarySportId;
  final Map<String, dynamic>? achievements;
  final Map<String, dynamic>? stats;
  final Map<String, dynamic>? settings;

  Profile({
    required this.id,
    required this.userId,
    this.fullName,
    this.username,
    this.bio,
    this.gender,
    this.ageGroup,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.preferredSports,
    required this.preferredCommunities,
    required this.primarySportId,
    this.achievements,
    this.stats,
    this.settings,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['user_id'],
      fullName: json['full_name'],
      username: json['username'],
      bio: json['bio'],
      gender: json['gender'],
      ageGroup: json['age_group'],
      avatarUrl: json['avatar_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      preferredSports: List<int>.from(json['preferred_sports'] ?? []),
      preferredCommunities: List<int>.from(json['preferred_communities'] ?? []),
      primarySportId: json['primary_sport_id'],
      achievements: json['achievements'],
      stats: json['stats'],
      settings: json['settings'],
    );
  }
}