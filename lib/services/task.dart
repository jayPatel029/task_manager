class Task {
  final String id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  bool isComplete;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isComplete = false,
  });

  // Convert Task to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'isComplete': isComplete,
    };
  }

  // Convert Firestore Map to Task
  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      priority: map['priority'],
      isComplete: map['isComplete'],
    );
  }
}
