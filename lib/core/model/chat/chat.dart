import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laborus_app/core/model/chat/chat_messages.dart';

class Chat {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  Chat({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    this.messages = const [],
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      messages: (map['messages'] as List? ?? [])
          .map((m) => ChatMessage.fromMap(m))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }
}
