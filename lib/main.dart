import 'package:flutter/material.dart';
import 'package:todo_app_maxi_digital/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_maxi_digital/task_manager.dart';
import 'services/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => TaskService()),
        ChangeNotifierProvider(
          create: (context) => TaskManager(taskService: context.read<TaskService>(),),
        ),
      ],
      child: const MaterialApp(
        home: Home(),
      ),
    );
  }
}
