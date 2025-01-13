/*
* curd opr for tsak
* *
* *filter based on prioriy
* **/

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_bloc/services/task/task_service.dart';
import 'package:task_manager_bloc/services/task/task_state.dart';
import '../task.dart';

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskService taskService;
  String? selectedPriority;

  TaskNotifier(this.taskService) : super(TaskLoadingState()) {
    fetchTasks();
  }

  // todo refresh list after oprs edit / add
  Future<void> fetchTasks() async {
    state = TaskLoadingState();
    try {
      final tasks = await taskService.getTasks();
      final filteredTasks = await _filterTasks(tasks);
      state = TaskLoadedState(filteredTasks);
      print("Tasks loaded successfully: ${tasks.length} tasks");
    } catch (e) {
      state = TaskErrorState('Failed to load tasks: $e');
    }
  }

   Future<void> setPriorityFilter(String priority) async {
    selectedPriority = priority;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_priority', priority);
    await fetchTasks();
  }

   Future<List<Task>> _filterTasks(List<Task> tasks) async {
    if (selectedPriority == null || selectedPriority == 'All') {
      return tasks; //
    }

    tasks.sort((a, b) {
      if (a.priority == selectedPriority && b.priority != selectedPriority) {
        return -1;
      } else if (a.priority != selectedPriority &&
          b.priority == selectedPriority) {
        return 1;
      } else {
        return 0; //
      }
    });

    return tasks;
  }

   Future<void> addTask(Task task) async {
    try {
      await taskService.addTask(task);
      await fetchTasks();
    } catch (e) {
      state = TaskErrorState('Failed to add task: $e');
    }
  }

   Future<void> updateTask(Task task) async {
    try {
      await taskService.updateTask(task);
      await fetchTasks();
    } catch (e) {
      state = TaskErrorState('Failed to update task: $e');
    }
  }

   Future<void> deleteTask(String taskId) async {
    try {
      await taskService.deleteTask(taskId);
      await fetchTasks();
    } catch (e) {
      state = TaskErrorState('Failed to delete task: $e');
    }
  }
}

final taskServiceProvider = Provider<TaskService>((ref) => TaskService());

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final taskService = ref.watch(taskServiceProvider);
  return TaskNotifier(taskService);
});
