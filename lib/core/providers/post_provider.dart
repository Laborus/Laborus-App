import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/laborus/comments.dart';
import 'package:laborus_app/core/model/laborus/post.dart';
import 'package:laborus_app/core/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService;
  bool _isLoading = false;
  String? _error;
  List<Post> _posts = [];
  List<Post> _postsCampus = [];
  List<Post> _userPosts = [];
  List<Comment> _comments = [];

  PostProvider(this._postService) {
    loadPosts();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Post> get posts => _posts;
  List<Post> get postsCampus => _postsCampus;
  List<Post> get userPosts => _userPosts;
  List<Comment> get comments => _comments;

  Future<void> loadPosts() async {
    try {
      _setLoadingState(true);
      final posts = await _postService.getGlobalPosts();
      _setPosts(posts);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadUserPosts(String userId) async {
    try {
      _setLoadingState(true);
      final post = await _postService.getPostsByUserId(userId);
      _setPostsByUserId(post);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadCampusPosts(String idSchool) async {
    try {
      _setLoadingState(true);
      final posts = await _postService.getPostCampus(idSchool);
      _setPostsCampus(posts);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> createPost(Post post, {String? campusId}) async {
    try {
      _setLoadingState(true);

      final newPost = campusId == null
          ? await _postService.createGlobalPost(post)
          : await _postService.createCampusPost(post, campusId);

      _posts.insert(0, newPost);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> loadComments(String postId) async {
    try {
      _setLoadingState(true);
      // Os comentários já estão associados ao post?
      final post = _posts.firstWhere((post) => post.id == postId);
      if (post == null) throw Exception("Post não encontrado.");
      _setComments(post.comments ?? []);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> addComment(String postId, String userId, String content) async {
    try {
      _setLoadingState(true);
      final newComment =
          await _postService.createComment(postId, userId, content);

      // Atualizar a lista de comentários local e também no post correspondente
      _comments.insert(0, newComment);
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex != -1) {
        _posts[postIndex].comments?.insert(0, newComment);
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoadingState(false);
    }
  }

  void clearComments() {
    _comments = [];
    notifyListeners();
  }

  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setPosts(List<Post> posts) {
    _posts = posts;
    notifyListeners();
  }

  void _setPostsCampus(List<Post> posts) {
    _postsCampus = posts;
    notifyListeners();
  }

  void _setPostsByUserId(List<Post> posts) {
    _userPosts = posts;
    notifyListeners();
  }

  void _setComments(List<Comment> comments) {
    _comments = comments;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
