import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_bloc/screens/home/task_details_screen.dart';
import 'package:task_manager_bloc/services/task/task_notifier.dart';

import '../../services/task.dart';
import '../../services/task/task_state.dart';
import '../common_widgets.dart';
import 'add_task_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        centerTitle: true,
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
              child: CircularProgressIndicator(color: Color(0xFF676bF3)),
            );
          } else if (taskState is TaskErrorState) {
            return Center(
              child: Text(
                taskState.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (taskState is TaskLoadedState) {

            final tasks = taskState.tasks;

            if (tasks.isEmpty) {
              return const Center(
                child: Text(
                  "No tasks available. Add a task to get started.",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index],
                  onTap: () => _navigateToDetails(context, tasks[index]),
                  onToggleComplete: () {
                    _toggleTaskCompletion(context, ref, tasks[index]);
                  },
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddTask(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text("Add Task"),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsScreen(task: task),
      ),
    );
  }

  void _navigateToAddTask(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          onAddTask: (newTask) async {
            await ref.read(taskNotifierProvider.notifier).addTask(newTask);
          },
        ),
      ),
    );
  }

  Future<void> _toggleTaskCompletion(
      BuildContext context, WidgetRef ref, Task task) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isComplete = prefs.getBool(task.id) ?? task.isComplete;
    bool updatedState = !isComplete;
    await prefs.setBool(task.id, updatedState);
    ref.read(taskNotifierProvider.notifier).updateTask(task.copyWith(isComplete: updatedState));
  }


  Future<void> _showFilterDialog(BuildContext context, WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentPriority = prefs.getString('selected_priority') ?? 'All';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Filter Tasks"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("All"),
                onTap: () async {
                  await ref.read(taskNotifierProvider.notifier).setPriorityFilter('All');
                  Navigator.pop(context);
                },
                selected: currentPriority == 'All',
              ),
              ListTile(
                title: const Text("High Priority"),
                onTap: () async {
                  await ref.read(taskNotifierProvider.notifier).setPriorityFilter('High');
                  Navigator.pop(context);
                },
                selected: currentPriority == 'High',
              ),
              ListTile(
                title: const Text("Medium Priority"),
                onTap: () async {
                  await ref.read(taskNotifierProvider.notifier).setPriorityFilter('Medium');
                  Navigator.pop(context);
                },
                selected: currentPriority == 'Medium',
              ),
              ListTile(
                title: const Text("Low Priority"),
                onTap: () async {
                  await ref.read(taskNotifierProvider.notifier).setPriorityFilter('Low');
                  Navigator.pop(context);
                },
                selected: currentPriority == 'Low',
              ),
            ],
          ),
        );
      },
    );
  }


}
