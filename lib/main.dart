import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:streaks/presentation/pages/splash_screen.dart'; 
import 'package:streaks/core/di/injection_container.dart' as di;
import 'package:streaks/core/theme/app_theme.dart';

final sl = GetIt.instance;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
      'background notification response: ${notificationResponse.payload}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (defaultTargetPlatform == TargetPlatform.android) {
    var status = await Permission.scheduleExactAlarm.status;

    if (status.isDenied) {
      status = await Permission.scheduleExactAlarm.request();
    }
    if (status.isPermanentlyDenied) {
      debugPrint(
          'Exact alarm permission permanently denied. Opening settings...');
      await openAppSettings();
    } else if (status.isGranted) {
      debugPrint('Exact alarm permission granted.');
    } else {
      debugPrint('Exact alarm permission status: $status');
    }
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      debugPrint('Notification payload: ${response.payload}');
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  await di.init(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaks',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
