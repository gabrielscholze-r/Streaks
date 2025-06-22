import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  ReminderService(this._notificationsPlugin);

  Future<void> init() async {
    // Inicializa suporte a timezone
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notificationsPlugin.initialize(settings);
  }

  Future<void> scheduleHabitReminder({
    required String id,
    required String title,
    required TimeOfDay time,
    required List<int> daysOfWeek,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'habit_channel',
      'Habit Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    for (int weekday in daysOfWeek) {
      final int notifId = _generateNotificationId(id, weekday);

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduled = _nextInstanceOfWeekdayTime(time, weekday);

      await _notificationsPlugin.zonedSchedule(
        notifId,
        'Lembrete de Hábito',
        title,
        scheduled,
        notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfWeekdayTime(TimeOfDay time, int weekday) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(Duration(days: 1));
    }

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(Duration(days: 7));
    }

    return scheduled;
  }

  int _generateNotificationId(String id, int weekday) {
    return id.hashCode ^ weekday;
  }
}
