import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:laborus_app/core/data/auth_database.dart';
import 'dart:convert';

import 'package:laborus_app/core/model/responses/connecttion_request.dart';
import 'package:laborus_app/core/model/responses/user_request_model.dart';
import 'package:laborus_app/core/model/users/person_model.dart';

class ConnectionRequestProvider with ChangeNotifier {
  static String baseUrl = dotenv.env['API_URL']!;
  final AuthDatabase _authDatabase = AuthDatabase();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authDatabase.getToken();
    print('🔐 Obtendo headers...');
    print('🔑 Token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  List<ConnectionRequestModel> _pendingRequests = [];
  bool _isLoading = false;
  String? _error;

  List<ConnectionRequestModel> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPendingConnections() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final url = Uri.parse('$baseUrl/api/connections/pending');
    try {
      final userId = await _authDatabase.getUserId();
      final headers = await _getHeaders();
      final response = await http.post(url,
          headers: headers, body: json.encode({'receiverId': userId}));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        _pendingRequests =
            data.map((e) => ConnectionRequestModel.fromJson(e)).toList();
      } else {
        _handleError(response);
      }
    } catch (e) {
      _error = 'Ocorreu um erro ao buscar conexões: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleError(http.Response response) {
    final Map<String, dynamic> errorBody = jsonDecode(response.body);
    _error = errorBody['message'] ?? 'Erro desconhecido.';
    notifyListeners();
  }

  Future<bool> respondToConnectionRequest(
      String requestId, String action) async {
    try {
      final url = Uri.parse('$baseUrl/api/connections/respond');
      final headers = await _getHeaders();
      final body = json.encode({'requestId': requestId, 'action': action});

      print('📤 Sending response request to: $url');
      print('📋 Request Body: $body');

      final response = await http.post(url, headers: headers, body: body);

      print('📥 Response Status Code: ${response.statusCode}');
      print('📃 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Remove the request from the list
        _pendingRequests.removeWhere((request) => request.id == requestId);
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to respond to connection request: ${response.body}';
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('💥 Respond Request Error: $e');
      _error = 'Error responding to connection request: $e';
      notifyListeners();
      return false;
    }
  }

  // Helper method to get additional user details if needed
  Future<PersonModel?> getUserDetails(String userId) async {
    try {
      final url = Uri.parse('$baseUrl/api/users/$userId');
      print('🔍 Fetching User Details: $url');

      final response = await http.get(url);

      print('📥 User Details Response Status: ${response.statusCode}');
      print('📃 User Details Response Body: ${response.body}');

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      print('🔍 User Details Response Data Type: ${responseData.runtimeType}');
      print('🔍 User Details Response Keys: ${responseData.keys}');

      if (responseData['status'] == 'SUCCESS') {
        return PersonModel.fromJson(responseData['data']);
      }

      print('❌ Failed to fetch user details');
      return null;
    } catch (e) {
      print('💥 User Details Fetch Error: $e');
      return null;
    }
  }
}
