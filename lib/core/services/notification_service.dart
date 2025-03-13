import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:typed_data';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  
  // Initialize the notification service
  Future<bool> initialize() async {
    if (_initialized) return true;
    
    debugPrint('NotificationService: Starting initialization');
    
    try {
      // Initialize timezone data
      tz.initializeTimeZones();
      
      // Define the initialization settings for Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettings = InitializationSettings(android: androidSettings);
      
      // Initialize the plugin
      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('NotificationService: Notification response received: ${response.payload}');
        },
      );
      
      // Request permissions
      final permissionGranted = await _requestPermissions();
      
      _initialized = true;
      debugPrint('NotificationService: Initialization complete, permissions granted: $permissionGranted');
      return permissionGranted;
    } catch (e) {
      debugPrint('NotificationService: Error during initialization: $e');
      return false;
    }
  }
  
  // Request notification permissions
  Future<bool> _requestPermissions() async {
    debugPrint('NotificationService: Requesting permissions');
    try {
      // Request notification permission
      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
          
      if (androidImplementation != null) {
        final granted = await androidImplementation.requestNotificationsPermission();
        debugPrint('NotificationService: Notification permission granted: $granted');
        
        // Request exact alarms permission
        final exactAlarmsGranted = await androidImplementation.requestExactAlarmsPermission();
        debugPrint('NotificationService: Exact alarms permission granted: $exactAlarmsGranted');
        
        return granted ?? false;
      }
      
      debugPrint('NotificationService: Android implementation not found');
      return false;
    } catch (e) {
      debugPrint('NotificationService: Error requesting permissions: $e');
      return false;
    }
  }
  
  // Schedule a prayer time notification
  Future<bool> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    if (!_initialized) {
      final initialized = await initialize();
      if (!initialized) return false;
    }
    
    debugPrint('NotificationService: Scheduling prayer notification $id at ${time.hour}:${time.minute}');
    
    try {
      // Create the notification details
      final androidDetails = AndroidNotificationDetails(
        'prayer_times_channel',
        'Prayer Times',
        channelDescription: 'Notifications for prayer times',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('adhan'),
        enableVibration: true,
        category: AndroidNotificationCategory.alarm,
        fullScreenIntent: true,
        visibility: NotificationVisibility.public,
      );
      
      // Calculate the next occurrence of this time
      final scheduledTime = _nextInstanceOfTime(time);
      
      // Show the notification immediately with a scheduled time
      await _notifications.show(
        id,
        title,
        body,
        NotificationDetails(android: androidDetails),
        payload: 'prayer_notification_$id',
      );
      
      debugPrint('NotificationService: Prayer notification scheduled for ${scheduledTime.toString()}');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Error scheduling prayer notification: $e');
      return false;
    }
  }
  
  // For backward compatibility with existing code
  Future<bool> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required bool enabled,
  }) async {
    if (!enabled) {
      debugPrint('NotificationService: Notification disabled, cancelling $id');
      try {
        await _notifications.cancel(id);
      } catch (e) {
        debugPrint('NotificationService: Error cancelling notification: $e');
      }
      return true;
    }
    
    return schedulePrayerNotification(
      id: id,
      title: title,
      body: body,
      time: time,
    );
  }
  
  // Calculate the next occurrence of a specific time
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
      debugPrint('NotificationService: Time is in the past, scheduling for tomorrow');
    }
    
    return scheduledDate;
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    debugPrint('NotificationService: Cancelling all notifications');
    
    try {
      await _notifications.cancelAll();
      debugPrint('NotificationService: All notifications cancelled');
    } catch (e) {
      debugPrint('NotificationService: Error cancelling notifications: $e');
    }
  }
  
  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    debugPrint('NotificationService: Cancelling notification $id');
    
    try {
      await _notifications.cancel(id);
      debugPrint('NotificationService: Notification $id cancelled');
    } catch (e) {
      debugPrint('NotificationService: Error cancelling notification $id: $e');
    }
  }
} 