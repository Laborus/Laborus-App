class PersonModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String cpf;
  final String schoolId;
  final String? school;
  final String course;
  final List<String> tags;
  final List<String> connections;
  final String profileImage;
  final String bannerImage;
  final String accountStatus;
  final String? aboutContent;
  final bool isOnline;
  final List<String> saved;
  final List<String> following;
  final List<String> inbox;

  PersonModel({
    this.aboutContent,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.cpf,
    required this.schoolId,
    required this.course,
    this.tags = const [],
    this.connections = const [],
    this.school = 'nao carregou',
    required this.profileImage,
    required this.bannerImage,
    required this.accountStatus,
    required this.isOnline,
    this.saved = const [],
    this.following = const [],
    this.inbox = const [],
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      cpf: json['cpf'],
      schoolId: json['school'],
      school: json['schoolName'],
      course: json['course'],
      aboutContent: json['aboutContent'],
      tags: List<String>.from(json['tags'] ?? []),
      connections: List<String>.from(json['connections'] ?? []),
      profileImage: json['profileImage'],
      bannerImage: json['bannerImage'],
      accountStatus: json['accountStatus'],
      isOnline: json['isOnline'],
      saved: List<String>.from(json['saved'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      inbox: List<String>.from(json['inbox'] ?? []),
    );
  }

  PersonModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? cpf,
    String? schoolId,
    String? school,
    String? course,
    List<String>? tags,
    List<String>? connections,
    String? profileImage,
    String? bannerImage,
    String? accountStatus,
    String? aboutContent,
    bool? isOnline,
    List<String>? saved,
    List<String>? following,
    List<String>? inbox,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      cpf: cpf ?? this.cpf,
      schoolId: schoolId ?? this.schoolId,
      school: school ?? this.school,
      course: course ?? this.course,
      tags: tags ?? this.tags,
      aboutContent: aboutContent ?? this.aboutContent,
      connections: connections ?? this.connections,
      profileImage: profileImage ?? this.profileImage,
      bannerImage: bannerImage ?? this.bannerImage,
      accountStatus: accountStatus ?? this.accountStatus,
      isOnline: isOnline ?? this.isOnline,
      saved: saved ?? this.saved,
      following: following ?? this.following,
      inbox: inbox ?? this.inbox,
    );
  }
}
