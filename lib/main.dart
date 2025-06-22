import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'viewmodels/habit_viewmodel.dart';
import 'views/home_screen.dart';
import 'views/add_habit_screen.dart';
import 'views/habit_detail_screen.dart';
import 'services/habit_storage_service.dart';
import 'services/reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final reminderService = ReminderService(FlutterLocalNotificationsPlugin());
  await reminderService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitViewModel(HabitStorageService(), reminderService),
      child: HabitApp(),
    ),
  );
}

class HabitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/add': (context) => AddHabitScreen(),
        '/detail': (context) => HabitDetailScreen(),
      },
    );
  }
}
