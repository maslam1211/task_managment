class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String priority;
  final String status;
  final int assignedUser;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.assignedUser,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'status': status,
      'assignedUser': assignedUser,
    };
  }
}