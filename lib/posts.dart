class Post {
  final int id;
  final int author_id;
  final String? author_name;
  final String? author_avatar;
  final String content;
  final String created_at;
  final int? club_id;
  final String? club_name;
  final Map<String, dynamic>? event_data;
  final int reactions_count;
  final int comments_count;

  Post({
    required this.id,
    required this.author_id,
    this.author_name,
    this.author_avatar,
    required this.content,
    required this.created_at,
    this.club_id,
    this.club_name,
    this.event_data,
    required this.reactions_count,
    required this.comments_count,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      author_id: json['author_id'],
      author_name: json['author_name'],
      author_avatar: json['author_avatar'],
      content: json['content'],
      created_at: json['created_at'],
      club_id: json['club_id'],
      club_name: json['club_name'],
      event_data: json['event_data'],
      reactions_count: json['reactions_count'] ?? 0,
      comments_count: json['comments_count'] ?? 0,
    );
  }
}
