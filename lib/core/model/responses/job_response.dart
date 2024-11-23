import 'package:laborus_app/core/model/social/job.dart';

class JobsResponse {
  final int total;
  final List<Job> jobs;

  JobsResponse({
    required this.total,
    required this.jobs,
  });

  factory JobsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return JobsResponse(
      total: data['total'],
      jobs: (data['jobs'] as List)
          .map((jobJson) => Job.fromJson(jobJson))
          .toList(),
    );
  }
}
