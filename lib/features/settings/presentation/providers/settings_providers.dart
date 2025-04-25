import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/storage_service.dart';
import '../controllers/settings_controller.dart';

final settingsControllerProvider = Provider<SettingsController>((ref) {
  return SettingsController(ref);
});

final fontSizeProvider = StateProvider<double>((ref) => 1.0);

final languageProvider = StateProvider<Locale>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return Locale(storage.getLanguage() ?? 'ar');
}); 