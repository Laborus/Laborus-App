class Alert {
  final String id;
  final String title;
  final String tag;
  final String text;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Alert({
    required this.id,
    required this.title,
    required this.tag,
    required this.text,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['_id'],
      title: json['title'],
      tag: json['tag'],
      text: json['text'],
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
