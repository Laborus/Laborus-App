import 'package:laborus_app/core/model/responses/user_request_model.dart';

class ConnectionRequestModel {
  final String id;
  final UserRequestModel? sender;
  final UserRequestModel? receiver;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConnectionRequestModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    return ConnectionRequestModel(
      id: json['_id'] ?? '',
      sender: UserRequestModel.fromJson(
          json['sender'] is Map ? json['sender'] : {}),
      receiver: UserRequestModel.fromJson(
          json['receiver'] is Map ? json['receiver'] : {}),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sender': sender?.toJson(),
      'receiver': receiver?.toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
