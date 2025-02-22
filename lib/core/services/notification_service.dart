import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/services.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  
  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings = InitializationSettings(android: androidSettings);
    
    await _notifications.initialize(initializationSettings);
  }

  Future<bool> requestPermission() async {
    final platform = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (platform != null) {
      // For Android 13 and above
      final granted = await platform.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  Future<bool> requestExactAlarmPermission() async {
    try {
      final platform = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (platform != null) {
        return await platform.requestExactAlarmsPermission() ?? false;
      }
      return false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required bool enabled,
  }) async {
    if (!enabled) {
      await _notifications.cancel(id);
      return;
    }

    // Request exact alarm permission
    final hasExactAlarmPermission = await requestExactAlarmPermission();
    if (!hasExactAlarmPermission) {
      throw PlatformException(
        code: 'exact_alarms_not_permitted',
        message: 'Please grant permission for exact alarms in system settings',
      );
    }

    const androidDetails = AndroidNotificationDetails(
      'azkar_reminders',
      'Azkar Reminders',
      channelDescription: 'Daily reminders for Azkar',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(time),
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
} 