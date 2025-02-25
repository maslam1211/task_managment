import 'package:flutter/material.dart';
import 'package:task_managment/models/task_model.dart';
import 'package:task_managment/service/task_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

 
  Future<void> fetchTasks() async {
    _tasks = await TaskService.getTasks();
    notifyListeners();
  }

  
  Future<void> addTask(Task task) async {
    try {
      final createdTask = await TaskService.createTask(task);
      _tasks.insert(0, createdTask); 
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await TaskService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await TaskService.updateTask(task);
      int index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }
}
