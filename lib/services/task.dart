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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'isComplete': isComplete,
    };
  }

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

  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? dueDate,
    String? priority,
    bool? isComplete,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, dueDate: $dueDate, priority: $priority, isComplete: $isComplete)';
  }
}
