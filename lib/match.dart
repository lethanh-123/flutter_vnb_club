class Match {
  final int id;
  final int sportId;
  final String title;
  final DateTime datetime;
  final DateTime registrationDeadline;
  final String location;
  final int maxPlayers;
  final double fee;
  final String? minSkillLevel;
  final String? maxSkillLevel;
  final String? notes;
  final String genderRestriction;
  final String? ageRestriction;
  final String organizerRole;
  final String leaveRestriction;
  final bool autoApprove;
  final String matchFormat;
  final int? clubId;
  final String? clubName;
  final int currentParticipants;
  final String? sportName;

  Match({
    required this.id,
    required this.sportId,
    required this.title,
    required this.datetime,
    required this.registrationDeadline,
    required this.location,
    required this.maxPlayers,
    required this.fee,
    this.minSkillLevel,
    this.maxSkillLevel,
    this.notes,
    required this.genderRestriction,
    this.ageRestriction,
    required this.organizerRole,
    required this.leaveRestriction,
    required this.autoApprove,
    required this.matchFormat,
    this.clubId,
    this.clubName,
    required this.currentParticipants,
    this.sportName,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      sportId: json['sport_id'],
      title: json['title'],
      datetime: DateTime.parse(json['datetime']),
      registrationDeadline: DateTime.parse(json['registration_deadline']),
      location: json['location'],
      maxPlayers: json['max_players'],
      fee: double.parse(json['fee'].toString()),
      minSkillLevel: json['min_skill_level'],
      maxSkillLevel: json['max_skill_level'],
      notes: json['notes'],
      genderRestriction: json['gender_restriction'],
      ageRestriction: json['age_restriction'],
      organizerRole: json['organizer_role'],
      leaveRestriction: json['leave_restriction'],
      autoApprove: json['auto_approve'],
      matchFormat: json['match_format'],
      clubId: json['club_id'],
      clubName: json['club_name'],
      currentParticipants: json['current_participants'],
      sportName: json['sport_name'],
    );
  }

  // Thêm toJson method nếu cần
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sport_id': sportId,
      'title': title,
      'datetime': datetime.toIso8601String(),
      'registration_deadline': registrationDeadline.toIso8601String(),
      'location': location,
      'max_players': maxPlayers,
      'fee': fee,
      'min_skill_level': minSkillLevel,
      'max_skill_level': maxSkillLevel,
      'notes': notes,
      'gender_restriction': genderRestriction,
      'age_restriction': ageRestriction,
      'organizer_role': organizerRole,
      'leave_restriction': leaveRestriction,
      'auto_approve': autoApprove,
      'match_format': matchFormat,
      'club_id': clubId,
      'club_name': clubName,
      'current_participants': currentParticipants,
      'sport_name': sportName,
    };
  }
}