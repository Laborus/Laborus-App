import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/social/discussion.dart';
import 'package:laborus_app/core/services/school_service.dart';
import 'package:laborus_app/core/data/auth_database.dart';

class DiscussionProvider extends ChangeNotifier {
  final SchoolService _schoolService;
  final AuthDatabase _authDatabase;

  DiscussionProvider(this._schoolService, this._authDatabase);

  // State variables
  bool _isLoading = false;
  String? _error;
  List<Discussion> _discussions = [];
  Discussion? _currentDiscussion;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Discussion> get discussions => _discussions;
  Discussion? get currentDiscussion => _currentDiscussion;

  // Fetch discussions for a specific campus/school
  Future<void> fetchDiscussions(String campusId) async {
    try {
      _setLoadingState(true);
      _clearError();

      _discussions = await _schoolService.getDiscussionsBySchoolId(campusId);
      notifyListeners();
    } catch (e) {
      _setError('Falha ao buscar discussões: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Fetch details of a specific discussion
  Future<void> fetchDiscussionDetails(
      String campusId, String discussionId) async {
    try {
      _setLoadingState(true);
      _clearError();

      _currentDiscussion =
          await _schoolService.fetchDiscussionDetails(campusId, discussionId);
      notifyListeners();
    } catch (e) {
      _setError('Falha ao buscar detalhes da discussão: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Add a comment to a discussion
  Future<void> addComment(
      String campusId, String discussionId, String textContent) async {
    try {
      _setLoadingState(true);
      _clearError();

      final comment =
          await _schoolService.addComment(campusId, discussionId, textContent);

      // Update the current discussion's comments
      if (_currentDiscussion != null) {
        final updatedComments =
            List<DiscussionComment>.from(_currentDiscussion!.comments)
              ..add(comment);

        _currentDiscussion = Discussion(
          id: _currentDiscussion!.id,
          title: _currentDiscussion!.title,
          description: _currentDiscussion!.description,
          postedBy: _currentDiscussion!.postedBy,
          campusId: _currentDiscussion!.campusId,
          commentsEnabled: _currentDiscussion!.commentsEnabled,
          isClosed: _currentDiscussion!.isClosed,
          comments: updatedComments,
          createdAt: _currentDiscussion!.createdAt,
          likesCount: _currentDiscussion!.likesCount,
          dislikesCount: _currentDiscussion!.dislikesCount,
        );
      }
      notifyListeners();
    } catch (e) {
      _setError('Falha ao adicionar comentário: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Close a discussion
  Future<void> closeDiscussion(
      String campusId, String discussionId, String commentId) async {
    try {
      _setLoadingState(true);
      _clearError();

      _currentDiscussion = await _schoolService.closeDiscussion(
          campusId, discussionId, commentId);
      notifyListeners();
    } catch (e) {
      _setError('Falha ao fechar discussão: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Clear current discussion
  void clearCurrentDiscussion() {
    _currentDiscussion = null;
    notifyListeners();
  }

  // Create a new discussion
  Future<void> createDiscussion(
      {required String schoolId,
      required String title,
      required String description}) async {
    try {
      _setLoadingState(true);
      _clearError();

      final newDiscussion = await _schoolService.createDiscussion(
        schoolId: schoolId,
        title: title,
        description: description,
      );

      // Add the new discussion to the top of the list
      _discussions.insert(0, newDiscussion);
      notifyListeners();
    } catch (e) {
      _setError('Falha ao criar discussão: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Helper methods
  void _setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
