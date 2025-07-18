import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; 
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/usecases/delete_habit.dart';
import 'package:streaks/domain/usecases/get_habits.dart';
import 'package:streaks/domain/usecases/save_habit.dart';

class HomePageViewModel extends ChangeNotifier {
  final GetHabits _getHabits;
  final SaveHabit _saveHabit;
  final DeleteHabit _deleteHabit;
  final FlutterLocalNotificationsPlugin?
      localNotificationsPlugin; 

  List<Habit> _habits = [];
  List<Habit> get habits => _habits;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  HomePageViewModel({
    required GetHabits getHabits,
    required SaveHabit saveHabit,
    required DeleteHabit deleteHabit,
    this.localNotificationsPlugin, 
  })  : _getHabits = getHabits,
        _saveHabit = saveHabit,
        _deleteHabit = deleteHabit;

  Future<void> fetchHabits() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _habits = await _getHabits.call();
    } catch (e) {
      _errorMessage = 'Failed to fetch habits: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHabit(Habit habit) async {
    _errorMessage = null;
    try {
      await _saveHabit.call(habit);
      await fetchHabits();
    } catch (e) {
      _errorMessage = 'Failed to add habit: $e';
      notifyListeners();
    }
  }

  Future<void> updateHabit(Habit habit) async {
    _errorMessage = null;
    try {
      await _saveHabit.call(habit);
      await fetchHabits();
    } catch (e) {
      _errorMessage = 'Failed to update habit: $e';
      notifyListeners();
    }
  }

  Future<void> deleteHabit(String id) async {
    _errorMessage = null;
    try {
      
      for (int i = 0; i < 7; i++) {
        final notificationId = id.hashCode + i;
        await localNotificationsPlugin
            ?.cancel(notificationId); 
        debugPrint(
            'Canceled notification with ID: $notificationId for habit $id');
      }

      await _deleteHabit.call(id);
      await fetchHabits();
    } catch (e) {
      _errorMessage = 'Failed to delete habit: $e';
      notifyListeners();
    }
  }

  Future<void> markHabitComplete(Habit habit) async {
    _errorMessage = null;
    try {
      final now = DateTime.now();
      List<DateTime> updatedCompletionDates = List.from(habit.completionDates);
      int currentStreak = habit.streakCount;
      int highestStreak = habit.highestStreak;

      if (habit.lastCompleted == null ||
          now.difference(habit.lastCompleted!).inDays == 1) {
        currentStreak++;
      } else if (now.difference(habit.lastCompleted!).inDays > 1) {
        currentStreak = 1;
      } else {
        debugPrint('Habit already completed today.');
        return;
      }

      updatedCompletionDates.add(now);

      if (currentStreak > highestStreak) {
        highestStreak = currentStreak;
      }

      final updatedHabit = habit.copyWith(
        lastCompleted: now,
        streakCount: currentStreak,
        completionDates: updatedCompletionDates,
        highestStreak: highestStreak,
      );
      await _saveHabit.call(updatedHabit);
      await fetchHabits();
    } catch (e) {
      _errorMessage = 'Failed to mark habit complete: $e';
      notifyListeners();
    }
  }
}
