import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_managment/provider/auth_provider.dart';
import 'package:task_managment/provider/task_provider.dart';
import 'package:task_managment/view/login_screen.dart';
import 'package:task_managment/view/register_screen.dart';
import 'package:task_managment/view/task_form_screen.dart';
import 'package:task_managment/view/task_list_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Task Management App',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: authProvider.isLoggedIn ? const TaskListScreen() : const LoginScreen(),
            routes: {
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/tasks': (_) => const TaskFormScreen(),
              '/add-task': (_) => const TaskFormScreen(),
            },
          );
        },
      ),
    );
  }
}
