/*
* all task info
* *edit / delete from here
* **/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_bloc/screens/home/add_task_screen_new.dart';

import '../../services/task.dart';
import '../../services/task/task_notifier.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final Task task;

  TaskDetailsScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  Future<void> deleteTask(BuildContext context, WidgetRef ref) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text(
              "Are you sure you want to delete this task? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final snackBarController = ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Deleting task..."),
          duration: Duration(minutes: 1),
        ),
      );

      try {
        await ref.read(taskNotifierProvider.notifier).deleteTask(task.id);
        snackBarController.close();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Task deleted successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        snackBarController.close();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete task: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: const Text("Task Details"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddTaskNew(isEdit: true, task: task),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => deleteTask(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 16),
            taskDetailItem("Description", task.description),
            const SizedBox(height: 16),
            taskDetailItem("Due Date", task.dueDate),
            const SizedBox(height: 16),
            taskDetailItem("Priority", task.priority),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Status:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  task.isComplete ? "Completed" : "Incomplete",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddTaskNew(isEdit: true, task: task),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text(
                "Edit",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[600],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => deleteTask(context, ref),
              icon: const Icon(Icons.delete),
              label: const Text(
                "Delete",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
