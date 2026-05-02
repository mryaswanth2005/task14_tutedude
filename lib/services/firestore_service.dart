import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _todosRef(String uid) {
    return _db.collection('users').doc(uid).collection('todos');
  }

  Stream<List<Todo>> streamTodosForUser(String uid) {
    return _todosRef(uid).snapshots().map((snap) {
      final todos = snap.docs.map((d) => Todo.fromDoc(d)).toList();
      todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return todos;
    });
  }

  Future<void> addTodo(String uid, String title) async {
    final doc = _todosRef(uid).doc();
    final todo = Todo(
      id: doc.id,
      title: title,
      completed: false,
      userId: uid,
      createdAt: DateTime.now(),
    );
    await doc.set(todo.toMap());
  }

  Future<void> toggleComplete(String uid, String id, bool currentValue) async {
    await _todosRef(uid).doc(id).update({'completed': !currentValue});
  }

  Future<void> updateTitle(String uid, String id, String title) async {
    await _todosRef(uid).doc(id).update({'title': title});
  }

  Future<void> deleteTodo(String uid, String id) async {
    await _todosRef(uid).doc(id).delete();
  }
}
