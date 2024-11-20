import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/exceptions/auth_exception.dart';
import 'package:laborus_app/core/providers/user_provider.dart';
import 'package:laborus_app/core/services/auth_services.dart';
import 'package:laborus_app/core/services/user_service.dart';

class SigninProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final AuthDatabase _authDatabase = AuthDatabase();
  final UserProvider _userProvider =
      UserProvider(UserService(), AuthDatabase());

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> signIn(String email, String password) async {
    try {
      _error = null;
      _isLoading = true;
      notifyListeners();

      // Get the token from sign-in
      final token = await _authService.signIn(email, password);

      // Validate the token
      final isValidToken = await _authDatabase.validateToken(token: token);
      if (!isValidToken) {
        _error = 'Token inválido';
        return false;
      }

      // Update user information
      await _userProvider.initializeUser();

      return true;
    } on AuthException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Ocorreu um erro inesperado';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
