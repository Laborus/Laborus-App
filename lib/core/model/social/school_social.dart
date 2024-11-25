class SchoolSocial {
  final String id;
  final String name;
  final String email;
  final String cnpj;
  final List<String> courses;
  final List<String> tags;
  final String profileImage;
  final String bannerImage;
  final String accountStatus;
  final bool isOnline;
  final String location;
  final List<String> saved;
  final List<String> following;
  final List<String> followers;
  final DateTime createdAt;
  final DateTime updatedAt;

  SchoolSocial({
    required this.id,
    required this.name,
    required this.email,
    required this.cnpj,
    required this.courses,
    required this.tags,
    required this.profileImage,
    required this.bannerImage,
    required this.accountStatus,
    required this.isOnline,
    required this.location,
    required this.saved,
    required this.following,
    required this.followers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SchoolSocial.fromJson(Map<String, dynamic> json) {
    return SchoolSocial(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      cnpj: json['cnpj'],
      courses: List<String>.from(json['courses']),
      tags: List<String>.from(json['tags']),
      profileImage: json['profileImage'],
      bannerImage: json['bannerImage'],
      accountStatus: json['accountStatus'],
      isOnline: json['isOnline'],
      location: json['location'] ?? '',
      saved: List<String>.from(json['saved']),
      following: List<String>.from(json['following']),
      followers: List<String>.from(json['followers']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'cnpj': cnpj,
      'courses': courses,
      'tags': tags,
      'profileImage': profileImage,
      'bannerImage': bannerImage,
      'accountStatus': accountStatus,
      'isOnline': isOnline,
      'location': location,
      'saved': saved,
      'following': following,
      'followers': followers,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  SchoolSocial copyWith({
    String? id,
    String? name,
    String? email,
    String? cnpj,
    List<String>? courses,
    List<String>? tags,
    String? profileImage,
    String? bannerImage,
    String? accountStatus,
    bool? isOnline,
    String? location,
    List<String>? saved,
    List<String>? following,
    List<String>? followers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SchoolSocial(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      cnpj: cnpj ?? this.cnpj,
      courses: courses ?? this.courses,
      tags: tags ?? this.tags,
      profileImage: profileImage ?? this.profileImage,
      bannerImage: bannerImage ?? this.bannerImage,
      accountStatus: accountStatus ?? this.accountStatus,
      isOnline: isOnline ?? this.isOnline,
      location: location ?? this.location,
      saved: saved ?? this.saved,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
