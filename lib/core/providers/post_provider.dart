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
    debugPrint('Starting loadPosts');
    try {
      debugPrint('Clearing error and setting loading state');
      _error = null;
      _setLoadingState(true);

      debugPrint('Fetching posts from service');
      final posts = await _postService.getGlobalPosts();

      debugPrint('Posts fetched successfully: ${posts.length} posts');
      _setPosts(posts);
    } catch (e) {
      debugPrint('Error loading posts: $e');
      _setPosts([]);
      _setError(e.toString());
    } finally {
      debugPrint('Finishing loadPosts');
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

  Future<Post> createPost(Post post, {String? campusId}) async {
    try {
      _setLoadingState(true);

      final newPost = campusId == null
          ? await _postService.createGlobalPost(post)
          : await _postService.createCampusPost(post, campusId);

      _posts.insert(0, newPost);
      notifyListeners();

      return newPost;
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

      // Procura o post em todas as listas
      Post? post = _posts.firstWhere(
        (post) => post.id == postId,
        orElse: () => _postsCampus.firstWhere(
          (post) => post.id == postId,
          orElse: () => _userPosts.firstWhere(
            (post) => post.id == postId,
            orElse: () => throw Exception("Post não encontrado."),
          ),
        ),
      );

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

      // Atualiza o comentário em todas as listas onde o post existir
      void updatePostInList(List<Post> posts) {
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          posts[postIndex].comments?.insert(0, newComment);
        }
      }

      updatePostInList(_posts);
      updatePostInList(_postsCampus);
      updatePostInList(_userPosts);

      _setComments(comments);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoadingState(false);
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      // Procura o post em todas as listas e atualiza onde encontrar
      void updateLikeInList(List<Post> posts) {
        final postIndex = posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1 && !posts[postIndex].isLikedByUser(userId)) {
          _postService.likePost(postId);
          posts[postIndex].likesCount += 1;
          posts[postIndex].addLike(userId);
        }
      }

      bool postFound = false;
      if (_posts.any((post) => post.id == postId)) {
        updateLikeInList(_posts);
        postFound = true;
      }
      if (_postsCampus.any((post) => post.id == postId)) {
        updateLikeInList(_postsCampus);
        postFound = true;
      }
      if (_userPosts.any((post) => post.id == postId)) {
        updateLikeInList(_userPosts);
        postFound = true;
      }

      if (!postFound) {
        throw Exception("Post não encontrado.");
      }

      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
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
