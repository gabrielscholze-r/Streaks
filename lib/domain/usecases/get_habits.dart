import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/repositories/habit_repository.dart';

class GetHabits {
  final HabitRepository repository;

  GetHabits(this.repository);

  Future<List<Habit>> call() async {
    return await repository.getHabits();
  }
}