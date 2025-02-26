import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_managment/utilities/app_color_padding.dart';
import 'package:task_managment/widgets/reusable_drop_down.dart';
import 'package:task_managment/widgets/reusable_form_field.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';
import 'package:task_managment/widgets/reusable_button.dart';
const double kDefaultPadding = 24.0;
const Color kDefaultColor = Color(0xFF56ab2f);

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({Key? key}) : super(key: key);

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String _priority = 'Medium';
  String _status = 'To-Do';
  Task? _task;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final task = ModalRoute.of(context)!.settings.arguments as Task?;
    if (task != null && _task == null) {
      _task = task;
      _titleController.text = task.title;
      _descriptionController.text = task.description ?? '';
      _dueDate = task.dueDate;
      _priority = task.priority;
      _status = task.status;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitTask(TaskProvider provider) async {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: _task?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        priority: _priority,
        status: _status,
        assignedUser: 1,
      );
      try {
        if (_task == null) {
          await provider.addTask(newTask);
        } else {
          await provider.updateTask(newTask);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to save task: ${e.toString()}')));
      }
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _task == null ? 'Create Task' : 'Edit Task',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ReusableTextFormField(
                        controller: _titleController,
                        labelText: 'Title',
                        prefixIcon: Icons.title,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Please enter a title' : null,
                      ),
                      const SizedBox(height: 20),
                      ReusableTextFormField(
                        controller: _descriptionController,
                        labelText: 'Description',
                        prefixIcon: Icons.description,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Please enter a description' : null,
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        title: const Text('Due Date'),
                        subtitle: Text('${_dueDate.toLocal()}'.split(' ')[0]),
                        trailing: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _dueDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) setState(() => _dueDate = picked);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ReusableDropdown<String>(
                        labelText: 'Priority',
                        value: _priority,
                        items: ['High', 'Medium', 'Low']
                            .map((priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _priority = value!),
                      ),
                      const SizedBox(height: 20),
                      ReusableDropdown<String>(
                        labelText: 'Status',
                        value: _status,
                        items: ['To-Do', 'In Progress', 'Done']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _status = value!),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ReusableButton(
                          text: _task == null ? 'Create Task' : 'Update Task',
                          onPressed: () => _submitTask(taskProvider),
                         backgroundColor: AppColorPallet.kDefaultColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}