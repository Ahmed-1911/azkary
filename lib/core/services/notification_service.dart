import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _initialized = false;
  
  // Initialize the notification service
  Future<bool> initialize() async {
    if (_initialized) return true;
    
    debugPrint('NotificationService: Notifications disabled');
    _initialized = true;
    return true;
  }
  
  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    return false;
  }
  
  // Show an immediate test notification
  Future<bool> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    debugPrint('NotificationService: Notifications disabled, not showing immediate notification');
    return false;
  }
  
  // Schedule a test notification with a short delay (30 seconds)
  Future<bool> scheduleTestNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    debugPrint('NotificationService: Notifications disabled, not scheduling test notification');
    return false;
  }
  
  // Open notification settings
  Future<void> openNotificationSettings() async {
    debugPrint('NotificationService: Notifications disabled, not opening settings');
  }
  
  // Schedule a prayer time notification
  Future<bool> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    debugPrint('NotificationService: Notifications disabled, not scheduling prayer notification');
    return false;
  }
  
  // For backward compatibility with existing code
  Future<bool> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required bool enabled,
  }) async {
    debugPrint('NotificationService: Notifications disabled, not scheduling daily notification');
    return false;
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    debugPrint('NotificationService: Notifications disabled, nothing to cancel');
  }
  
  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    debugPrint('NotificationService: Notifications disabled, nothing to cancel');
  }
} 