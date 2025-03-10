import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

class StorageService {
  static const String _morningReminderKey = 'morning_reminder';
  static const String _eveningReminderKey = 'evening_reminder';
  static const String _languageKey = 'language';
  static const String _lastQuranPageKey = 'last_quran_page';
  
  late final SharedPreferences _prefs;
  bool _isInitialized = false;
  
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing StorageService: $e');
      // Create a new instance if there's an error
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }
  
  bool getMorningReminder() {
    _checkInitialization();
    return _prefs.getBool(_morningReminderKey) ?? false;
  }
  
  Future<void> setMorningReminder(bool value) async {
    _checkInitialization();
    await _prefs.setBool(_morningReminderKey, value);
  }
  
  bool getEveningReminder() {
    _checkInitialization();
    return _prefs.getBool(_eveningReminderKey) ?? false;
  }
  
  Future<void> setEveningReminder(bool value) async {
    _checkInitialization();
    await _prefs.setBool(_eveningReminderKey, value);
  }

  String? getLanguage() {
    _checkInitialization();
    return _prefs.getString(_languageKey);
  }

  Future<void> setLanguage(String languageCode) async {
    _checkInitialization();
    await _prefs.setString(_languageKey, languageCode);
  }
  
  int getLastQuranPage() {
    try {
      _checkInitialization();
      return _prefs.getInt(_lastQuranPageKey) ?? 0;
    } catch (e) {
      debugPrint('Error getting last Quran page: $e');
      return 0;
    }
  }
  
  Future<void> setLastQuranPage(int page) async {
    try {
      _checkInitialization();
      await _prefs.setInt(_lastQuranPageKey, page);
    } catch (e) {
      debugPrint('Error saving last Quran page: $e');
    }
  }

  void _checkInitialization() {
    if (!_isInitialized) {
      throw StateError('StorageService not initialized. Call initialize() first.');
    }
  }
} 