import 'sport.dart';

class Club {
  final int id;
  final String name;
  final int communityId;
  final Sport? sport;
  final SkillLevel? skillLevel;
  final String privacyType;
  final bool autoApprove;
  final int memberCount;
  final String createdAt;
  final int createdBy;
  final String? description;
  final String? logo;

  Club({
    required this.id,
    required this.name,
    required this.communityId,
    this.sport,
    this.skillLevel,
    required this.privacyType,
    required this.autoApprove,
    required this.memberCount,
    required this.createdAt,
    required this.createdBy,
    this.description,
    this.logo,
  });

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] as int,
      name: json['name'] as String,
      communityId: json['community_id'] as int,
      sport: json['sport'] != null ? Sport.fromJson(json['sport']) : null,
      skillLevel: json['skill_level'] != null
          ? SkillLevel.fromJson(json['skill_level'])
          : null,
      privacyType: json['privacy_type'] as String,
      autoApprove: json['auto_approve'] as bool,
      memberCount: json['member_count'] as int,
      createdAt: json['created_at'] as String,
      createdBy: json['created_by'] as int,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
    );
  }

  // Getters
  int get getId => id;
  String get getName => name;
  int get getCommunityId => communityId;
  Sport? get getSport => sport;
  SkillLevel? get getSkillLevel => skillLevel;
  String get getPrivacyType => privacyType;
  bool get getAutoApprove => autoApprove;
  int get getMemberCount => memberCount;
  String get getCreatedAt => createdAt;
  int get getCreatedBy => createdBy;
  String? get getDescription => description;
  String? get getLogo => logo;
}