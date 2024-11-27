import 'package:flutter/material.dart';
import 'package:laborus_app/core/data/auth_database.dart';
import 'package:laborus_app/core/model/social/discussion.dart';
import 'package:laborus_app/core/services/school_service.dart';

class DiscussionProvider extends ChangeNotifier {
  final SchoolService _userService;
  final AuthDatabase _authDatabase;

  bool _isLoading = false;
  String? _error;

  List<Discussion> _discussions = [];
  Discussion? _currentDiscussion;

  DiscussionProvider(this._userService, this._authDatabase);

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Discussion> get discussions => _discussions;
  Discussion? get currentDiscussion => _currentDiscussion;
  bool get hasDiscussions => _discussions.isNotEmpty;

  // Fetch Discussions
  Future<void> fetchDiscussions(String schoolId,
      {bool isRefresh = false}) async {
    try {
      // Only set loading state if it's not a refresh or the list is empty
      if (!isRefresh || _discussions.isEmpty) {
        _setLoadingState(true);
      }

      // Clear previous error
      _clearError();

      final fetchedDiscussions =
          await _userService.getDiscussionsBySchoolId(schoolId);

      if (fetchedDiscussions.isEmpty) {
        // Set an informative message for empty list
        _setError('Nenhuma discussão encontrada');
      }

      _discussions = fetchedDiscussions;
      notifyListeners();
    } catch (e) {
      // Provide a more detailed error message
      _setError('Falha ao buscar discussões: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Fetch Discussion Details
  Future<void> fetchDiscussionDetails(
      String schoolId, String discussionId) async {
    try {
      _setLoadingState(true);
      _clearError();

      final discussion =
          await _userService.fetchDiscussionDetails(schoolId, discussionId);

      _currentDiscussion = discussion;
      notifyListeners();
    } catch (e) {
      _setError('Falha ao buscar detalhes da discussão: ${e.toString()}');
    } finally {
      _setLoadingState(false);
    }
  }

  // Refresh All Discussions
  Future<void> refreshDiscussions(String schoolId) async {
    try {
      await fetchDiscussions(schoolId, isRefresh: true);
    } catch (e) {
      _setError('Erro ao atualizar discussões: ${e.toString()}');
    }
  }

  // Internal State Management Methods
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
