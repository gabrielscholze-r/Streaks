import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:streaks/data/datasources/habit_local_data_source.dart';
import 'package:streaks/data/datasources/habit_local_data_source_impl.dart';
import 'package:streaks/data/repositories/habit_repository_impl.dart';
import 'package:streaks/domain/repositories/habit_repository.dart';
import 'package:streaks/domain/entities/habit.dart';
import 'package:streaks/domain/entities/time_of_day.dart';
import 'package:streaks/domain/usecases/get_habits.dart';
import 'package:streaks/domain/usecases/save_habit.dart';
import 'package:streaks/domain/usecases/delete_habit.dart';
import 'package:streaks/presentation/viewmodels/home_page_viewmodel.dart';
import 'package:streaks/presentation/viewmodels/add_edit_habit_viewmodel.dart';


final sl = GetIt.instance;

Future<void> init(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(() => flutterLocalNotificationsPlugin);

  sl.registerFactory(() => HomePageViewModel(
        getHabits: sl(),
        saveHabit: sl(),
        deleteHabit: sl(),
        localNotificationsPlugin: sl()
      ));
  sl.registerFactory(() => AddEditHabitViewModel(
        saveHabit: sl(),
        uuid: sl(),
        localNotificationsPlugin: sl(),
      ));

  sl.registerLazySingleton(() => GetHabits(sl()));
  sl.registerLazySingleton(() => SaveHabit(sl()));
  sl.registerLazySingleton(() => DeleteHabit(sl()));

  sl.registerLazySingleton<HabitRepository>(
    () => HabitRepositoryImpl(localDataSource: sl()),
  );

  sl.registerLazySingleton<HabitLocalDataSource>(
    () => HabitLocalDataSourceImpl(sl()),
  );

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());

  final habitBox = await Hive.openBox<Habit>('habits');
  sl.registerLazySingleton<Box<Habit>>(() => habitBox);
  sl.registerLazySingleton(() => const Uuid());
}