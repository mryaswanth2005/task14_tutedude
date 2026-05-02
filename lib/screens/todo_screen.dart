import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../models/todo.dart';

class TodoScreen extends StatefulWidget {
  final User user;
  final FirestoreService store;
  final AuthService authService;

  const TodoScreen({
    super.key,
    required this.user,
    required this.store,
    required this.authService,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _newCtl = TextEditingController();
  bool _adding = false;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _addTask() async {
    if (_adding) return;
    final text = _newCtl.text.trim();
    if (text.isEmpty) {
      _showMessage('Please enter a task title.');
      return;
    }

    setState(() => _adding = true);
    try {
      await widget.store.addTodo(widget.user.uid, text);
      _newCtl.clear();
    } catch (e) {
      _showMessage('Could not add task: $e');
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your TODOs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => await widget.authService.signOut(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newCtl,
                    decoration: const InputDecoration(hintText: 'New task'),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                IconButton(
                  onPressed: _adding ? null : _addTask,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Todo>>(
              stream: widget.store.streamTodosForUser(widget.user.uid),
              builder: (context, snap) {
                if (snap.hasError)
                  return Center(child: Text('Error: ${snap.error}'));
                if (!snap.hasData)
                  return const Center(child: CircularProgressIndicator());
                final todos = snap.data!;
                if (todos.isEmpty)
                  return const Center(child: Text('No tasks yet'));
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, i) {
                    final t = todos[i];
                    return ListTile(
                      leading: Checkbox(
                        value: t.completed,
                        onChanged: (_) => widget.store.toggleComplete(
                          widget.user.uid,
                          t.id,
                          t.completed,
                        ),
                      ),
                      title: Text(
                        t.title,
                        style: t.completed
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              )
                            : null,
                      ),
                      subtitle: Text(t.createdAt.toLocal().toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final ctl = TextEditingController(text: t.title);
                              final res = await showDialog<String?>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Edit Task'),
                                  content: TextField(controller: ctl),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                        context,
                                        ctl.text.trim(),
                                      ),
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              );
                              if (res != null && res.isNotEmpty)
                                await widget.store.updateTitle(
                                  widget.user.uid,
                                  t.id,
                                  res,
                                );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                widget.store.deleteTodo(widget.user.uid, t.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
