import 'package:laborus_app/core/model/social/company.dart';

class Job {
  final String id;
  final String title;
  final String jobType;
  final Company company;
  final String location;
  final String period;
  final String modality;
  final List<String> tags;
  final String description;
  final List<String> candidates;
  final DateTime createdAt;
  final DateTime updatedAt;

  Job({
    required this.id,
    required this.title,
    required this.jobType,
    required this.company,
    required this.location,
    required this.period,
    required this.modality,
    required this.tags,
    required this.description,
    required this.candidates,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'],
      title: json['title'],
      jobType: json['jobType'],
      company: Company.fromJson(json['company']),
      location: json['location'],
      period: json['period'],
      modality: json['modality'],
      tags: List<String>.from(json['tags']),
      description: json['description'],
      candidates: List<String>.from(json['candidates']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} ano${(difference.inDays / 365).floor() == 1 ? '' : 's'} atrás';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mês${(difference.inDays / 30).floor() == 1 ? '' : 'es'} atrás';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} dia${difference.inDays == 1 ? '' : 's'} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours == 1 ? '' : 's'} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes == 1 ? '' : 's'} atrás';
    } else {
      return 'Agora mesmo';
    }
  }
}
