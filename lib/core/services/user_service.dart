import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/model/social/school_social.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'https://localhost:3000/';
  static final AuthDatabase _authDatabase = AuthDatabase();

  Future<PersonModel> getUserById(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/api/users/$id'));
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 'SUCCESS') {
        return PersonModel.fromJson(responseData['data']);
      }
      throw Exception(responseData['message']);
    } catch (e) {
      throw Exception('Falha ao buscar usuário: ${e.toString()}');
    }
  }

  Future<SchoolSocial> getSchoolById(String schoolId) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/api/schools/$schoolId'));
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 'SUCCESS') {
        return SchoolSocial.fromJson(responseData['data']);
      }
      throw Exception(responseData['message']);
    } catch (e) {
      throw Exception('Falha ao buscar escola: ${e.toString()}');
    }
  }

  Future<void> updateAbout(String userId, String aboutContent) async {
    String? token = await _authDatabase.getToken();
    if (token == null) {
      throw Exception('User not authenticated');
    }

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/api/user/edit/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'aboutContent': aboutContent}),
      );
      print(response.body);
      if (response.statusCode != 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        throw Exception(responseData['message']);
      }
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }

  Future<void> updateUserTags(String userId, List<String> tags) async {
    try {
      String? token = await _authDatabase.getToken();
      if (token == null) {
        throw Exception('Usuário não autenticado');
      }
      if (tags.length > 3) {
        throw Exception('Número máximo de tags é 3');
      }

      final response = await http.patch(
        Uri.parse('$_baseUrl/api/user/edit/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({'tags': tags}),
      );

      if (response.statusCode != 200) {
        final responseData = jsonDecode(response.body);
        throw Exception(responseData['message']);
      }
    } catch (e) {
      throw Exception('Falha ao atualizar tags: ${e.toString()}');
    }
  }
}
