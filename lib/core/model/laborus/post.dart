import 'package:laborus_app/core/model/laborus/comments.dart';
import 'package:laborus_app/core/model/laborus/user.dart';

class Post {
  final String? id;
  final User user;
  final String title;
  final String text;
  final String media;
  final String visibility;
  int likesCount; // Agora mutável para refletir alterações locais
  final List<Comment>? comments;
  final List<String>? likedUsers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool commentsEnabled;
  final bool isEdited;

  Post({
    this.id,
    required this.title,
    required this.user,
    required this.text,
    this.commentsEnabled = true,
    this.media = '',
    required this.visibility,
    this.likesCount = 0,
    this.likedUsers,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.isEdited = false,
  });

  /// Factory para criar o Post a partir de JSON.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      user: json['postedBy'] is Map
          ? User.fromJson(json['postedBy'])
          : User(id: json['postedBy'] ?? '', name: 'Usuário Desconhecido'),
      text: json['textContent'] ?? '',
      media: json['image'] ?? '',
      visibility: json['postedOn'] ?? 'Global',
      likesCount: json['likes']?.length ?? 0,
      commentsEnabled: json['commentsEnabled'] ?? true,
      comments: (json['comments'] as List?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ??
          [],
      likedUsers:
          (json['likes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isEdited: json['isEdited'] ?? false,
    );
  }

  /// Método para converter o Post em JSON para envio de dados.
  Map<String, dynamic> toJson() {
    return {
      'textContent': text,
      'image': media,
      'title': title,
      'postedOn': visibility,
      'isEdited': isEdited,
      'commentsEnabled': commentsEnabled,
    };
  }

  /// Método para criar uma cópia do Post com valores alterados.
  Post copyWith({
    String? id,
    User? user,
    String? text,
    String? visibility,
    List<Comment>? comments,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEdited,
    String? title,
    int? likesCount,
    List<String>? likedUsers,
  }) {
    return Post(
      title: title ?? this.title,
      id: id ?? this.id,
      user: user ?? this.user,
      text: text ?? this.text,
      visibility: visibility ?? this.visibility,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEdited: isEdited ?? this.isEdited,
      likesCount: likesCount ?? this.likesCount,
      likedUsers: likedUsers ?? this.likedUsers,
    );
  }

  /// Verifica se o usuário curtiu o post.
  bool isLikedByUser(String userId) => likedUsers?.contains(userId) ?? false;

  /// Adiciona um like ao Post.
  void addLike(String userId) {
    if (!likedUsers!.contains(userId)) likedUsers?.add(userId);
  }

  /// Remove um like do Post.
  void removeLike(String userId) {
    likedUsers?.remove(userId);
  }

  /// Calcula o tempo desde a criação do post em formato legível.
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
