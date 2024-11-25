import 'package:flutter/material.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/model/social/alert.dart';
import 'package:laborus_app/core/model/social/school_social.dart';
import 'package:laborus_app/core/services/school_service.dart';

class SchoolProvider extends ChangeNotifier {
  final SchoolService _userService;
  final AuthDatabase _authDatabase;

  bool _isLoading = false;
  String? _error;
  SchoolSocial? _school;

  SchoolProvider(this._userService, this._authDatabase);

  bool get isLoading => _isLoading;
  String? get error => _error;
  SchoolSocial? get school => _school;
  List<Alert> _alerts = [];
  List<Alert> get alerts => _alerts;

  Future<void> fetchAlerts(String schoolId) async {
    try {
      _setLoadingState(true);
      final fetchedAlerts = await _userService.getAlertsBySchoolId(schoolId);
      _alerts = fetchedAlerts;
      notifyListeners();
    } catch (e) {
      _setError('Falha ao buscar alertas: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> initializeSchool(String schoolId) async {
    try {
      _setLoadingState(true);
      final school = await _userService.getSchoolById(schoolId);
      _setSchool(school);
    } catch (e) {
      _setError('Falha ao buscar escola: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> refreshSchool(String schoolId) async {
    try {
      final updatedSchool = await _userService.getSchoolById(schoolId);
      _setSchool(updatedSchool);
      debugPrint('Escola atualizada: ${updatedSchool.name}');
    } catch (e) {
      debugPrint('Erro ao atualizar escola: $e');
    }
  }

  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setSchool(SchoolSocial school) {
    _school = school;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
