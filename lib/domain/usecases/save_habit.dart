import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/repositories/habit_repository.dart';

class SaveHabit {
  final HabitRepository repository;

  SaveHabit(this.repository);

  Future<void> call(Habit habit) async {
    await repository.saveHabit(habit);
  }
}