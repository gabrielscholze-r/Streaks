import 'package:flutter/material.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/entities/time_of_day.dart' as streaks_time;
import 'package:streaks/domain/usecases/save_habit.dart';
import 'package:uuid/uuid.dart';

class AddEditHabitViewModel extends ChangeNotifier {
  final SaveHabit _saveHabit;
  final Uuid _uuid;

  AddEditHabitViewModel({required SaveHabit saveHabit, Uuid? uuid})
      : _saveHabit = saveHabit,
        _uuid = uuid ?? const Uuid();

  Habit? _currentHabit;
  String _name = '';
  String _description = '';
  List<int> _selectedDays = [];
  TimeOfDay _selectedTime = TimeOfDay(hour: 9, minute: 0);
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
      _selectedTime = TimeOfDay(hour: 9, minute: 0);
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
            notificationTime: streaks_time.TimeOfDay(
                hour: _selectedTime.hour, minute: _selectedTime.minute),
          ) ??
          Habit(
            id: _uuid.v4(),
            name: _name,
            description: _description,
            reminderDays: _selectedDays,
            notificationTime: streaks_time.TimeOfDay(
                hour: _selectedTime.hour, minute: _selectedTime.minute),
            createdAt: DateTime.now(),
          );

      await _saveHabit.call(habitToSave);
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
}