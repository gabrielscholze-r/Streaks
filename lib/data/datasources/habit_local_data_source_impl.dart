import 'package:hive/hive.dart';
import 'package:streaks/data/datasources/habit_local_data_source.dart';
import 'package:streaks/domain/entities/habit.dart';


class HabitLocalDataSourceImpl implements HabitLocalDataSource {

  final Box<Habit> habitBox;

  HabitLocalDataSourceImpl(this.habitBox);

  @override
  Future<List<Habit>> getHabits() async {
    return habitBox.values.toList();
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    await habitBox.put(habit.id, habit);
  }

  @override
  Future<void> deleteHabit(String id) async {
    await habitBox.delete(id);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    await habitBox.put(habit.id, habit);
  }
}
