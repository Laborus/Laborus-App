import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:laborus_app/core/model/responses/job_response.dart';

class JobsService {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<JobsResponse> getJobsByType(String jobType) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/jobs/by-type?jobType=$jobType'),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return JobsResponse.fromJson(jsonDecode(response.body));
      } else {
        print(response.body);

        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      print(e);

      throw Exception('Error fetching jobs: $e');
    }
  }
}
