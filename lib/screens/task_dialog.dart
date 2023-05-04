import 'package:flutter/material.dart';
import '../models/index.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  const TaskDialog({super.key, this.task});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late bool isComplete;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title;
      isComplete = widget.task!.completed;
    } else {
      title = '';
      isComplete = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: title,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) {
                title = value!;
              },
            ),
            CheckboxListTile(
              title: const Text('Complete'),
              value: isComplete,
              onChanged: (value) {
                setState(() {
                  isComplete = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(widget.task == null ? 'Add' : 'Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              if (widget.task == null) {
                Navigator.of(context).pop(Task(
                  title: title,
                  completed: isComplete, 
                  id: DateTime.now().millisecondsSinceEpoch.toString()
                ));
              } else {
                Navigator.of(context).pop(Task(
                  title: title,
                  completed: isComplete,
                  id: widget.task!.id
                ));
              }
            }
          },
        ),
      ],
    );
  }
}
