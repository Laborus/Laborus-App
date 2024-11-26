import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/model/social/discussion.dart';
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

  Future<List<Discussion>> getDiscussionsBySchoolId(String schoolId) async {
    try {
      print('🔍 Fetching discussions for school ID: $schoolId');

      String? token = await _authDatabase.getToken();
      print('🔑 Token retrieved: ${token != null}');

      final response = await http.get(
        Uri.parse('$_baseUrl/api/$schoolId/discussions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      print('📡 Response status code: ${response.statusCode}');
      print('📡 Response status code: ${response.body}');

      final Map responseData = jsonDecode(response.body);

      if (responseData['success'] == true) {
        final List discussionsData = responseData['discussions'];
        print(
            '✅ Discussions fetched successfully: ${discussionsData.length} discussions');

        return discussionsData
            .map((json) => Discussion.fromJson(json))
            .toList();
      }

      print('❌ Failed to fetch discussions: ${responseData['message']}');
      throw Exception(responseData['message']);
    } catch (e) {
      print('🚨 Error in getDiscussionsBySchoolId: ${e.toString()}');
      throw Exception('Falha ao buscar discussões: ${e.toString()}');
    }
  }

  Future<Discussion> createDiscussion(
      {required String schoolId,
      required String title,
      required String description}) async {
    try {
      print('🚀 Attempting to create discussion');
      print('🏫 School ID: $schoolId');
      print('📝 Title: $title');
      print('📄 Description: $description');

      String? token = await _authDatabase.getToken();
      print('🔑 Token retrieved: ${token != null}');

      final response = await http.post(
        Uri.parse('$_baseUrl/api/$schoolId/discussion'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );

      print('📡 Response status code: ${response.statusCode}');

      final Map responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || responseData['success'] == true) {
        print('✅ Discussion created successfully');
        return Discussion.fromJson(responseData['discussion']);
      }

      print('❌ Failed to create discussion: ${responseData['message']}');
      throw Exception(responseData['message']);
    } catch (e) {
      print('🚨 Error in createDiscussion: ${e.toString()}');
      throw Exception('Falha ao criar discussão: ${e.toString()}');
    }
  }

  Future<DiscussionComment> addComment(
      String campusId, String discussionId, String textContent) async {
    String? token = await _authDatabase.getToken();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/discussions/$campusId/$discussionId/comments'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'textContent': textContent}),
      );

      if (response.statusCode == 201) {
        return DiscussionComment.fromJson(
            json.decode(response.body)['comment']);
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Discussion> closeDiscussion(
      String campusId, String discussionId, String commentId) async {
    String? token = await _authDatabase.getToken();

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/discussions/$campusId/$discussionId/close'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'commentId': commentId}),
      );

      if (response.statusCode == 200) {
        return Discussion.fromJson(json.decode(response.body)['discussion']);
      } else {
        throw Exception('Failed to close discussion');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Discussion> fetchDiscussionDetails(
      String campusId, String discussionId) async {
    try {
      String? token = await _authDatabase.getToken();

      final response = await http.get(
        Uri.parse('$_baseUrl/discussions/$campusId/$discussionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return Discussion.fromJson(json.decode(response.body)['discussion']);
      } else {
        throw Exception('Failed to load discussion details');
      }
    } catch (e) {
      rethrow;
    }
  }
}
