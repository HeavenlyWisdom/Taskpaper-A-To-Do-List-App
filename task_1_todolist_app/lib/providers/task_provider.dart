import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_1_todolist_app/data/models/task.dart';

final taskBoxProvider = Provider<Box<Task>>((ref) {
  return Hive.box<Task>('tasks');
});

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  final box = ref.watch(taskBoxProvider);
  return TasksNotifier(box);
});

class TasksNotifier extends StateNotifier<List<Task>> {
  final Box<Task> _box;

  TasksNotifier(this._box) : super(_box.values.toList()..sort(_taskSorter));

  static int _taskSorter(Task a, Task b) {
    if (a.isCompleted != b.isCompleted) {
      return a.isCompleted ? 1 : -1;
    }
    return b.createdAt.compareTo(a.createdAt);
  }

  void addTask(Task task) {
    _box.put(task.id, task);
    state = [..._box.values]..sort(_taskSorter);
  }

  void toggleComplete(String id) {
    final task = _box.get(id);
    if (task != null) {
      final updated = task.copyWith(isCompleted: !task.isCompleted);
      _box.put(id, updated);
      state = [..._box.values]..sort(_taskSorter);
    }
  }

  void deleteTask(String id) {
    _box.delete(id);
    state = [..._box.values]..sort(_taskSorter);
  }
}