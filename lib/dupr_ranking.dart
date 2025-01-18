class DuprRanking {
  final int id;
  final String fullName;
  final String? avatarUrl;
  final double doublesRating;
  final double? singlesRating;
  final String location;
  final String? gender;

  DuprRanking({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.doublesRating,
    this.singlesRating,
    required this.location,
    this.gender,
  });

  factory DuprRanking.fromJson(Map<String, dynamic> json) {
    return DuprRanking(
      id: json['id'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      doublesRating: json['doubles_rating'].toDouble(),
      singlesRating: json['singles_rating']?.toDouble(),
      location: json['location'],
      gender: json['gender'],
    );
  }
}