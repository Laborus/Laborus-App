import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/exceptions/auth_exception.dart';
import 'package:laborus_app/core/exceptions/signup_exception.dart';
import 'package:laborus_app/core/model/responses/auth_response.dart';
import 'dart:async';

import 'package:laborus_app/core/model/users/school_model.dart';
import 'package:laborus_app/core/model/users/user_model.dart';

class AuthService {
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'https://localhost:3000/';

  final AuthDatabase _authDatabase = AuthDatabase();

  Future<String> signIn(String email, String password) async {
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
          print(token);
          return token;
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

  Future<List<SchoolModel>> getSchools() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/schools'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = json.decode(response.body);

        // Acessa o caminho correto para a lista de escolas
        final Map<String, dynamic> data = decodedResponse['data'];
        final List<dynamic> schools = data['schools'];

        return schools
            .map((schoolData) => SchoolModel.fromJson(schoolData))
            .toList();
      } else {
        throw Exception('Falha ao carregar escolas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar escolas: $e');
      throw Exception('Erro ao carregar escolas: $e');
    }
  }

  Future<Map<String, dynamic>> signup(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(user.toJson()),
      );

      if (response.body.isEmpty) {
        throw SignupException(
          'Resposta vazia do servidor',
          code: 'EMPTY_RESPONSE',
        );
      }

      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(response.body);
      } catch (e) {
        if (_isHtmlResponse(response.body)) {
          throw SignupException(
            'Erro interno do servidor',
            code: 'SERVER_ERROR',
            details: {'statusCode': response.statusCode},
          );
        }
        throw SignupException(
          'Formato de resposta inválido',
          code: 'INVALID_RESPONSE',
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      }

      throw SignupException(
        responseData['message'] ?? 'Erro ao criar conta',
        code: responseData['code'] ?? 'UNKNOWN_ERROR',
        details: responseData['details'],
      );
    } on http.ClientException catch (e) {
      throw SignupException(
        'Erro de conexão',
        code: 'CONNECTION_ERROR',
        details: {'error': e.toString()},
      );
    } on TimeoutException {
      throw SignupException(
        'Tempo de conexão esgotado',
        code: 'TIMEOUT_ERROR',
      );
    } on SignupException {
      rethrow;
    } catch (e) {
      throw SignupException(
        'Erro inesperado',
        code: 'UNKNOWN_ERROR',
        details: {'error': e.toString()},
      );
    }
  }

  bool _isHtmlResponse(String body) {
    return body.toLowerCase().contains('<!doctype html>') ||
        body.toLowerCase().contains('<html');
  }

  Future<void> signOut() async {
    await _authDatabase.clearAuthData();
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = json.decode(response.body);
      return body['message'] ?? 'Unknown error occurred';
    } catch (_) {
      return 'Failed to connect to server';
    }
  }
}
