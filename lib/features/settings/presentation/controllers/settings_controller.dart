import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/settings_providers.dart';

class SettingsController {
  final Ref ref;

  SettingsController(this.ref);

  void toggleTheme(bool isDark) {
    ref.read(themeProvider.notifier).setTheme(
      isDark ? ThemeMode.dark : ThemeMode.light
    );
  }

  void setFontSize(double size) {
    ref.read(fontSizeProvider.notifier).state = size;
  }

  void setLanguage(String languageCode) {
    ref.read(languageProvider.notifier).state = Locale(languageCode);
    ref.read(storageServiceProvider).setLanguage(languageCode);
  }

  Future<void> handleNotificationToggle({
    required BuildContext context,
    required NotificationService notificationService,
    required StateNotifierProvider<ReminderNotifier, bool> reminderProvider,
    required bool value,
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    try {
      if (value) {
        final hasPermission = await notificationService.requestPermission();
        if (!hasPermission) {
          if (context.mounted) {
            _showPermissionSnackBar(context);
          }
          return;
        }
      }
      
      await notificationService.scheduleDailyNotification(
        id: id,
        title: title,
        body: body,
        time: time,
        enabled: value,
      );

      if (context.mounted) {
        ref.read(reminderProvider.notifier).toggle(value);
      }
    } on PlatformException catch (e) {
      if (context.mounted) {
        if (e.code == 'exact_alarms_not_permitted') {
          _showExactAlarmPermissionDialog(context, notificationService);
        } else {
          _showErrorSnackBar(context, e.message);
        }
        ref.read(reminderProvider.notifier).toggle(false);
      }
    }
  }

  void _showPermissionSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.notificationPermission ?? 'Please enable notifications in system settings'),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to schedule notification: $message'),
      ),
    );
  }

  void _showExactAlarmPermissionDialog(BuildContext context, NotificationService notificationService) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.permissionRequired ?? 'Permission Required'),
        content: Text(l10n?.exactAlarmPermission ?? 'This app needs permission to schedule exact alarms for Azkar reminders. Please grant this permission in system settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              notificationService.requestExactAlarmPermission();
              Navigator.pop(context);
            },
            child: Text(l10n?.openSettings ?? 'Open Settings'),
          ),
        ],
      ),
    );
  }

  void showLanguageDialog(BuildContext context) {
    final currentLanguage = ref.read(languageProvider);
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Radio<String>(
                value: 'en',
                groupValue: currentLanguage.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    setLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
              title: const Text('English'),
              onTap: () {
                setLanguage('en');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Radio<String>(
                value: 'ar',
                groupValue: currentLanguage.languageCode,
                onChanged: (value) {
                  if (value != null) {
                    setLanguage(value);
                    Navigator.pop(context);
                  }
                },
              ),
              title: const Text('العربية'),
              onTap: () {
                setLanguage('ar');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
} 