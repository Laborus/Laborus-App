import 'package:laborus_app/core/model/laborus/user.dart';

class Comment {
  final String id;
  final String content;
  final User author;
  final DateTime createdAt;
  final List<String> likes;
  final bool isEdited;

  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
    this.likes = const [],
    this.isEdited = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      content:
          json['textContent'] ?? '', // Altere de 'content' para 'textContent'
      author:
          User.fromJson(json['postedBy']), // Altere de 'author' para 'postedBy'
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: List<String>.from(json['likes'] ?? []),
      isEdited: json['isEdited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'textContent': content, // Altere de 'content' para 'textContent'
      'postedBy': author.toJson(), // Altere de 'author' para 'postedBy'
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'isEdited': isEdited,
    };
  }
}
