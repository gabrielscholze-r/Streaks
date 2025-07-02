import 'package:flutter_test/flutter_test.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/entities/time_of_day.dart' as app_time_of_day;
import 'package:streaks/domain/repositories/habit_repository.dart';
import 'package:streaks/domain/usecases/get_habits.dart';
import 'package:streaks/domain/usecases/save_habit.dart';
import 'package:streaks/domain/usecases/delete_habit.dart';

class MockHabitRepository implements HabitRepository {
  List<Habit> _habits = [];
  String? _deletedId;
  Habit? _savedHabit;
  Habit? _updatedHabit;

  @override
  Future<List<Habit>> getHabits() async {
    return _habits;
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    _savedHabit = habit;
    
    int index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
    } else {
      _habits.add(habit);
    }
  }

  @override
  Future<void> deleteHabit(String id) async {
    _deletedId = id;
    _habits.removeWhere((habit) => habit.id == id);
  }

  @override
  Future<void> updateHabit(Habit habit) async {
    _updatedHabit = habit;
    int index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
    }
  }

  
  void clearInvocations() {
    _deletedId = null;
    _savedHabit = null;
    _updatedHabit = null;
    
  }

  String? get deletedId => _deletedId;
  Habit? get savedHabit => _savedHabit;
  Habit? get updatedHabit => _updatedHabit;
}

void main() {
  late MockHabitRepository mockHabitRepository;
  late GetHabits getHabitsUseCase;
  late SaveHabit saveHabitUseCase;
  late DeleteHabit deleteHabitUseCase;

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    getHabitsUseCase = GetHabits(mockHabitRepository);
    saveHabitUseCase = SaveHabit(mockHabitRepository);
    deleteHabitUseCase = DeleteHabit(mockHabitRepository);
    mockHabitRepository.clearInvocations();
  });

  group('GetHabits Use Case', () {
    test('deve retornar uma lista de hábitos do repositório', () async {
      final tHabits = [
        Habit(
          id: '1',
          name: 'Correr',
          notificationTime: const app_time_of_day.AppTimeOfDay(hour: 7, minute: 0),
          createdAt: DateTime.now(),
          completionDates: const [],
          highestStreak: 0,
        ),
        Habit(
          id: '2',
          name: 'Ler',
          notificationTime: const app_time_of_day.AppTimeOfDay(hour: 20, minute: 0),
          createdAt: DateTime.now(),
          completionDates: const [],
          highestStreak: 0,
        ),
      ];
      
      mockHabitRepository._habits = tHabits;

      final result = await getHabitsUseCase.call();

      expect(result, tHabits);
      
      
    });
  });

  group('SaveHabit Use Case', () {
    final tHabit = Habit(
      id: '1',
      name: 'Meditar',
      notificationTime: const app_time_of_day.AppTimeOfDay(hour: 6, minute: 0),
      createdAt: DateTime.now(),
      completionDates: const [],
      highestStreak: 0,
    );

    test('deve chamar o método saveHabit do repositório', () async {
      await saveHabitUseCase.call(tHabit);

      expect(mockHabitRepository.savedHabit, tHabit);
    });
  });

  group('DeleteHabit Use Case', () {
    const tId = '123';

    test('deve chamar o método deleteHabit do repositório', () async {
      await deleteHabitUseCase.call(tId);

      expect(mockHabitRepository.deletedId, tId);
    });
  });
}