class UserRequestModel {
  final String id;
  final String name;
  final String email;
  final String school;

  UserRequestModel({
    required this.id,
    required this.name,
    required this.email,
    required this.school,
  });

  factory UserRequestModel.fromJson(Map<String, dynamic> json) {
    return UserRequestModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      school: json['school'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'school': school,
    };
  }
}
