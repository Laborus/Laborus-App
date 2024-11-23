import 'package:flutter/material.dart';
import 'package:laborus_app/core/model/social/job.dart';
import 'package:laborus_app/core/services/jobs_service.dart';

class JobsProvider extends ChangeNotifier {
  final JobsService _jobsService;

  JobsProvider(this._jobsService);

  List<Job> _jobs = [];
  int _totalJobs = 0;
  bool _isLoading = false;
  String? _error;

  List<Job> get jobs => _jobs;
  int get totalJobs => _totalJobs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchJobsByType(String jobType) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _jobsService.getJobsByType(jobType);
      print(response.jobs);
      _jobs = response.jobs;
      _totalJobs = response.total;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
