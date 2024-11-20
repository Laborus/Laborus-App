import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthDatabase {
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'id';
  static final String _baseUrl =
      dotenv.env['API_URL'] ?? 'https://localhost:3000/';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<bool> validateToken({String? token}) async {
    token ??= await getToken();
    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/api/validate-token'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print("API response status: ${response.statusCode}");
        if (response.statusCode == 200) {
          final responseData =
              jsonDecode(response.body) as Map<String, dynamic>;
          print("Response data: $responseData");
          if (responseData['success'] == true) {
            final userId = responseData['user']['id'];
            saveUserId(userId);
            return true;
          } else {
            await clearAuthData();
            return false;
          }
        }
      } catch (e) {
        print("Error validating token: $e");
        await clearAuthData();
        return false;
      }
    }
    return false;
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  void saveUserId(userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }
}
