// lib/core/services/post_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/model/laborus/comments.dart';
import 'package:laborus_app/core/model/laborus/post.dart';

class PostService {
  final String _baseUrl = dotenv.env['API_URL']!;
  final AuthDatabase _authDatabase = AuthDatabase();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authDatabase.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Buscar posts globais
  Future<List<Post>> getGlobalPosts() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/api/posts/global'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        print('Falha ao carregar posts globais: ${response.body}');
        throw Exception(
            'Falha ao carregar posts globais: ${response.statusCode}');
      }
    } catch (e) {
      print('Falha ao carregar posts globais: $e');

      throw Exception('Erro ao buscar posts globais: $e');
    }
  }

  Future<List<Post>> getPostCampus(String idSchool) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/api/posts/campus/$idSchool',
        ), // URL com o ID da escola
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        print('Falha ao carregar posts do campus: ${response.body}');
        throw Exception(
            'Falha ao carregar posts do campus: ${response.statusCode}');
      }
    } catch (e) {
      print('Falha ao carregar posts do campus: $e');
      throw Exception('Erro ao buscar posts do campus: $e');
    }
  }

  Future<List<Post>> getPostsByUserId(String idUser) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/api/post/user/$idUser',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        print('Falha ao carregar posts do campus: ${response.body}');
        throw Exception(
            'Falha ao carregar posts do campus: ${response.statusCode}');
      }
    } catch (e) {
      print('Falha ao carregar posts do campus: $e');
      throw Exception('Erro ao buscar posts do campus: $e');
    }
  }

  Future<Post> createGlobalPost(Post post) async {
    return createPost(post, url: '$_baseUrl/api/post');
  }

  Future<Post> createCampusPost(Post post, String campusId) async {
    return createPost(post, url: '$_baseUrl/api/post/$campusId');
  }

  Future<Post> createPost(Post post, {required String url}) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(post.toJson()),
      );

      if (response.statusCode == 201) {
        print('Post criado com sucesso');
        return Post.fromJson(json.decode(response.body));
      } else {
        print(response.body);

        throw Exception('Falha ao criar post: ${response.statusCode}');
      }
    } catch (e) {
      print(e);

      throw Exception('Erro ao criar post: $e');
    }
  }

  // Buscar post por ID
  Future<Post> getPostById(String postId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/posts/$postId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao buscar post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar post: $e');
    }
  }

  // Curtir/Descurtir post
  Future<void> toggleLikePost(String postId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/posts/$postId/like'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Falha ao curtir/descurtir post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao curtir/descurtir post: $e');
    }
  }

  // Adicionar comentário
  Future<Comment> addComment(String postId, String content) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/posts/$postId/comments'),
        headers: headers,
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 201) {
        return Comment.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Falha ao adicionar comentário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao adicionar comentário: $e');
    }
  }

  // Compartilhar post
  Future<void> sharePost(String postId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/posts/$postId/share'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao compartilhar post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao compartilhar post: $e');
    }
  }

  // Salvar post
  Future<void> savePost(String postId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/posts/$postId/save'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao salvar post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao salvar post: $e');
    }
  }

  // Reportar post
  Future<void> reportPost(String postId, String reason) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl/posts/$postId/report'),
        headers: headers,
        body: json.encode({'reason': reason}),
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao reportar post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao reportar post: $e');
    }
  }

  // Deletar post
  Future<void> deletePost(String postId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$_baseUrl/posts/$postId'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Falha ao deletar post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar post: $e');
    }
  }

  // Buscar posts por usuário
  Future<List<Post>> getUserPosts(String userId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl/posts/user/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception(
            'Falha ao carregar posts do usuário: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar posts do usuário: $e');
    }
  }

  // Atualizar post
  Future<Post> updatePost(String postId, Map<String, dynamic> updates) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('$_baseUrl/posts/$postId'),
        headers: headers,
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Falha ao atualizar post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar post: $e');
    }
  }
}
