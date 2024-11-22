import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/laborus/post.dart';
import 'package:laborus_app/core/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  final PostService _postService;
  bool _isLoading = false;
  String? _error;
  List<Post> _posts = [];
  List<Post> _postsCampus = [];
  List<Post> _userPosts = [];
  PostProvider(this._postService) {
    loadPosts();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Post> get posts => _posts;
  List<Post> get postsCampus => _postsCampus;
  List<Post> get userPosts => _userPosts;

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
    _isLoading = true;
    notifyListeners();

    try {
      final post = await _postService.getPostsByUserId(userId);
      _setPostsByUserId(post);
    } catch (e) {
      print(e);
      _userPosts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCampusPosts(String idSchool) async {
    try {
      _setLoadingState(true);
      final posts = await _postService.getPostCampus(idSchool);
      _setPostsCampus(posts);
    } catch (e) {
      print(e);
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

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }
}
