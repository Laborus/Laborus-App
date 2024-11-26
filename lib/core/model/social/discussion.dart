class Discussion {
  final String id;
  final String title;
  final String description;
  final DiscussionAuthor postedBy;
  final String? postedByModel; // New field to track model type
  final String campusId;
  final bool commentsEnabled;
  final bool isClosed;
  final List<DiscussionComment> comments;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likesCount;
  final int dislikesCount;
  final String? selectedAnswer;
  final List<String>? sharedBy; // New field for shared discussions

  Discussion({
    required this.id,
    required this.title,
    required this.description,
    required this.postedBy,
    this.postedByModel, // Make optional
    required this.campusId,
    this.commentsEnabled = true,
    this.isClosed = false,
    this.comments = const [],
    required this.createdAt,
    this.updatedAt,
    this.likesCount = 0,
    this.dislikesCount = 0,
    this.selectedAnswer,
    this.sharedBy,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      id: json['_id'], // Changed from fallback to direct use
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      postedBy: DiscussionAuthor.fromJson({
        'id':
            '', // Add a default empty string since postedBy details are missing
        'name': '', // Add a default empty string
        'photo': json['postedBy']?['photo'],
        'school': json['postedBy']?['school'],
      }),
      postedByModel: json['postedByModel'],
      campusId: json['campusId'] ?? '',
      commentsEnabled: json['commentsEnabled'] ?? true,
      isClosed: json['isClosed'] ?? false,
      comments: json['comments'] != null
          ? (json['comments'] as List)
              .map((commentJson) => DiscussionComment.fromJson(commentJson))
              .toList()
          : [],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      likesCount: json['likes']?.length ?? 0,
      dislikesCount: json['dislikes']?.length ?? 0,
      selectedAnswer: json['selectedAnswer'],
      sharedBy:
          json['sharedBy'] != null ? List<String>.from(json['sharedBy']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'postedBy': postedBy.toJson(),
      'postedByModel': postedByModel,
      'campusId': campusId,
      'commentsEnabled': commentsEnabled,
      'isClosed': isClosed,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likesCount': likesCount,
      'dislikesCount': dislikesCount,
      'selectedAnswer': selectedAnswer,
      'sharedBy': sharedBy,
    };
  }
}

class DiscussionAuthor {
  final String id;
  final String name;
  final String? photo;
  final String? school;

  DiscussionAuthor({
    required this.id,
    required this.name,
    this.photo,
    this.school,
  });

  factory DiscussionAuthor.fromJson(Map<String, dynamic> json) {
    return DiscussionAuthor(
      id: json['id'] ?? json['_id'],
      name: json['name'],
      photo: json['photo'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'school': school,
    };
  }
}

class DiscussionComment {
  final String id;
  final String textContent;
  final DiscussionAuthor postedBy;
  final String? postedByModel; // New field to track model type
  final String? discussionId; // New field to link to discussion
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int? likesCount;
  final int? dislikesCount;

  DiscussionComment({
    required this.id,
    required this.textContent,
    required this.postedBy,
    this.postedByModel,
    this.discussionId,
    required this.createdAt,
    this.updatedAt,
    this.likesCount,
    this.dislikesCount,
  });

  factory DiscussionComment.fromJson(Map<String, dynamic> json) {
    return DiscussionComment(
      id: json['_id'] ?? json['id'] ?? '',
      textContent: json['textContent'] ?? '',
      postedBy: DiscussionAuthor.fromJson({
        'id':
            '', // Add a default empty string since postedBy details are missing
        'name': '', // Add a default empty string
        'photo': json['postedBy']?['photo'],
        'school': json['postedBy']?['school'],
      }),
      postedByModel: json['postedByModel'],
      discussionId: json['discussionId'],
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      likesCount: json['likes']?.length ?? 0,
      dislikesCount: json['dislikes']?.length ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'textContent': textContent,
      'postedBy': postedBy.toJson(),
      'postedByModel': postedByModel,
      'discussionId': discussionId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likesCount': likesCount,
      'dislikesCount': dislikesCount,
    };
  }
}
