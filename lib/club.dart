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
      id: json['id'],
      name: json['name'],
      communityId: json['community_id'],
      sport: json['sport'] != null ? Sport.fromJson(json['sport']) : null,
      skillLevel: json['skill_level'] != null
          ? SkillLevel.fromJson(json['skill_level'])
          : null,
      privacyType: json['privacy_type'],
      autoApprove: json['auto_approve'],
      memberCount: json['member_count'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      description: json['description'],
      logo: json['logo'],
    );
  }
}