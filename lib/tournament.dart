import 'package:intl/intl.dart';

class Tournament {
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
  final String? tournamentType;
  final int? clubId;
  final int? createdBy;
  final DateTime createdAt;
  final int currentParticipants;
  final String? sportName;
  final String? clubName;
// Basic getters
  int get getId => id;
  int get getSportId => sportId;
  String get getTitle => title;
  DateTime get getDatetime => datetime;
  DateTime get getRegistrationDeadline => registrationDeadline;
  String get getLocation => location;
  int get getMaxPlayers => maxPlayers;
  double get getFee => fee;
  DateTime get getCreatedAt => createdAt;
  int get getCurrentParticipants => currentParticipants;

  // Nullable getters with default values
  int get getMinSkillLevelId => minSkillLevelId ?? 0;
  int get getMaxSkillLevelId => maxSkillLevelId ?? 0;
  String get getNotes => notes ?? '';
  String get getGenderRestriction => genderRestriction ?? '';
  String get getAgeRestriction => ageRestriction ?? '';
  String get getTournamentType => tournamentType ?? 'Đấu hỗn hợp';
  int get getClubId => clubId ?? 0;
  int get getCreatedBy => createdBy ?? 0;
  String get getSportName => sportName ?? 'Unknown Sport';
  String get getClubName => clubName ?? 'Unknown Club';

  // Formatted getters
  String get getFormattedTime =>
      "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";

  String get getFormattedDate => "${datetime.day}/${datetime.month}";

  String get getFormattedFullDate => DateFormat('dd/MM/yyyy').format(datetime);

  String get getFormattedDeadline =>
      DateFormat('dd/MM/yyyy HH:mm').format(registrationDeadline);

  String get getFormattedFee => NumberFormat('#,###', 'vi_VN').format(fee);

  // Status getters
  String get getStatus => '$currentParticipants/$maxPlayers người tham gia';
  bool get isLive =>
      datetime.isBefore(DateTime.now()) &&
      DateTime.now().isBefore(datetime.add(const Duration(days: 1)));
  bool get isUpcoming => datetime.isAfter(DateTime.now());
  bool get isRegistrationOpen => registrationDeadline.isAfter(DateTime.now());
  bool get isFull => currentParticipants >= maxPlayers;

  // Complex getters
  String get getSkillLevelRange =>
      'Level ${getMinSkillLevelId} - ${getMaxSkillLevelId}';

  String get getParticipantsStatus => '$currentParticipants/$maxPlayers';
  int get getParticipants => currentParticipants;
// Nếu bạn vẫn muốn có getter trả về string format, có thể đổi tên thành
  String get getParticipantsDisplay => '$currentParticipants/$maxPlayers';

  String get getType {
    if (tournamentType == null || tournamentType!.isEmpty) {
      return 'Giải đấu thông thường';
    }
    return tournamentType!;
  }

  bool get getIsLive {
    final now = DateTime.now();
    return datetime.isBefore(now) &&
        now.isBefore(datetime.add(const Duration(hours: 24)));
  }

  // Default image and icon getters
  String get getImage => 'assets/nba_players.webp';
  String get getSportIcon => 'assets/pic.png';

  Tournament({
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
    this.tournamentType,
    this.clubId,
    this.createdBy,
    required this.createdAt,
    required this.currentParticipants,
    this.sportName,
    this.clubName,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as int,
      sportId: json['sport_id'] as int,
      title: json['title'] as String,
      datetime: DateTime.parse(json['datetime'] as String),
      registrationDeadline:
          DateTime.parse(json['registration_deadline'] as String),
      location: json['location'] as String,
      maxPlayers: json['max_players'] as int,
      fee: (json['fee'] as num).toDouble(),
      minSkillLevelId: json['min_skill_level_id'] as int?,
      maxSkillLevelId: json['max_skill_level_id'] as int?,
      notes: json['notes'] as String?,
      genderRestriction: json['gender_restriction'] as String?,
      ageRestriction: json['age_restriction'] as String?,
      tournamentType: json['tournament_type'] as String?,
      clubId: json['club_id'] as int?,
      createdBy: json['created_by'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      currentParticipants: json['current_participants'] as int? ?? 0,
      sportName: json['sport_name'] as String?,
      clubName: json['club_name'] as String?,
    );
  }
}
