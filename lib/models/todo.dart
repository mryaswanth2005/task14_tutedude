import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  final String title;
  final bool completed;
  final String userId;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.userId,
    required this.createdAt,
  });

  factory Todo.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Todo(
      id: doc.id,
      title: data['title'] ?? '',
      completed: data['completed'] ?? false,
      userId: data['userId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'completed': completed,
    'userId': userId,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
