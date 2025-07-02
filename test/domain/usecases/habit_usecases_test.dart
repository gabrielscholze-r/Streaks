import 'package:flutter_test/flutter_test.dart'; // Contém setUp, group, test, expect, isA
import 'package:mockito/mockito.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/entities/time_of_day.dart' as app_time_of_day;
import 'package:streaks/domain/repositories/habit_repository.dart';
import 'package:streaks/domain/usecases/get_habits.dart';
import 'package:streaks/domain/usecases/save_habit.dart';
import 'package:streaks/domain/usecases/delete_habit.dart';

// Mock do HabitRepository
// Esta declaração é crucial para o Mockito.
class MockHabitRepository extends Mock implements HabitRepository {}

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
  });

  group('GetHabits Use Case', () {
    test('deve retornar uma lista de hábitos do repositório', () async {
      final tHabits = [
        Habit(
          id: '1',
          name: 'Correr',
          notificationTime:
              const app_time_of_day.AppTimeOfDay(hour: 7, minute: 0),
          createdAt: DateTime.now(),
          completionDates: const [],
          highestStreak: 0,
        ),
        Habit(
          id: '2',
          name: 'Ler',
          notificationTime:
              const app_time_of_day.AppTimeOfDay(hour: 20, minute: 0),
          createdAt: DateTime.now(),
          completionDates: const [],
          highestStreak: 0,
        ),
      ];

      when(mockHabitRepository.getHabits()).thenAnswer((_) async => tHabits);

      final result = await getHabitsUseCase.call();

      expect(result, tHabits);
      verify(mockHabitRepository.getHabits());
      verifyNoMoreInteractions(mockHabitRepository);
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
      // Usando isA<Habit>() para ajudar na inferência de tipo do Mockito
      when(mockHabitRepository.saveHabit(any(that: isA<Habit>())))
          .thenAnswer((_) async => Future.value());

      await saveHabitUseCase.call(tHabit);

      verify(mockHabitRepository.saveHabit(tHabit));
      verifyNoMoreInteractions(mockHabitRepository);
    });
  });

  group('DeleteHabit Use Case', () {
    const tId = '123';

    test('deve chamar o método deleteHabit do repositório', () async {
      // Usando isA<String>() para ajudar na inferência de tipo do Mockito
      when(mockHabitRepository.deleteHabit(any(that: isA<String>())))
          .thenAnswer((_) async => Future.value());

      await deleteHabitUseCase.call(tId);

      verify(mockHabitRepository.deleteHabit(tId));
      verifyNoMoreInteractions(mockHabitRepository);
    });
  });
}
