import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager_bloc/services/task/task_service.dart';
import 'package:task_manager_bloc/services/task/task_state.dart';
import '../task.dart';

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskService taskService;

  TaskNotifier(this.taskService) : super(TaskLoadingState()) {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    state = TaskLoadingState();
    try {
      final tasks = await taskService.getTasks();
      state = TaskLoadedState(tasks);
      print("Tasks loaded successfully: ${tasks.length} tasks");
    } catch (e) {
      state = TaskErrorState('Failed to load tasks: $e');
    }
  }

  /// Add a new task
  Future<void> addTask(Task task) async {
    try {
      await taskService.addTask(task);
      await fetchTasks(); // Refresh task list
    } catch (e) {
      state = TaskErrorState('Failed to add task: $e');
    }
  }

  /// Update an existing task
  Future<void> updateTask(Task task) async {
    try {
      await taskService.updateTask(task);
      await fetchTasks(); // Refresh task list
    } catch (e) {
      state = TaskErrorState('Failed to update task: $e');
    }
  }

  /// Delete a task by ID
  Future<void> deleteTask(String taskId) async {
    try {
      await taskService.deleteTask(taskId);
      await fetchTasks(); // Refresh task list
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
