import 'package:streaks/domain/entities/habit.dart';

abstract class HabitLocalDataSource {
  Future<List<Habit>> getHabits();
  Future<void> saveHabit(Habit habit);
  Future<void> deleteHabit(String id);
  Future<void> updateHabit(Habit habit);
}
