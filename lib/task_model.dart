class Task {
  final String id;
  final String name;
  final bool completed;

  Task({required this.id, required this.name, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'completed': completed,
    };
  }

  static Task fromDocument(doc) {
    return Task(
      id: doc.id,
      name: doc['name'],
      completed: doc['completed'],
    );
  }
}