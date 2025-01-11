import 'package:equatable/equatable.dart';
import 'package:task_manager_bloc/services/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class FetchTasksEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent {
  final Task task;

  AddTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;

  UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
