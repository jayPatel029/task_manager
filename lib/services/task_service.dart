
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager_bloc/services/task.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Task>> fetchTasks() async {
    QuerySnapshot snapshot = await _firestore.collection('tasks').get();
    return snapshot.docs
        .map((doc) => Task.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addTask(Task task) async {
    await _firestore.collection('tasks').add(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await _firestore.collection('tasks').doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }
}

class TaskService {
  final TaskRepository _taskRepository;

  TaskService(this._taskRepository);

  Future<List<Task>> getTasks() {
    return _taskRepository.fetchTasks();
  }

  Future<void> addTask(Task task) {
    return _taskRepository.addTask(task);
  }

  Future<void> updateTask(Task task) {
    return _taskRepository.updateTask(task);
  }

  Future<void> deleteTask(String taskId) {
    return _taskRepository.deleteTask(taskId);
  }
}
