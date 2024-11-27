import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:laborus_app/core/data/auth_database.dart';
import 'dart:convert';

import 'package:laborus_app/core/model/users/person_model.dart';

class StudentsService {
  static String baseUrl = dotenv.env['API_URL']!;
  final AuthDatabase _authDatabase = AuthDatabase();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authDatabase.getToken();
    print('Obtendo headers...');
    print('Token: $token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<PersonModel>> getStudents() async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/api/students');
      print('Fazendo requisição GET para: $url');
      print('Headers: $headers');

      final response = await http.get(url, headers: headers);
      print('Resposta recebida. Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Acessando a lista de estudantes dentro do objeto 'data'
        final Map<String, dynamic> data = responseData['data'];
        final List<dynamic> students = data['students'];

        print('Estudantes carregados: ${students.length}');
        return students.map((json) => PersonModel.fromJson(json)).toList();
      } else {
        print('Erro ao carregar estudantes. Status: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception('Failed to load students');
      }
    } catch (e) {
      print('Erro no método getStudents: $e');
      throw Exception('Error fetching students: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPendingConnections(
      {String? senderId, String? receiverId}) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/api/connections/pending');
      final body = json.encode({
        if (senderId != null) 'senderId': senderId,
        if (receiverId != null) 'receiverId': receiverId,
      });

      print('Fazendo requisição POST para: $url');
      print('Headers: $headers');
      print('Body: $body');

      final response = await http.post(url, headers: headers, body: body);
      print('Resposta recebida. Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final pendingConnections = responseData['data'] ?? [];

        print('Conexões pendentes carregadas: ${pendingConnections.length}');
        return List<Map<String, dynamic>>.from(pendingConnections);
      } else {
        print(
            'Erro ao carregar conexões pendentes. Status: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception('Failed to load pending connections');
      }
    } catch (e) {
      print('Erro no método getPendingConnections: $e');
      throw Exception('Error fetching pending connections: $e');
    }
  }

  Future<void> sendConnectionRequest(String receiverId) async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/api/connections/request');
      final body = json.encode({'receiverId': receiverId});

      print('Fazendo requisição POST para: $url');
      print('Headers: $headers');
      print('Body: $body');

      final response = await http.post(url, headers: headers, body: body);
      print('Resposta recebida. Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode != 201) {
        final error = json.decode(response.body);
        print('Erro ao enviar solicitação de conexão: $error');
        throw Exception(
            error['message'] ?? 'Failed to send connection request');
      } else {
        print('Solicitação de conexão enviada com sucesso!');
      }
    } catch (e) {
      print('Erro no método sendConnectionRequest: $e');
      throw Exception('Error sending connection request: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserConnections() async {
    try {
      final headers = await _getHeaders();
      final url = Uri.parse('$baseUrl/api/connections');

      print('Fazendo requisição GET para: $url');
      print('Headers: $headers');

      final response = await http.get(url, headers: headers);
      print('Resposta recebida. Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final connections = responseData['connections'] ?? [];

        print('Conexões carregadas: ${connections.length}');
        return List<Map<String, dynamic>>.from(connections);
      } else {
        print('Erro ao carregar conexões. Status: ${response.statusCode}');
        print('Body: ${response.body}');
        throw Exception('Failed to load user connections');
      }
    } catch (e) {
      print('Erro no método getUserConnections: $e');
      throw Exception('Error fetching user connections: $e');
    }
  }
}
