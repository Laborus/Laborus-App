class UserModel {
  final String name;
  final String email;
  final String password;
  final String cpf;
  final String school;
  final String course;
  final String? profileImage;
  final String? bannerImage;
  final String aboutContent;
  final String accountType;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.cpf,
    required this.school,
    required this.course,
    this.profileImage,
    this.bannerImage,
    required this.aboutContent,
    this.accountType = 'Student',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'cpf': cpf,
      'school': school,
      'course': course,
      'profileImage': '',
      'bannerImage': '',
      'aboutContent': aboutContent,
      'accountType': accountType,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
    String? cpf,
    String? school,
    String? course,
    String? profileImage,
    String? bannerImage,
    String? aboutContent,
    String? accountType,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      cpf: cpf ?? this.cpf,
      school: school ?? this.school,
      course: course ?? this.course,
      profileImage: profileImage ?? this.profileImage,
      bannerImage: bannerImage ?? this.bannerImage,
      aboutContent: aboutContent ?? this.aboutContent,
      accountType: accountType ?? this.accountType,
    );
  }
}
