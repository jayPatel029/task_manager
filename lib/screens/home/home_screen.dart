/*
* display all tasks
* *sort => date and priority
* *add task from here
* *build sections acc. to date
* **/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_bloc/screens/home/add_task_screen_new.dart';
import 'package:task_manager_bloc/screens/home/task_details_screen.dart';
 import 'package:task_manager_bloc/services/task/task_notifier.dart';

import '../../services/task.dart';
import '../../services/task/task_state.dart';
import '../common_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context, ref);
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (taskState is TaskLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
              ),
            );
          } else if (taskState is TaskErrorState) {
            return Center(
              child: Text(
                taskState.message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          } else if (taskState is TaskLoadedState) {
            final tasks = taskState.tasks;

            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  "No tasks available. Add a task to get started.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
              final sortedTasks = _sortTasksByDate(tasks);


            return ListView(
              children: [
                if (sortedTasks['past']!.isNotEmpty) ...[
                  _sectionHead("🔥 Overdue"),
                  ...sortedTasks['past']!.map((task) => _taskCard(context, task, ref)),
                ],
                if (sortedTasks['today']!.isNotEmpty) ...[
                  _sectionHead("🌟 Today"),
                  ...sortedTasks['today']!.map((task) => _taskCard(context, task, ref)),
                ],
                if (sortedTasks['tomorrow']!.isNotEmpty) ...[
                  _sectionHead("⏳ Tomorrow"),
                  ...sortedTasks['tomorrow']!.map((task) => _taskCard(context, task, ref)),
                ],
                if (sortedTasks['upcoming']!.isNotEmpty) ...[
                  _sectionHead("📅 Upcoming"),
                  ...sortedTasks['upcoming']!.map((task) => _taskCard(context, task, ref)),
                ],
              ],
            );

          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _gotoAddTask(context, ref),
        icon: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        label: const Text(
          "Add Task",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Map<String, List<Task>> _sortTasksByDate(List<Task> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));

    final past = <Task>[];
    final todayTasks = <Task>[];
    final tomorrowTasks = <Task>[];
    final upcoming = <Task>[];

    for (var task in tasks) {
      try {
        final dueDate = DateFormat("dd-MM-yyyy").parse(task.dueDate);
        if (dueDate.isBefore(today)) {
          past.add(task);
        } else if (dueDate.isAtSameMomentAs(today)) {
          todayTasks.add(task);
        } else if (dueDate.isAtSameMomentAs(tomorrow)) {
          tomorrowTasks.add(task);
        } else {
          upcoming.add(task);
        }
      } catch (e) {
        print("Error parsing date for task: ${task.id}, ${task.dueDate}");
      }
    }

    return {
      'past': past,
      'today': todayTasks,
      'tomorrow': tomorrowTasks,
      'upcoming': upcoming,
    };
  }

  Widget _sectionHead(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
  Widget _taskCard(BuildContext context, Task task, WidgetRef ref) {
    return TaskCard(
      task: task,
      onTap: () => _gotoDetails(context, task),
      onToggleComplete: () {
        _toggleTaskCompletion(context, ref, task);
      },
    );
  }



  void _gotoDetails(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    );
  }

  void _gotoAddTask(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddTaskNew(isEdit: false),
        //     AddTaskScreen(
        //   onAddTask: (newTask) async {
        //     await ref.read(taskNotifierProvider.notifier).addTask(newTask);
        //   },
        // ),
      ),
    );
  }

  Future<void> _toggleTaskCompletion(
      BuildContext context, WidgetRef ref, Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isComplete = prefs.getBool(task.id) ?? task.isComplete;
    bool updatedState = !isComplete;
    await prefs.setBool(task.id, updatedState);
    ref
        .read(taskNotifierProvider.notifier)
        .updateTask(task.copyWith(isComplete: updatedState));
  }

  Future<void> _showFilterDialog(BuildContext context, WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentPriority = prefs.getString('selected_priority') ?? 'All';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Tasks"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  selectedColor: primDB,
                  title: const Text("All"),
                  onTap: () async {
                    await ref
                        .read(taskNotifierProvider.notifier)
                        .setPriorityFilter('All');
                    Navigator.pop(context);
                  },
                  selected: currentPriority == 'All',
                ),
                ListTile(
                  selectedColor: primDB,
                  title: const Text("High Priority"),
                  onTap: () async {
                    await ref
                        .read(taskNotifierProvider.notifier)
                        .setPriorityFilter('High');
                    Navigator.pop(context);
                  },
                  selected: currentPriority == 'High',
                ),
                ListTile(
                  selectedColor: primDB,
                  title: const Text("Medium Priority"),
                  onTap: () async {
                    await ref
                        .read(taskNotifierProvider.notifier)
                        .setPriorityFilter('Medium');
                    Navigator.pop(context);
                  },
                  selected: currentPriority == 'Medium',
                ),
                ListTile(
                  selectedColor: primDB,
                  title: const Text("Low Priority"),
                  onTap: () async {
                    await ref
                        .read(taskNotifierProvider.notifier)
                        .setPriorityFilter('Low');
                    Navigator.pop(context);
                  },
                  selected: currentPriority == 'Low',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
