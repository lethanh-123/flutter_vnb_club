class Sport {
  final String name;
  final String level;
  final bool isPrimary;

  Sport({
    required this.name,
    required this.level,
    this.isPrimary = false,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      name: json['name'] as String,
      level: json['level'] as String,
      isPrimary: json['is_primary'] as bool? ?? false,
    );
  }
}