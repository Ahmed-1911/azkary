import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
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
      // We don't need to check permissions here anymore as the notification service
      // will handle this internally when scheduling notifications
      
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
          _showExactAlarmPermissionDialog(context);
        } else {
          _showErrorSnackBar(context, e.message);
        }
        ref.read(reminderProvider.notifier).toggle(false);
      }
    }
  }

  Future<void> rateApp(BuildContext context) async {
    const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.am.azkary';
    
    try {
      final uri = Uri.parse(playStoreUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          _showErrorSnackBar(context, 'Could not open app store');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error opening app store: $e');
      }
    }
  }

  Future<void> shareApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final appName = l10n?.appName ?? 'Azkary';
    
    final message = 'Check out $appName - a great app for Islamic remembrance and prayer times!\n\nhttps://play.google.com/store/apps/details?id=com.am.azkary';
    
    try {
      await Share.share(message);
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error sharing app: $e');
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

  void _showExactAlarmPermissionDialog(BuildContext context) {
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
              // Open system settings instead of requesting permission directly
              Navigator.pop(context);
              // We would ideally open the system settings here, but for now just close the dialog
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