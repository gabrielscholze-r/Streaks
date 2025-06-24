import 'package:streaks/data/datasources/habit_local_data_source.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Habit>> getHabits() async {
    return await localDataSource.getHabits();
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    await localDataSource.saveHabit(habit);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await localDataSource.deleteHabit(id);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await localDataSource.updateHabit(habit);
  }
}