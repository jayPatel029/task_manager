import 'package:flutter/material.dart';
import 'package:task_manager_bloc/screens/home/edit_task_screen.dart';

import '../../services/task.dart';
import '../../services/task_service.dart';
import '../common_widgets.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  TaskDetailsScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  // Reference to TaskService for task operations
  final TaskService _taskService = TaskService(TaskRepository());

  // Delete task function
  void deleteTask(BuildContext context) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await _taskService.deleteTask(task.id);
      Navigator.pop(context); // Go back to the previous screen after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Task Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              task.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Text(
              "Due Date:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              task.dueDate,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Text(
              "Priority:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              task.priority,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Status:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Text(
                  task.isComplete ? "Completed" : "Incomplete",
                  style: TextStyle(
                    fontSize: 16,
                    color: task.isComplete ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task),
                  ),
                );
              },
              child: Text(
                "Edit",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                //delete task
                deleteTask(context);
              },
              child: Text(
                "Delete",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
