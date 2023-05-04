import 'package:flutter/material.dart';
import 'package:todo_app_maxi_digital/models/index.dart';
import 'services/index.dart';

class TaskManager extends ChangeNotifier {
  final TaskService _taskService;
  List<Task> _tasks = [];

  TaskManager({required TaskService taskService}) : _taskService = taskService;

  List<Task> get tasks => _tasks;

  Future<void> loadTasks(BuildContext context) async {
    _tasks = await _taskService.getTasks(context);
    notifyListeners();
  }

  addNewTask(Task task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  editTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
    notifyListeners();
  }

  deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  markAsComplete(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].completed = true;
      notifyListeners();
    }
  }

  markAsIncomplete(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].completed = false;
      notifyListeners();
    }
  }
}
