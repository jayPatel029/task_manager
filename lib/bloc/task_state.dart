import 'package:equatable/equatable.dart';
import 'package:task_manager_bloc/services/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<Task> tasks;

  TaskLoadedState(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

class TaskErrorState extends TaskState {
  final String message;

  TaskErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
