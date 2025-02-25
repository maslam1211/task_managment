

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_managment/models/task_model.dart';
import 'package:task_managment/provider/task_provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTasksOnInit();
  }

  Future<void> _fetchTasksOnInit() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load tasks: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
   
          body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF56ab2f), Color(0xFFa8e063)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
                AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
              title: const Text(
                'Task Management',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _fetchTasksOnInit,
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : taskProvider.tasks.isEmpty
                      ? const Center(child: Text('No tasks available.'))
                      : ListView.builder(
                        padding: EdgeInsets.all(16),
                          itemCount: taskProvider.tasks.length,
                          itemBuilder: (context, index) {
                            Task task = taskProvider.tasks[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                title: Text(task.title),
                                subtitle: Text('Due: ${task.dueDate.toLocal()}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,color: Colors.red,),
                                  onPressed: task.id != null
                                      ? () => taskProvider.deleteTask(task.id!)
                                      : null,
                                ),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  '/add-task',
                                  arguments: task,
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    floatingActionButton: FloatingActionButton(         backgroundColor: const     Color(0xFF56ab2f),
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
      child: const Icon(Icons.add, color: Colors.white),
     ),
    );
  }
}