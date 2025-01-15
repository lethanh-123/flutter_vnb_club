class Match {
  final int id;
  final int sportId;
  final String title;
  final DateTime datetime;
  final DateTime registrationDeadline;
  final String location;
  final int maxPlayers;
  final double fee;
  final int? minSkillLevelId;
  final int? maxSkillLevelId;
  final String? notes;
  final String? genderRestriction;
  final String? ageRestriction;
  final String? organizerRole;
  final String? leaveRestriction;
  final bool autoApprove;
  final String? matchFormat;
  final int? clubId;
  final int? createdBy;
  final DateTime createdAt;
  final int currentParticipants;
  final String? sportName;
  final String? clubName;

  Match({
    required this.id,
    required this.sportId,
    required this.title,
    required this.datetime,
    required this.registrationDeadline,
    required this.location,
    required this.maxPlayers,
    required this.fee,
    this.minSkillLevelId,
    this.maxSkillLevelId,
    this.notes,
    this.genderRestriction,
    this.ageRestriction,
    this.organizerRole,
    this.leaveRestriction,
    required this.autoApprove,
    this.matchFormat,
    this.clubId,
    this.createdBy,
    required this.createdAt,
    required this.currentParticipants,
    this.sportName,
    this.clubName,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as int,
      sportId: json['sport_id'] as int,
      title: json['title'] as String,
      datetime: DateTime.parse(json['datetime'] as String),
      registrationDeadline: DateTime.parse(json['registration_deadline'] as String),
      location: json['location'] as String,
      maxPlayers: json['max_players'] as int,
      fee: (json['fee'] as num).toDouble(),
      minSkillLevelId: json['min_skill_level_id'] as int?,
      maxSkillLevelId: json['max_skill_level_id'] as int?,
      notes: json['notes'] as String?,
      genderRestriction: json['gender_restriction'] as String?,
      ageRestriction: json['age_restriction'] as String?,
      organizerRole: json['organizer_role'] as String?,
      leaveRestriction: json['leave_restriction'] as String?,
      autoApprove: json['auto_approve'] as bool? ?? false,
      matchFormat: json['match_format'] as String?,
      clubId: json['club_id'] as int?,
      createdBy: json['created_by'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      currentParticipants: json['current_participants'] as int? ?? 0,
      sportName: json['sport_name'] as String?,
      clubName: json['club_name'] as String?,
    );
  }
}