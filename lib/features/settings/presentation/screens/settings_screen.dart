import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../l10n/app_localizations.dart';

final notificationTimeProvider = StateProvider<TimeOfDay>((ref) => const TimeOfDay(hour: 5, minute: 0));

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

final fontSizeProvider = StateProvider<double>((ref) => 1.0);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _handleNotificationToggle({
    required BuildContext context,
    required NotificationService notificationService,
    required StateNotifierProvider<ReminderNotifier, bool> reminderProvider,
    required bool value,
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required WidgetRef ref,
  }) async {
    try {
      if (value) {
        final hasPermission = await notificationService.requestPermission();
        if (!hasPermission) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enable notifications in system settings'),
              ),
            );
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
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)?.permissionRequired ?? 'Permission Required'),
              content: const Text('This app needs permission to schedule exact alarms for Azkar reminders. Please grant this permission in system settings.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Open system settings for exact alarms
                    notificationService.requestExactAlarmPermission();
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)?.openSettings ?? 'Open Settings'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text( 'Failed to schedule notification: ${e.message}'),
            ),
          );
        }
        ref.read(reminderProvider.notifier).toggle(false);
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final morningReminder = ref.watch(morningReminderProvider);
    final eveningReminder = ref.watch(eveningReminderProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final notificationService = ref.watch(notificationServiceProvider);
    final l10n = AppLocalizations.of(context)!;
    final currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _buildSection(
            title: l10n.appearance,
            children: [
              SwitchListTile(
                title: Text(l10n.darkMode),
                value: isDarkMode,
                onChanged: (value) {
                  ref.read(themeProvider.notifier).setTheme(
                    value ? ThemeMode.dark : ThemeMode.light
                  );
                },
              ),
              ListTile(
                title: Text(l10n.fontSize),
                subtitle: Slider(
                  value: fontSize,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(fontSize * 100).round()}%',
                  onChanged: (value) {
                    ref.read(fontSizeProvider.notifier).state = value;
                  },
                ),
              ),
              
              ListTile(
                title: Text(l10n.language),
                trailing: DropdownButton<String>(
                  value: currentLanguage.languageCode,
                  items: const [
                    DropdownMenuItem(
                      value: 'en',
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: 'ar',
                      child: Text('العربية'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(languageProvider.notifier).state = Locale(value);
                      ref.read(storageServiceProvider).setLanguage(value);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildSection(
            title: l10n.notifications,
            children: [
              SwitchListTile(
                title: Text(l10n.morningAzkarReminder),
                subtitle: Text(l10n.dailyReminderForMorningAzkar),
                value: morningReminder,
                onChanged: (value) => _handleNotificationToggle(
                  context: context,
                  notificationService: notificationService,
                  reminderProvider: morningReminderProvider,
                  value: value,
                  id: 1,
                  title: l10n.morningAzkar,
                  body: l10n.timeForYourMorningRemembrance,
                  time: const TimeOfDay(hour: 5, minute: 0),
                  ref: ref,
                ),
              ),
              SwitchListTile(
                title: Text(l10n.eveningAzkarReminder),
                subtitle: Text(l10n.dailyReminderForEveningAzkar),
                value: eveningReminder,
                onChanged: (value) => _handleNotificationToggle(
                  context: context,
                  notificationService: notificationService,
                  reminderProvider: eveningReminderProvider,
                  value: value,
                  id: 2,
                  title: l10n.eveningAzkar,
                  body: l10n.timeForYourEveningRemembrance,
                  time: const TimeOfDay(hour: 17, minute: 0),
                  ref: ref,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildSection(
            title: l10n.about,
            children: [
             ListTile(
                title: Text(l10n.version),
                trailing: const Text('1.0.0'),
              ),
              ListTile(
                title: Text(l10n.developer),
                trailing: const Text('Ahmed Abdelsalam'),
                onTap: () {
                  // TODO: Open developer website/contact
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
} 