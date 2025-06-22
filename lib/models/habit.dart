import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final String description;
  bool completed;
  final TimeOfDay reminderTime;
  final List<int> reminderDays;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
    required this.reminderTime,
    required this.reminderDays,
  });
}
