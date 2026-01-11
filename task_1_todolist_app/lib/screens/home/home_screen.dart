// lib/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_provider.dart';
import '../../data/models/task.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CODSOFT Todo'),
      ),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet\nAdd your first task!'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => ref.read(tasksProvider.notifier).toggleComplete(task.id),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.grey : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => ref.read(tasksProvider.notifier).deleteTask(task.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Temporary test - add fake task
          final newTask = Task(
            title: "Test task ${DateTime.now().second}",
            priority: Priority.medium,
          );
          ref.read(tasksProvider.notifier).addTask(newTask);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}