import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/storage_service.dart';
import '../controllers/settings_controller.dart';

final settingsControllerProvider = Provider<SettingsController>((ref) {
  return SettingsController(ref);
});

final notificationTimeProvider = StateProvider<TimeOfDay>((ref) => const TimeOfDay(hour: 5, minute: 0));

final fontSizeProvider = StateProvider<double>((ref) => 1.0);

final languageProvider = StateProvider<Locale>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return Locale(storage.getLanguage() ?? 'en');
});

class ReminderNotifier extends StateNotifier<bool> {
  final StorageService storage;
  final bool isForMorning;

  ReminderNotifier({
    required this.storage,
    required this.isForMorning,
    required bool initialValue,
  }) : super(initialValue);

  Future<void> toggle(bool value) async {
    state = value;
    if (isForMorning) {
      await storage.setMorningReminder(value);
    } else {
      await storage.setEveningReminder(value);
    }
  }
}

final morningReminderProvider = StateNotifierProvider<ReminderNotifier, bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ReminderNotifier(
    storage: storage,
    isForMorning: true,
    initialValue: storage.getMorningReminder(),
  );
});

final eveningReminderProvider = StateNotifierProvider<ReminderNotifier, bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ReminderNotifier(
    storage: storage,
    isForMorning: false,
    initialValue: storage.getEveningReminder(),
  );
}); 