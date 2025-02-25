import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_managment/models/task_model.dart';

class TaskService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/todos';

 
  static Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((taskData) => Task(
        id: taskData["id"],
        title: taskData['title'],
        description: '',
        dueDate: DateTime.now(),
        priority: 'Medium',
        status: taskData['completed'] ? 'Done' : 'To-Do',
        assignedUser: 1,
      )).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  
  static Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task.toJson()),
    );
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Task(
        id: data['id'],
        title: data['title'],
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        status: task.status,
        assignedUser: task.assignedUser,
      );
    } else {
      throw Exception('Failed to create task');
    }
  }


static Future<void> updateTask(Task task) async {
  if (task.id == null) throw Exception('Task ID is null');

  final response = await http.patch(
    Uri.parse('$_baseUrl/${task.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(task.toJson()),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update task: ${response.statusCode} - ${response.body}');
  }
}

 
  static Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
