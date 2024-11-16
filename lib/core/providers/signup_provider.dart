import 'package:flutter/material.dart';
import 'package:laborus_app/core/exceptions/signup_exception.dart';
import 'package:laborus_app/core/model/users/school_model.dart';
import 'package:laborus_app/core/model/users/user_model.dart';
import 'package:laborus_app/core/services/auth_services.dart';

class SignupProvider with ChangeNotifier {
  final AuthService _apiService = AuthService();

  // Initialize empty user model
  UserModel _user = UserModel(
    name: '',
    email: '',
    password: '',
    cpf: '',
    school: '',
    course: '',
    aboutContent: '',
  );

  bool _isLoading = false;
  String? _loadingMessage;
  Map _errors = {};
  String _confirmPassword = '';

  // Getters
  UserModel get user => _user;
  bool get isLoading => _isLoading;
  String? get loadingMessage => _loadingMessage;
  Map get errors => _errors;
  String get name => _user.name;
  String get email => _user.email;
  String get password => _user.password;
  String get cpf => _user.cpf;
  String get school => _user.school;
  String get course => _user.course;
  String get aboutContent => _user.aboutContent;
  String get confirmPassword => _confirmPassword;

  // Setters
  void setName(String value) {
    _user = _user.copyWith(name: value);
    _errors.remove('name');
    notifyListeners();
  }

  void setEmail(String value) {
    _user = _user.copyWith(email: value);
    _errors.remove('email');
    notifyListeners();
  }

  void setPassword(String value) {
    _user = _user.copyWith(password: value);
    _errors.remove('password');
    notifyListeners();
  }

  void setCpf(String value) {
    _user = _user.copyWith(cpf: value);
    _errors.remove('cpf');
    notifyListeners();
  }

  void setSchool(String value) {
    _user = _user.copyWith(school: value);
    _errors.remove('school');
    notifyListeners();
  }

  void setCourse(String value) {
    _user = _user.copyWith(course: value);
    _errors.remove('course');
    notifyListeners();
  }

  void setAboutContent(String value) {
    _user = _user.copyWith(aboutContent: value);
    _errors.remove('about');
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _errors.remove('confirmPassword');
    notifyListeners();
  }

  // Validation methods remain the same but use _user directly
  bool validateDetailsStep() {
    _errors = {};
    bool isValid = true;

    if (_user.name.isEmpty) {
      _errors['name'] = 'Nome é obrigatório';
      isValid = false;
    }

    if (_user.email.isEmpty) {
      _errors['email'] = 'Email é obrigatório';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_user.email)) {
      _errors['email'] = 'Email inválido';
      isValid = false;
    }

    if (_user.cpf.isEmpty) {
      _errors['cpf'] = 'CPF é obrigatório';
      isValid = false;
    }

    if (_user.password.isEmpty) {
      _errors['password'] = 'Senha é obrigatória';
      isValid = false;
    } else if (_user.password.length < 6) {
      _errors['password'] = 'Senha deve ter no mínimo 6 caracteres';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  bool validateInstitutionStep() {
    _errors = {};
    bool isValid = true;

    if (_user.school.isEmpty) {
      _errors['school'] = 'Selecione uma instituição';
      isValid = false;
    }

    if (_user.course.isEmpty) {
      _errors['course'] = 'Selecione um curso';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  void reset() {
    _user = UserModel(
      name: '',
      email: '',
      password: '',
      cpf: '',
      school: '',
      course: '',
      aboutContent: '',
    );
    _confirmPassword = '';
    _errors = {};
    _isLoading = false;
    _loadingMessage = null;
    notifyListeners();
  }

  // API methods remain mostly the same but use _user directly
  Future<bool> signup() async {
    try {
      if (!validateDetailsStep() || !validateInstitutionStep()) {
        return false;
      }

      _isLoading = true;
      _loadingMessage = 'Criando conta...';
      notifyListeners();

      await _apiService.signup(_user);
      reset();
      return true;
    } on SignupException catch (e) {
      _errors['submit'] = e.message;
      return false;
    } catch (e) {
      _errors['submit'] = 'Erro inesperado ao criar conta: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      _loadingMessage = null;
      notifyListeners();
    }
  }

  Future<List<SchoolModel>> getSchools() async {
    try {
      final schools = await _apiService.getSchools();
      return schools;
    } catch (e) {
      throw Exception('Falha ao carregar instituições: ${e.toString()}');
    }
  }
}
