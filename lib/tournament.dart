class Tournament {
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
  final String tournamentType;
  final int? clubId;
  final String? clubName;
  final int currentParticipants;

  Tournament({
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
    required this.tournamentType,
    this.clubId,
    this.clubName,
    required this.currentParticipants,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
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
      tournamentType: json['tournament_type'],
      clubId: json['club_id'],
      clubName: json['club_name'],
      currentParticipants: json['current_participants'],
    );
  }
}