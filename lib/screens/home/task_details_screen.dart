import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_bloc/screens/home/add_task_screen_new.dart';
import 'package:task_manager_bloc/screens/home/edit_task_screen.dart';

import '../../services/task.dart';
import '../../services/task/task_notifier.dart';
import '../common_widgets.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final Task task;

  TaskDetailsScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  // Reference to TaskService for task operations

  // Delete task function

  // Delete task function using Riverpod
  Future<void> deleteTask(BuildContext context, WidgetRef ref) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
      Navigator.pop(context); // Go back to the previous screen after deletion
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[600], // Blue background for AppBar
        title: const Text("Task Details"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700], // Blue title text
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Description:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[600], // Blue description header
              ),
            ),
            Text(
              task.description,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Text(
              "Due Date:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[600],
              ),
            ),
            Text(
              task.dueDate,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Text(
              "Priority:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[600],
              ),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[600],
                  ),
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
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormScreen(isEdit: true, task: task,),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[600], padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24), // Blue color for Edit button text

              ),
              child: Text(
                "Edit",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                deleteTask(context, ref);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent, padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24), // Red color for Delete button text

              ),
              child: Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
