import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/model/social/alert.dart';
import 'package:laborus_app/core/model/social/school_social.dart';
import 'package:http/http.dart' as http;

class SchoolService {
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'https://localhost:3000/';
  static final AuthDatabase _authDatabase = AuthDatabase();

  Future<SchoolSocial> getSchoolById(String schoolId) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/api/users/$schoolId'));
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 'SUCCESS') {
        return SchoolSocial.fromJson(responseData['data']);
      }
      throw Exception(responseData['message']);
    } catch (e) {
      throw Exception('Falha ao buscar escola: ${e.toString()}');
    }
  }

  Future<List<Alert>> getAlertsBySchoolId(String schoolId) async {
    try {
      String? token = await _authDatabase.getToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/alerts/$schoolId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == 'SUCCESS') {
        final List<dynamic> alertsData = responseData['data'];
        return alertsData.map((json) => Alert.fromJson(json)).toList();
      }
      throw Exception(responseData['message']);
    } catch (e) {
      throw Exception('Falha ao buscar alertas: ${e.toString()}');
    }
  }
}
