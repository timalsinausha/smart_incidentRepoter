class Incident {
  String id;
  final String userId;
  final String title;
  final String description;
  final String type;
  final String priority;
  final String? imageUrl;
  final DateTime createdAt;

  Incident({
    this.id = '',
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'description': description,
        'type': type,
        'priority': priority,
        'imageUrl': imageUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Incident.fromJson(Map<String, dynamic> map) {
    return Incident(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'],
      description: map['description'],
      type: map['type'],
      priority: map['priority'],
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
