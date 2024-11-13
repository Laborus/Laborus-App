// auth_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/exceptions/auth_exception.dart';
import 'package:laborus_app/core/model/responses/auth_response.dart';
import 'dart:async';

class AuthService {
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'https://laborus-backend-api.onrender.com/';

  final AuthDatabase _authDatabase = AuthDatabase();
  Timer? _tokenRefreshTimer;
  final _authStateController = StreamController<bool>.broadcast();

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email.trim(), 'password': password}),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(json.decode(response.body));
        if (authResponse.status == 'SUCCESS' &&
            authResponse.data['token'] != null) {
          final token = authResponse.data['token'];

          await _authDatabase.saveToken(token);
          await _authDatabase.saveUserData(authResponse.data);

          _authStateController.add(true);

          return {'success': true, 'userData': authResponse.data};
        }
      }

      throw AuthException(_parseErrorMessage(response));
    } on TimeoutException {
      throw AuthException(
          'Connection timeout. Please check your internet connection.');
    } catch (e) {
      throw AuthException('Failed to sign in: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    _tokenRefreshTimer?.cancel();
    await _authDatabase.clearAuthData();
    _authStateController.add(false);
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['message'] ?? 'Unknown error occurred';
    } catch (_) {
      return 'Failed to connect to server';
    }
  }

  Future<void> dispose() async {
    _tokenRefreshTimer?.cancel();
    await _authStateController.close();
  }
}
