import 'package:laborus_app/core/model/laborus/user.dart';

class Post {
  final String? id;
  final User user;
  final String title;
  final String text;
  final String media;
  final String visibility;
  final int likesCount;
  // final List<Comment> comments;
  final int reportCount;
  final List<String> shares;
  final List<String> likedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isEdited;

  Post({
    this.id,
    required this.title,
    required this.user,
    required this.text,
    this.media = '',
    required this.visibility,
    this.likesCount = 0,
    // this.comments = const [],
    this.reportCount = 0,
    this.shares = const [],
    this.likedBy = const [],
    this.createdAt,
    this.updatedAt,
    this.isEdited = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      user: json['postedBy'] is Map<String, dynamic>
          ? User.fromJson(json['postedBy'])
          : User(id: json['postedBy'] ?? '', name: 'Usuário Desconhecido'),
      text: json['textContent'] ?? '',
      media: json['image'] ?? '',
      visibility: json['postedOn'] ?? 'Global',
      likesCount: json['likes']?.length ?? 0,
      reportCount: json['reports']?.length ?? 0,
      shares: List<String>.from(json['sharedBy'] ?? []),
      likedBy: List<String>.from(json['likes'] ?? []),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isEdited: json['isEdited'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textContent': text,
      'image': media,
      'title': title,
      'postedOn': visibility,
      'isEdited': isEdited,
    };
  }

  Post copyWith({
    String? id,
    User? user,
    String? text,
    String? visibility,
    int? likesCount,
    // List<Comment>? comments,
    int? reportCount,
    List<String>? shares,
    List<String>? likedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEdited,
    String? title,
  }) {
    return Post(
      title: title ?? this.title,
      id: id ?? this.id,
      user: user ?? this.user,
      text: text ?? this.text,
      visibility: visibility ?? this.visibility,
      likesCount: likesCount ?? this.likesCount,
      // comments: comments ?? this.comments,
      reportCount: reportCount ?? this.reportCount,
      shares: shares ?? this.shares,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEdited: isEdited ?? this.isEdited,
    );
  }

  // Métodos úteis
  bool isLikedByUser(String userId) => likedBy.contains(userId);
  bool isSharedByUser(String userId) => shares.contains(userId);

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ano${(difference.inDays / 365).floor() == 1 ? '' : 's'} atrás';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mês${(difference.inDays / 30).floor() == 1 ? '' : 'es'} atrás';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays == 1 ? '' : 's'} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours == 1 ? '' : 's'} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes == 1 ? '' : 's'} atrás';
    } else {
      return 'Agora mesmo';
    }
  }
}
