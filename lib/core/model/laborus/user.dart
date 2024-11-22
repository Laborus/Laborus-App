class User {
  final String id;
  final String name;
  final String? profileImage;
  final String? course;
  final String? school;
  User({
    required this.id,
    required this.name,
    this.profileImage,
    this.course,
    this.school,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['photo'],
      course: json['course'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'photo': profileImage,
      'course': course,
      'school': school,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? profileImage,
    String? course,
    String? school,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      course: course ?? this.course,
      school: school ?? this.school,
    );
  }
}
