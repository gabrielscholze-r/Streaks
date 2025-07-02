import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uuid/uuid.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/entities/time_of_day.dart' as streaks_time; 
import 'package:streaks/domain/usecases/save_habit.dart';

class AddEditHabitViewModel extends ChangeNotifier {
  final SaveHabit _saveHabit;
  final Uuid _uuid;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  AddEditHabitViewModel({
    required SaveHabit saveHabit,
    Uuid? uuid,
    required FlutterLocalNotificationsPlugin localNotificationsPlugin,
  })  : _saveHabit = saveHabit,
        _uuid = uuid ?? const Uuid(),
        _localNotificationsPlugin = localNotificationsPlugin;

  Habit? _currentHabit;
  String _name = '';
  String _description = '';
  List<int> _selectedDays = [];
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0); 
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  void initialize(Habit? habit) {
    _currentHabit = habit;
    if (habit != null) {
      _name = habit.name;
      _description = habit.description;
      _selectedDays = List.from(habit.reminderDays);
      _selectedTime = TimeOfDay(
          hour: habit.notificationTime.hour,
          minute: habit.notificationTime.minute);
    } else {
      _name = '';
      _description = '';
      _selectedDays = [];
      _selectedTime = const TimeOfDay(hour: 9, minute: 0);
    }
    notifyListeners();
  }

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get description => _description;
  set description(String value) {
    _description = value;
    notifyListeners();
  }

  List<int> get selectedDays => _selectedDays;
  set selectedDays(List<int> value) {
    _selectedDays = value;
    notifyListeners();
  }

  TimeOfDay get selectedTime => _selectedTime;
  set selectedTime(TimeOfDay value) {
    _selectedTime = value;
    notifyListeners();
  }

  void toggleDay(int day) {
    if (_selectedDays.contains(day)) {
      _selectedDays.remove(day);
    } else {
      _selectedDays.add(day);
    }
    _selectedDays.sort();
    notifyListeners();
  }

  Future<bool> saveHabit() async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    if (_name.trim().isEmpty) {
      _errorMessage = 'Habit name cannot be empty.';
      _isSaving = false;
      notifyListeners();
      return false;
    }

    try {
      final habitToSave = _currentHabit?.copyWith(
            name: _name,
            description: _description,
            reminderDays: _selectedDays,
            notificationTime: streaks_time.AppTimeOfDay( 
                hour: _selectedTime.hour, minute: _selectedTime.minute),
          ) ??
          Habit(
            id: _uuid.v4(),
            name: _name,
            description: _description,
            reminderDays: _selectedDays,
            notificationTime: streaks_time.AppTimeOfDay( 
                hour: _selectedTime.hour, minute: _selectedTime.minute),
            createdAt: DateTime.now(),
            completionDates: const [], 
            highestStreak: 0, 
          );

      await _saveHabit.call(habitToSave);

      
      if (_currentHabit != null) {
        await _cancelNotificationsForHabit(
            habitToSave.id); 
      }
      await _scheduleNotificationsForHabit(habitToSave);


      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to save habit: $e';
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _scheduleNotificationsForHabit(Habit habit) async {
    await _cancelNotificationsForHabit(habit.id);

    if (habit.reminderDays.isEmpty) {
      return; 
    }

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'streaks_habit_channel', 
      'Streaks Habit Reminders', 
      channelDescription: 'Reminders for your daily habits',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    for (final dayIndex in habit.reminderDays) { 
      
      int targetDayOfWeek = (dayIndex == 0) ? DateTime.sunday : dayIndex + 1;

      final now = tz.TZDateTime.now(tz.local);

      
      tz.TZDateTime nextNotificationTime = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        habit.notificationTime.hour,
        habit.notificationTime.minute,
        0, 
        0, 
      );

      
      if (nextNotificationTime.isBefore(now)) {
        nextNotificationTime =
            nextNotificationTime.add(const Duration(days: 1));
      }

      
      while (nextNotificationTime.weekday != targetDayOfWeek) {
        nextNotificationTime =
            nextNotificationTime.add(const Duration(days: 1));
      }
      
      final notificationId =
          habit.id.hashCode + dayIndex; 

      await _localNotificationsPlugin.zonedSchedule(
        notificationId,
        'Lembrete: ${habit.name}',
        habit.description.isNotEmpty
            ? habit.description
            : 'É hora de fazer seu hábito!',
        nextNotificationTime, 
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents
            .dayOfWeekAndTime, 
        payload: habit.id,
      );
      debugPrint(
          'Notification scheduled for ${habit.name} (dayIndex $dayIndex / DT weekday $targetDayOfWeek) at ${habit.notificationTime.hour}:${habit.notificationTime.minute.toString().padLeft(2, '0')} on ${nextNotificationTime.toIso8601String()} with ID $notificationId');
    }
  }

  
  Future<void> _cancelNotificationsForHabit(String habitId) async {
    for (int i = 0; i < 7; i++) {
      final notificationId = habitId.hashCode + i;
      await _localNotificationsPlugin.cancel(notificationId);
      debugPrint(
          'Canceled notification with ID: $notificationId for habit $habitId');
    }
  }

}