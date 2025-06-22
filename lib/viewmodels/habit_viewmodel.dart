import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/habit_storage_service.dart';
import '../services/reminder_service.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitStorageService _storageService;
  final ReminderService _reminderService;

  List<Habit> _habits = [];

  List<Habit> get habits => List.unmodifiable(_habits);

  HabitViewModel(this._storageService, this._reminderService) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    _habits = await _storageService.loadHabits();
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    _habits.add(habit);
    await _storageService.saveHabits(_habits);
    await _reminderService.scheduleHabitReminder(
      id: habit.id,
      title: habit.title,
      time: habit.reminderTime,
      daysOfWeek: habit.reminderDays,
    );
    notifyListeners();
  }

  Future<void> toggleCompleted(String id) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].completed = !_habits[index].completed;
      await _storageService.saveHabits(_habits);
      notifyListeners();
    }
  }
}
