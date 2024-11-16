import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'https://localhost:3000/';

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

  Future<void> updateUserTags(String userId, List<String> tags) async {
    try {
      if (tags.length > 3) {
        throw Exception('Número máximo de tags é 3');
      }

      final response = await http.patch(
        Uri.parse('$_baseUrl/api/users/$userId'),
        headers: {'Content-Type': 'application/json'},
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
