import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class HabitStorageService {
  static const String _key = 'habits';

  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((jsonItem) {
      final reminder = jsonItem['reminderTime'];
      return Habit(
        id: jsonItem['id'],
        title: jsonItem['title'],
        description: jsonItem['description'],
        completed: jsonItem['completed'] ?? false,
        reminderTime: TimeOfDay(
          hour: reminder['hour'],
          minute: reminder['minute'],
        ),
        reminderDays: List<int>.from(jsonItem['reminderDays']),
      );
    }).toList();
  }

  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = habits.map((habit) => {
      'id': habit.id,
      'title': habit.title,
      'description': habit.description,
      'completed': habit.completed,
      'reminderTime': {
        'hour': habit.reminderTime.hour,
        'minute': habit.reminderTime.minute,
      },
      'reminderDays': habit.reminderDays,
    }).toList();

    final jsonString = json.encode(jsonList);
    await prefs.setString(_key, jsonString);
  }
}
