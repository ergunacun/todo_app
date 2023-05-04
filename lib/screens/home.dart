import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_maxi_digital/task_manager.dart';
import '../models/index.dart';
import 'task_dialog.dart';

enum SortBy { title, status, noSort }

enum StatusFilter {
  all,
  complete,
  incomplete,
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SortBy sortBy = SortBy.noSort;
  StatusFilter statusFilter = StatusFilter.all;

  @override
  void initState() {
    context.read<TaskManager>().loadTasks(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App'), actions: [
        PopupMenuButton<SortBy>(
          icon: const Icon(Icons.sort),
          onSelected: (value) {
            setState(() {
              sortBy = value;
            });
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: SortBy.title,
              child: Text(
                'Sort by Title',
                style: TextStyle(
                    fontWeight:
                        (sortBy == SortBy.title) ? FontWeight.bold : null),
              ),
            ),
            PopupMenuItem(
              value: SortBy.status,
              child: Text('Sort by Status',
                  style: TextStyle(
                      fontWeight:
                          (sortBy == SortBy.status) ? FontWeight.bold : null)),
            ),
            PopupMenuItem(
              value: SortBy.noSort,
              child: Text('Unsorted',
                  style: TextStyle(
                      fontWeight:
                          (sortBy == SortBy.noSort) ? FontWeight.bold : null)),
            ),
          ],
        ),
        PopupMenuButton<StatusFilter>(
          icon: const Icon(Icons.filter_list),
          onSelected: (value) {
            setState(() {
              statusFilter = value;
            });
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: StatusFilter.all,
              child: Text('Show All',
                  style: TextStyle(
                      fontWeight: (statusFilter == StatusFilter.all)
                          ? FontWeight.bold
                          : null)),
            ),
            PopupMenuItem(
              value: StatusFilter.complete,
              child: Text('Show Complete',
                  style: TextStyle(
                      fontWeight: (statusFilter == StatusFilter.complete)
                          ? FontWeight.bold
                          : null)),
            ),
            PopupMenuItem(
              value: StatusFilter.incomplete,
              child: Text('Show Incomplete',
                  style: TextStyle(
                      fontWeight: (statusFilter == StatusFilter.incomplete)
                          ? FontWeight.bold
                          : null)),
            ),
          ],
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TaskManager>(
          builder: (context, taskManager, _) {
            final tasks = _filterTasks(_sortTasks(taskManager.tasks));
            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(task.title)),
                          Checkbox(
                            value: task.completed,
                            onChanged: (value) {
                              if (value == true) {
                                taskManager.markAsComplete(task.id);
                              } else {
                                taskManager.markAsIncomplete(task.id);
                              }
                            },
                          ),
                          IconButton(
                              onPressed: () =>
                                  _showEditTaskDialog(context, taskManager, task),
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () => taskManager.deleteTask(task.id),
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                      const Divider()
                    ],
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddTaskDialog(context),
      ),
    );
  }

  List<Task> _sortTasks(List<Task> tasks) {
    switch (sortBy) {
      case SortBy.title:
        List<Task> list = List.from(tasks);
        return list..sort((a, b) => a.title.compareTo(b.title));
      case SortBy.status:
        List<Task> list = List.from(tasks);
        return list
          ..sort((a, b) =>
              a.completed.toString().compareTo(b.completed.toString()));
      default:
        return tasks;
    }
  }

  List<Task> _filterTasks(List<Task> tasks) {
    switch (statusFilter) {
      case StatusFilter.complete:
        return tasks.where((task) => task.completed).toList();
      case StatusFilter.incomplete:
        return tasks.where((task) => !task.completed).toList();
      case StatusFilter.all:
      default:
        return tasks;
    }
  }

  _showEditTaskDialog(
      BuildContext context, TaskManager taskManager, Task task) async {
    final updatedTask = await showDialog<Task>(
      context: context,
      builder: (context) => TaskDialog(task: task),
    );
    if (updatedTask != null) {
      taskManager.editTask(updatedTask);
    }
  }

  _showAddTaskDialog(BuildContext context) async {
    final newTask = await showDialog<Task>(
      context: context,
      builder: (context) => const TaskDialog(),
    );
    if (newTask != null) {
      if (!mounted) return;
      context.read<TaskManager>().addNewTask(newTask);
    }
  }
}
