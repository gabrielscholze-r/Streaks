import 'package:flutter_test/flutter_test.dart'; // Contém setUp, group, test, expect, isNull, isNotNull
import 'package:mockito/mockito.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/entities/time_of_day.dart' as app_time_of_day;
import 'package:streaks/domain/usecases/get_habits.dart';
import 'package:streaks/domain/usecases/save_habit.dart';
import 'package:streaks/domain/usecases/delete_habit.dart';
import 'package:streaks/presentation/viewmodels/home_page_viewmodel.dart';

// Mocks
class MockGetHabits extends Mock implements GetHabits {}
class MockSaveHabit extends Mock implements SaveHabit {}
class MockDeleteHabit extends Mock implements DeleteHabit {}
class MockFlutterLocalNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {}

void main() {
  late HomePageViewModel viewModel;
  late MockGetHabits mockGetHabits;
  late MockSaveHabit mockSaveHabit;
  late MockDeleteHabit mockDeleteHabit;
  late MockFlutterLocalNotificationsPlugin mockLocalNotificationsPlugin;

  setUp(() {
    mockGetHabits = MockGetHabits();
    mockSaveHabit = MockSaveHabit();
    mockDeleteHabit = MockDeleteHabit();
    mockLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();

    viewModel = HomePageViewModel(
      getHabits: mockGetHabits,
      saveHabit: mockSaveHabit,
      deleteHabit: mockDeleteHabit,
      localNotificationsPlugin: mockLocalNotificationsPlugin,
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

    test('fetchHabits deve carregar hábitos e definir isLoading como false', () async {
      when(mockGetHabits.call()).thenAnswer((_) async => [tHabit]);

      await viewModel.fetchHabits();

      expect(viewModel.habits, [tHabit]);
      expect(viewModel.isLoading, false);
      expect(viewModel.errorMessage, isNull);
      verify(mockGetHabits.call());
    });

    test('markHabitComplete deve atualizar a streak e o lastCompleted', () async {
      final initialHabit = Habit(
        id: '1',
        name: 'Teste Streak',
        notificationTime: const app_time_of_day.AppTimeOfDay(hour: 9, minute: 0),
        createdAt: DateTime(2023, 1, 1),
        streakCount: 0,
        lastCompleted: null,
        completionDates: const [],
        highestStreak: 0,
      );

      // Usando isA<Habit>() para ajudar na inferência de tipo do Mockito
      when(mockSaveHabit.call(any(that: isA<Habit>()))).thenAnswer((_) async => Future.value());
      when(mockGetHabits.call()).thenAnswer((_) async => [initialHabit.copyWith(streakCount: 1, lastCompleted: DateTime.now())]); // Mock para o fetch após save

      await viewModel.markHabitComplete(initialHabit);

      // Captura o argumento passado para saveHabit
      final captured = verify(mockSaveHabit.call(captureAny)).captured.single as Habit;

      expect(captured.streakCount, 1);
      expect(captured.lastCompleted, isNotNull);
      expect(captured.completionDates.length, 1); // Deve ter 1 data de conclusão
      expect(captured.highestStreak, 1); // A maior streak deve ser 1
      verify(mockGetHabits.call()); // Verifica se fetchHabits foi chamado
    });

    test('deleteHabit deve chamar o use case de exclusão e cancelar notificações', () async {
      const habitId = 'test_id';
      // Usando isA<String>() e isA<int>() para ajudar na inferência de tipo do Mockito
      when(mockDeleteHabit.call(any(that: isA<String>()))).thenAnswer((_) async => Future.value());
      when(mockLocalNotificationsPlugin.cancel(any(that: isA<int>()))).thenAnswer((_) async => Future.value());
      when(mockGetHabits.call()).thenAnswer((_) async => []); // Mock para fetch após delete

      await viewModel.deleteHabit(habitId);

      verify(mockDeleteHabit.call(habitId));
      // Verifica se o cancelamento de notificações foi chamado para os 7 dias
      for (int i = 0; i < 7; i++) {
        verify(mockLocalNotificationsPlugin.cancel(habitId.hashCode + i)).called(1);
      }
      verify(mockGetHabits.call()); // Verifica se fetchHabits foi chamado
    });
  });
}