import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  static const String _morningReminderKey = 'morning_reminder';
  static const String _eveningReminderKey = 'evening_reminder';
  static const String _languageKey = 'language';
  
  late final SharedPreferences _prefs;
  
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  bool getMorningReminder() {
    return _prefs.getBool(_morningReminderKey) ?? false;
  }
  
  Future<void> setMorningReminder(bool value) async {
    await _prefs.setBool(_morningReminderKey, value);
  }
  
  bool getEveningReminder() {
    return _prefs.getBool(_eveningReminderKey) ?? false;
  }
  
  Future<void> setEveningReminder(bool value) async {
    await _prefs.setBool(_eveningReminderKey, value);
  }

  String? getLanguage() {
    return _prefs.getString(_languageKey);
  }

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }
} 