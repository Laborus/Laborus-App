import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/users/person_model.dart';
import 'package:laborus_app/core/services/student_service.dart';

class StudentsProvider with ChangeNotifier {
  final StudentsService _studentsService = StudentsService();

  List<PersonModel> _students = [];
  List<String> _connections = [];
  final List<String> _pendingRequests = [];
  bool _isLoading = false;
  String? _error;

  List<PersonModel> get students => _students;
  List<String> get connections => _connections;
  List<String> get pendingRequests => _pendingRequests;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStudents(String userId) async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Fetch students, connections, and pending requests
      final loadedStudents = await _studentsService.getStudents();
      final userConnections = await _studentsService.getUserConnections();
      final pendingConnections = await _studentsService.getPendingConnections(
        senderId: userId,
        receiverId: userId,
      );

      // Update connections and pending requests
      _connections =
          userConnections.map((conn) => conn['_id'] as String).toList();
      _pendingRequests.clear();
      _pendingRequests.addAll(
        pendingConnections.map((conn) => conn['receiverId'] as String),
      );

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
      if (e.toString().contains('Connection request already sent') ||
          e
              .toString()
              .contains('cannot send a connection request to yourself')) {
        _removeStudentFromList(receiverId);
        rethrow;
      } else {
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
}
