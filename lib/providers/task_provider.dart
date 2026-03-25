import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final box = Hive.box('tasksBox');
  List<Task> tasks = [];

  String searchQuery = '';
  TaskStatus? filterStatus;

  TaskProvider() {
    loadTasks();
  }

  void loadTasks() {
    tasks = box.values.map((e) => Task.fromMap(Map<String, dynamic>.from(e))).toList();
    notifyListeners();
  }

  List<Task> get filteredTasks {
    return tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = filterStatus == null || task.status == filterStatus;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  Future<void> addTask(Task task) async {
    await Future.delayed(const Duration(seconds: 2));
    await box.put(task.id, task.toMap());
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await Future.delayed(const Duration(seconds: 2));
    await box.put(task.id, task.toMap());
    loadTasks();
  }

  void deleteTask(String id) {
    box.delete(id);
    loadTasks();
  }

  bool isBlocked(Task task) {
    if (task.blockedBy == null) return false;
    final blocker = tasks.firstWhere((t) => t.id == task.blockedBy, orElse: () => task);
    return blocker.status != TaskStatus.done;
  }

  void setSearch(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setFilter(TaskStatus? status) {
    filterStatus = status;
    notifyListeners();
  }
}
