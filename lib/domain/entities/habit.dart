import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:streaks/domain/entities/time_of_day.dart'; 

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final List<int> reminderDays;
  @HiveField(4)
  final AppTimeOfDay notificationTime; 
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime? lastCompleted;
  @HiveField(7)
  final int streakCount;
  @HiveField(8) 
  final List<DateTime> completionDates; 
  @HiveField(9) 
  final int highestStreak; 

  const Habit({
    required this.id,
    required this.name,
    this.description = '',
    this.reminderDays = const [],
    required this.notificationTime, 
    required this.createdAt,
    this.lastCompleted,
    this.streakCount = 0,
    this.completionDates = const [], 
    this.highestStreak = 0, 
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        reminderDays,
        notificationTime,
        createdAt,
        lastCompleted,
        streakCount,
        completionDates, 
        highestStreak, 
      ];

  Habit copyWith({
    String? id,
    String? name,
    String? description,
    List<int>? reminderDays,
    AppTimeOfDay? notificationTime, 
    DateTime? createdAt,
    DateTime? lastCompleted,
    int? streakCount,
    List<DateTime>? completionDates, 
    int? highestStreak, 
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      reminderDays: reminderDays ?? this.reminderDays,
      notificationTime: notificationTime ?? this.notificationTime, 
      createdAt: createdAt ?? this.createdAt,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      streakCount: streakCount ?? this.streakCount,
      completionDates: completionDates ?? this.completionDates,
      highestStreak: highestStreak ?? this.highestStreak,
    );
  }
}