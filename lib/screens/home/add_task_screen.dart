import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_bloc/bloc/auth_bloc.dart';
import 'package:task_manager_bloc/bloc/task_bloc.dart';
import 'package:task_manager_bloc/bloc/task_event.dart';

import '../../services/task.dart';
import '../../services/task_service.dart';
import '../common_widgets.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) onAddTask; // Callback function to add the task

  const AddTaskScreen({Key? key, required this.onAddTask}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dueDateController = TextEditingController();
  String priority = "Low";

  final TaskService _taskService = TaskService(TaskRepository());

  // Submit task function
  void submitTask() async {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        dueDateController.text.isNotEmpty) {
      final newTask = Task(
        id: "", // Id will be auto-generated when added to Firestore
        title: titleController.text,
        description: descriptionController.text,
        dueDate: dueDateController.text,
        priority: priority,
      );

      // Add task using TaskService
      await _taskService.addTask(newTask);

      // Once task is added, we notify parent (optional if needed)
      widget.onAddTask(newTask); // Notify parent widget about the new task

      // Close the screen
      Navigator.pop(context);
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
        title: Text("Add Task"),
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
              decoration: InputDecoration(
                labelText: "Due Date",
                hintText: "YYYY-MM-DD",
              ),
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
                onPressed: submitTask,
                child: Text("Add Task"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
