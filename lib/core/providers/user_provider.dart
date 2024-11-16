import 'package:flutter/material.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService;
  final AuthDatabase _authDatabase;

  bool _isLoading = false;
  String? _error;
  PersonModel? _user;

  UserProvider(this._userService, this._authDatabase);

  bool get isLoading => _isLoading;
  String? get error => _error;
  PersonModel? get user => _user;

  /// Inicializa os dados do usuário ao carregar a aplicação
  Future<void> initializeUser() async {
    try {
      _setLoadingState(true);
      final userId = await _authDatabase.getUserId();
      if (userId == null) {
        _setLoadingState(false);
        return;
      }

      final user = await _userService.getUserById(userId);
      _setUser(user);
      print(user.profileImage);
    } catch (e) {
      _setError('Falha ao buscar usuário: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  /// Atualiza as tags do usuário
  Future<void> updateUserTags(List<String> tags) async {
    try {
      _setLoadingState(true);
      final userId = await _authDatabase.getUserId();
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _userService.updateUserTags(userId, tags);

      // Atualiza o estado local do usuário
      if (_user != null) {
        _user = _user!.copyWith(tags: tags);
        notifyListeners();
      }
    } catch (e) {
      _setError('Falha ao atualizar tags: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  /// Define o estado de carregamento
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  /// Define o estado do usuário
  void _setUser(PersonModel user) {
    _user = user;
    notifyListeners();
  }

  /// Define o estado de erro
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
