import 'package:streaks/domain/repositories/habit_repository.dart';

class DeleteHabit {
  final HabitRepository repository;

  DeleteHabit(this.repository);

  Future<void> call(String id) async {
    await repository.deleteHabit(id);
  }
}