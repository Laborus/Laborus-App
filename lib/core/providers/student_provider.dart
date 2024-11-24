import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/services/student_service.dart';

class StudentsProvider with ChangeNotifier {
  final StudentsService _studentsService = StudentsService();
  List<PersonModel> _students = [];
  List<String> _connections = [];
  List<String> _pendingRequests = [];
  bool _isLoading = false;
  String? _error;

  List<PersonModel> get students => _students;
  List<String> get connections => _connections;
  List<String> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStudents() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final loadedStudents = await _studentsService.getStudents();
      final userConnections = await _studentsService.getUserConnections();

      _connections =
          userConnections.map((conn) => conn['_id'] as String).toList();

      // Filter out connected users and users with pending requests
      _students = loadedStudents.where((student) {
        final isConnected = _connections.contains(student.id);
        final isPending = _pendingRequests.contains(student.id);
        return !isConnected && !isPending;
      }).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendConnectionRequest(String receiverId) async {
    try {
      await _studentsService.sendConnectionRequest(receiverId);
      _removeStudentFromList(receiverId);
    } catch (e) {
      // Check for both "already sent" and "self request" errors
      if (e.toString().contains('Connection request already sent') ||
          e
              .toString()
              .contains('cannot send a connection request to yourself')) {
        // Remove the student in both cases
        _removeStudentFromList(receiverId);
        // Rethrow the error so the UI can show appropriate message
        rethrow;
      } else {
        // For other types of errors, just rethrow
        rethrow;
      }
    }
  }

  void _removeStudentFromList(String studentId) {
    if (!_pendingRequests.contains(studentId)) {
      _pendingRequests.add(studentId);
    }
    _students.removeWhere((student) => student.id == studentId);
    notifyListeners();
  }

  Future<void> processBatchConnections() async {
    await loadStudents();

    if (_students.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    List<String> failedIds = [];
    List<Future<void>> connectionFutures = [];

    // Create a future for each connection request
    for (final student in _students) {
      final future =
          _studentsService.sendConnectionRequest(student.id).then((_) {
        // On success, add to pending requests
        if (!_pendingRequests.contains(student.id)) {
          _pendingRequests.add(student.id);
        }
      }).catchError((error) {
        // Handle both "already sent" and "self request" errors as successful cases
        if (error.toString().contains('Connection request already sent') ||
            error
                .toString()
                .contains('cannot send a connection request to yourself')) {
          if (!_pendingRequests.contains(student.id)) {
            _pendingRequests.add(student.id);
          }
        } else {
          // For other errors, add to failed IDs
          failedIds.add(student.id);
        }
      });
      connectionFutures.add(future);
    }

    // Wait for all requests to complete
    await Future.wait(connectionFutures);

    // Remove all students except those that failed for reasons other than "already sent" or "self request"
    _students =
        _students.where((student) => failedIds.contains(student.id)).toList();

    _isLoading = false;
    notifyListeners();
  }
}
