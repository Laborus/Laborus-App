import 'package:laborus_app/core/model/social/user.dart';

class Comment {
  final String id;
  final String content;
  // final User author;
  final DateTime createdAt;
  final List<String> likes;
  final bool isEdited;

  Comment({
    required this.id,
    required this.content,
    // required this.author,
    required this.createdAt,
    this.likes = const [],
    this.isEdited = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      // author: User.fromJson(json['author'] ?? {}),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: List<String>.from(json['likes'] ?? []),
      isEdited: json['isEdited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      // 'author': author.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'isEdited': isEdited,
    };
  }

  Comment copyWith({
    String? id,
    String? content,
    User? author,
    DateTime? createdAt,
    List<String>? likes,
    List<Comment>? replies,
    bool? isEdited,
  }) {
    return Comment(
      id: id ?? this.id,
      content: content ?? this.content,
      // author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}
