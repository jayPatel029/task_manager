import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_bloc/screens/home/home_screen.dart';

import '../../bloc/task_bloc.dart';
import '../../bloc/task_event.dart';
import '../../services/task.dart';
import '../../services/task_service.dart';
import '../common_widgets.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;
  String priority = "Low";

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController =
        TextEditingController(text: widget.task.description);
    dueDateController = TextEditingController(text: widget.task.dueDate);
    priority = widget.task.priority;
  }

  final TaskService _taskService = TaskService(TaskRepository());

  void saveTask() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        dueDateController.text.isNotEmpty) {
      final updatedTask = Task(
        id: widget.task.id, // Keep the same ID for updating
        title: titleController.text,
        description: descriptionController.text,
        dueDate: dueDateController.text,
        priority: priority,
        isComplete: widget.task.isComplete,
      );

      // Update task using TaskService
      await _taskService.updateTask(updatedTask);

      // After updating, home
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (val) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dueDateController,
              decoration: InputDecoration(labelText: "Due Date"),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: priority,
              items: ["Low", "Medium", "High"]
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    priority = value;
                  });
                }
              },
              decoration: InputDecoration(labelText: "Priority"),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  saveTask();
                },
                child: Text("Save Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
