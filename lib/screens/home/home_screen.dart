import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_bloc/bloc/task_bloc.dart';
import 'package:task_manager_bloc/bloc/task_state.dart';
import 'package:task_manager_bloc/screens/home/task_details_screen.dart';

import '../../bloc/task_event.dart';
import '../../services/task.dart';
import '../../services/task_service.dart';
import '../common_widgets.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService(TaskRepository());
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  // Fetch tasks from Firestore
  void _fetchTasks() async {
    List<Task> fetchedTasks = await _taskService.getTasks();
    setState(() {
      tasks = fetchedTasks;
    });
  }

  // Toggle task completion
  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isComplete = !tasks[index].isComplete;
    });
  }

  void deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _taskService.deleteTask(tasks[index].id);
              setState(() {
                tasks.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void navigateToDetails(Task task, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(
          task: task,
        ),
      ),
    );
  }

  void navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(onAddTask: (newTask) async {
          _fetchTasks();
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator(color: primDB)) // Loading indicator
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index],
                  onTap: () => navigateToDetails(tasks[index], index),
                  onToggleComplete: () => toggleTaskCompletion(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddTask,
        icon: Icon(Icons.add_rounded),
        label: Text("Add Task"),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
