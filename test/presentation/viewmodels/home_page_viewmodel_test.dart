import 'package:flutter_test/flutter_test.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/entities/time_of_day.dart' as app_time_of_day;
import 'package:streaks/domain/repositories/habit_repository.dart';
import 'package:streaks/domain/usecases/get_habits.dart';
import 'package:streaks/domain/usecases/save_habit.dart';
import 'package:streaks/domain/usecases/delete_habit.dart';
import 'package:streaks/presentation/viewmodels/home_page_viewmodel.dart';

class DummyHabitRepository implements HabitRepository {
  @override
  Future<void> deleteHabit(String id) => Future.value();
  @override
  Future<List<Habit>> getHabits() => Future.value([]);
  @override
  Future<void> saveHabit(Habit habit) => Future.value();
  @override
  Future<void> updateHabit(Habit habit) => Future.value();
}

class MockGetHabits implements GetHabits {
  @override
  final HabitRepository repository;

  MockGetHabits(this.repository);

  List<Habit> Function()? _mockCall;
  void setMockCall(List<Habit> Function() callback) => _mockCall = callback;

  @override
  Future<List<Habit>> call() async {
    if (_mockCall != null) {
      return _mockCall!();
    }
    return [];
  }
}

class MockSaveHabit implements SaveHabit {
  @override
  final HabitRepository repository;

  MockSaveHabit(this.repository);

  Habit? _capturedHabit;
  @override
  Future<void> call(Habit habit) async {
    _capturedHabit = habit;
  }

  Habit? get capturedHabit => _capturedHabit;
}

class MockDeleteHabit implements DeleteHabit {
  @override
  final HabitRepository repository;

  MockDeleteHabit(this.repository);

  String? _capturedId;
  @override
  Future<void> call(String id) async {
    _capturedId = id;
  }

  String? get capturedId => _capturedId;
}

void main() {
  late HomePageViewModel viewModel;
  late MockGetHabits mockGetHabits;
  late MockSaveHabit mockSaveHabit;
  late MockDeleteHabit mockDeleteHabit;
  final dummyHabitRepository = DummyHabitRepository();

  setUp(() {
    mockGetHabits = MockGetHabits(dummyHabitRepository);
    mockSaveHabit = MockSaveHabit(dummyHabitRepository);
    mockDeleteHabit = MockDeleteHabit(dummyHabitRepository);

    viewModel = HomePageViewModel(
      getHabits: mockGetHabits,
      saveHabit: mockSaveHabit,
      deleteHabit: mockDeleteHabit,
      localNotificationsPlugin: null,
    );
  });

  group('HomePageViewModel', () {
    final tHabit = Habit(
      id: '1',
      name: 'Teste Habit',
      description: 'Descrição do teste',
      notificationTime: const app_time_of_day.AppTimeOfDay(hour: 9, minute: 0),
      createdAt: DateTime(2023, 1, 1),
      streakCount: 0,
      lastCompleted: null,
      completionDates: const [],
      highestStreak: 0,
    );

    test('fetchHabits deve carregar hábitos e definir isLoading como false',
        () async {
      mockGetHabits.setMockCall(() => [tHabit]);

      await viewModel.fetchHabits();

      expect(viewModel.habits, [tHabit]);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
    });

    test('markHabitComplete deve atualizar a streak e o lastCompleted',
        () async {
      final initialHabit = Habit(
        id: '1',
        name: 'Teste Streak',
        notificationTime:
            const app_time_of_day.AppTimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime(2023, 1, 1),
        streakCount: 0,
        lastCompleted: null,
        completionDates: const [],
        highestStreak: 0,
      );

      mockGetHabits.setMockCall(() => [
            initialHabit.copyWith(
                streakCount: 1,
                lastCompleted: DateTime.now(),
                completionDates: [DateTime.now()],
                highestStreak: 1)
          ]);

      await viewModel.markHabitComplete(initialHabit);

      final captured = mockSaveHabit.capturedHabit;

      expect(captured?.streakCount, 1);
      expect(captured?.lastCompleted, isNotNull);
      expect(captured?.completionDates.length, 1);
      expect(captured?.highestStreak, 1);
    });

    test(
        'deleteHabit deve chamar o use case de exclusão (sem lógica de notificação)',
        () async {
      const habitId = 'test_id';

      await viewModel.deleteHabit(habitId);

      expect(mockDeleteHabit.capturedId, habitId);
    });
  });
}
