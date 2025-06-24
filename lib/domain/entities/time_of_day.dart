import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'time_of_day.g.dart';

@HiveType(typeId: 0)
class TimeOfDay extends Equatable {
  @HiveField(0)
  final int hour;
  @HiveField(1)
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  @override
  List<Object?> get props => [hour, minute];
}
