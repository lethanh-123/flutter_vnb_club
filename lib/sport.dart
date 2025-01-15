class Sport {
  final int id;
  final String name;
  final String? level;
  final bool isPrimary;
  final String? icon;
  final String? description;
  final String? rules;
  final String? equipment;
  final String? venue;
  final int? minPlayers;
  final int? maxPlayers;
  final String? skillLevelDescription;
  final DateTime? createdAt;
  final int? createdBy;
  final List<SkillLevel>? skillLevels;

  Sport({
    required this.id,
    required this.name,
    this.level,
    this.isPrimary = false,
    this.icon,
    this.description,
    this.rules,
    this.equipment,
    this.venue,
    this.minPlayers,
    this.maxPlayers,
    this.skillLevelDescription,
    this.createdAt,
    this.createdBy,
    this.skillLevels,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['id'] as int,
      name: json['name'] as String,
      level: json['level'] as String?,
      isPrimary: json['is_primary'] as bool? ?? false,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      rules: json['rules'] as String?,
      equipment: json['equipment'] as String?,
      venue: json['venue'] as String?,
      minPlayers: json['min_players'] as int?,
      maxPlayers: json['max_players'] as int?,
      skillLevelDescription: json['skill_level_description'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
      createdBy: json['created_by'] as int?,
      skillLevels: json['skill_levels'] != null
          ? (json['skill_levels'] as List)
              .map((level) => SkillLevel.fromJson(level))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'is_primary': isPrimary,
      'icon': icon,
      'description': description,
      'rules': rules,
      'equipment': equipment,
      'venue': venue,
      'min_players': minPlayers,
      'max_players': maxPlayers,
      'skill_level_description': skillLevelDescription,
      'created_at': createdAt?.toIso8601String(),
      'created_by': createdBy,
      'skill_levels': skillLevels?.map((level) => level.toJson()).toList(),
    };
  }

  // Copy with method for immutability
  Sport copyWith({
    int? id,
    String? name,
    String? level,
    bool? isPrimary,
    String? icon,
    String? description,
    String? rules,
    String? equipment,
    String? venue,
    int? minPlayers,
    int? maxPlayers,
    String? skillLevelDescription,
    DateTime? createdAt,
    int? createdBy,
    List<SkillLevel>? skillLevels,
  }) {
    return Sport(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      isPrimary: isPrimary ?? this.isPrimary,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      rules: rules ?? this.rules,
      equipment: equipment ?? this.equipment,
      venue: venue ?? this.venue,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      skillLevelDescription: skillLevelDescription ?? this.skillLevelDescription,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      skillLevels: skillLevels ?? this.skillLevels,
    );
  }

  // Helper method to get skill level by id
  SkillLevel? getSkillLevelById(int id) {
    return skillLevels?.firstWhere(
      (level) => level.id == id,
      orElse: () => SkillLevel(id: 0, level: 'Unknown'),
    );
  }

  // Helper method to get skill level by name
  SkillLevel? getSkillLevelByName(String name) {
    return skillLevels?.firstWhere(
      (level) => level.level.toLowerCase() == name.toLowerCase(),
      orElse: () => SkillLevel(id: 0, level: 'Unknown'),
    );
  }

  @override
  String toString() => 'Sport(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Sport && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class SkillLevel {
  final int id;
  final String level;
  final String? description;
  final int? minRating;
  final int? maxRating;
  final String? requirements;

  SkillLevel({
    required this.id,
    required this.level,
    this.description,
    this.minRating,
    this.maxRating,
    this.requirements,
  });

  factory SkillLevel.fromJson(Map<String, dynamic> json) {
    return SkillLevel(
      id: json['id'] as int,
      level: json['level'] as String,
      description: json['description'] as String?,
      minRating: json['min_rating'] as int?,
      maxRating: json['max_rating'] as int?,
      requirements: json['requirements'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'description': description,
      'min_rating': minRating,
      'max_rating': maxRating,
      'requirements': requirements,
    };
  }

  SkillLevel copyWith({
    int? id,
    String? level,
    String? description,
    int? minRating,
    int? maxRating,
    String? requirements,
  }) {
    return SkillLevel(
      id: id ?? this.id,
      level: level ?? this.level,
      description: description ?? this.description,
      minRating: minRating ?? this.minRating,
      maxRating: maxRating ?? this.maxRating,
      requirements: requirements ?? this.requirements,
    );
  }

  @override
  String toString() => 'SkillLevel(id: $id, level: $level)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SkillLevel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}