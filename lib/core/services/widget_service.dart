import 'dart:developer';

import 'package:flutter/services.dart';

class WidgetService {
  static const platform = MethodChannel('com.am.azkary/widget');
  
  static Future<void> updateWidget(String zikr) async {
    try {
      await platform.invokeMethod('updateWidget', {'zikr': zikr});
    } on PlatformException catch (e) {
      log('Failed to update widget: ${e.message}');
      rethrow; // Rethrow to handle the error in the UI
    } catch (e) {
      log('Unexpected error: $e');
      rethrow;
    }
  }
} 