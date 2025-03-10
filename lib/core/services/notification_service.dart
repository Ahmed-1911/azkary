import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';

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
      final initialized = await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('NotificationService: Notification response received: ${response.payload}');
        },
      );
      
      if (initialized != null && !initialized) {
        debugPrint('NotificationService: Initialization returned false');
        return false;
      }
      
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
      // Cancel any existing notification with this ID
      await _notifications.cancel(id);
      
      // Create the notification details
      const androidDetails = AndroidNotificationDetails(
        'prayer_times_channel',
        'Prayer Times',
        channelDescription: 'Notifications for prayer times',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('adhan'),
      );
      
      // Calculate the next occurrence of this time
      final scheduledTime = _nextInstanceOfTime(time);
      
      // Schedule the notification
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        const NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      
      debugPrint('NotificationService: Prayer notification scheduled for ${scheduledTime.toString()}');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Error scheduling prayer notification: $e');
      return _scheduleSimpleNotification(id, title, body, time);
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
    debugPrint('NotificationService: scheduleDailyNotification called for $id at ${time.hour}:${time.minute}, enabled=$enabled');
    
    if (!_initialized) {
      final initialized = await initialize();
      if (!initialized) {
        debugPrint('NotificationService: Failed to initialize in scheduleDailyNotification');
        return false;
      }
    }
    
    if (!enabled) {
      debugPrint('NotificationService: Notification disabled, cancelling $id');
      await _notifications.cancel(id);
      return true;
    }
    
    return schedulePrayerNotification(
      id: id,
      title: title,
      body: body,
      time: time,
    );
  }
  
  // Fallback method to schedule a simple notification
  Future<bool> _scheduleSimpleNotification(int id, String title, String body, TimeOfDay time) async {
    debugPrint('NotificationService: Trying simple notification scheduling');
    
    try {
      // Create the notification details
      const androidDetails = AndroidNotificationDetails(
        'prayer_times_simple_channel',
        'Prayer Times (Simple)',
        channelDescription: 'Simple notifications for prayer times',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );
      
      // Schedule the notification using a simpler method
      await _notifications.periodicallyShow(
        id,
        title,
        body,
        RepeatInterval.daily,
        const NotificationDetails(android: androidDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      
      debugPrint('NotificationService: Simple notification scheduled successfully');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Even simple notification failed: $e');
      return false;
    }
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