import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_bloc/services/task_service.dart';
import '../services/task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskService taskService;

  TaskBloc(this.taskService) : super(TaskLoadingState());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if (event is FetchTasksEvent) {
      yield* _mapFetchTasksToState();
    } else if (event is AddTaskEvent) {
      yield* _mapAddTaskToState(event.task);
    } else if (event is UpdateTaskEvent) {
      yield* _mapUpdateTaskToState(event.task);
    } else if (event is DeleteTaskEvent) {
      yield* _mapDeleteTaskToState(event.taskId);
    }
  }

  Stream<TaskState> _mapFetchTasksToState() async* {
    try {
      yield TaskLoadingState();
      List<Task> tasks = await taskService.getTasks();
      yield TaskLoadedState(tasks);
    } catch (e) {
      yield TaskErrorState("Failed to load tasks.");
    }
  }

  Stream<TaskState> _mapAddTaskToState(Task task) async* {
    try {
      await taskService.addTask(task);
      yield* _mapFetchTasksToState(); // Refresh task list after adding
    } catch (e) {
      yield TaskErrorState("Failed to add task.");
    }
  }

  Stream<TaskState> _mapUpdateTaskToState(Task task) async* {
    try {
      await taskService.updateTask(task);
      yield* _mapFetchTasksToState(); // Refresh task list after update
    } catch (e) {
      yield TaskErrorState("Failed to update task.");
    }
  }

  Stream<TaskState> _mapDeleteTaskToState(String taskId) async* {
    try {
      await taskService.deleteTask(taskId);
      yield* _mapFetchTasksToState(); // Refresh task list after deletion
    } catch (e) {
      yield TaskErrorState("Failed to delete task.");
    }
  }
}
