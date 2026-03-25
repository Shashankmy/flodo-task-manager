import 'package:uuid/uuid.dart';

enum TaskStatus { todo, inProgress, done }

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  TaskStatus status;
  String? blockedBy;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedBy,
  }) : id = const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status.index,
      'blockedBy': blockedBy,
    };
  }

  factory Task.fromMap(Map map) {
    return Task(
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      status: TaskStatus.values[map['status']],
      blockedBy: map['blockedBy'],
    )..id = map['id'];
  }
}
