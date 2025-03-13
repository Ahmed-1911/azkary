import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/notification_service.dart';
import '../../../tasbih/presentation/screens/tasbih_screen.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(settingsControllerProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final morningReminder = ref.watch(morningReminderProvider);
    final eveningReminder = ref.watch(eveningReminderProvider);
    final fontSize = ref.watch(fontSizeProvider);
    final notificationService = ref.watch(notificationServiceProvider);
    final l10n = S.of(context);
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
                onChanged: controller.toggleTheme,
              ),
              ListTile(
                title: Text(l10n.fontSize),
                subtitle: Slider(
                  value: fontSize,
                  min: 0.8,
                  max: 1.4,
                  divisions: 6,
                  label: '${(fontSize * 100).round()}%',
                  onChanged: controller.setFontSize,
                ),
              ),
              ListTile(
                title: Text(l10n.language),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentLanguage.languageCode == 'en' ? 'English' : 'العربية',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.w,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
                onTap: () => controller.showLanguageDialog(context),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildSection(
            title: l10n.tools ?? 'Tools',
            children: [
              ListTile(
                leading: const Icon(Icons.touch_app),
                title: Text(l10n.tasbih),
                subtitle: Text(l10n.digitalTasbih ?? 'Digital Tasbih Counter'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TasbihScreen(),
                    ),
                  );
                },
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
                onChanged: (value) => controller.handleNotificationToggle(
                  context: context,
                  notificationService: notificationService,
                  reminderProvider: morningReminderProvider,
                  value: value,
                  id: 1,
                  title: l10n.morningAzkar,
                  body: l10n.timeForYourMorningRemembrance,
                  time: const TimeOfDay(hour: 5, minute: 0),
                ),
              ),
              SwitchListTile(
                title: Text(l10n.eveningAzkarReminder),
                subtitle: Text(l10n.dailyReminderForEveningAzkar),
                value: eveningReminder,
                onChanged: (value) => controller.handleNotificationToggle(
                  context: context,
                  notificationService: notificationService,
                  reminderProvider: eveningReminderProvider,
                  value: value,
                  id: 2,
                  title: l10n.eveningAzkar,
                  body: l10n.timeForYourEveningRemembrance,
                  time: const TimeOfDay(hour: 17, minute: 0),
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
                trailing: const Text('1.0.4'),
              ),
            
              ListTile(
                leading: const Icon(Icons.star_rate_rounded),
                title: Text(l10n.rateApp),
                onTap: () => controller.rateApp(context),
              ),
              ListTile(
                leading: const Icon(Icons.share_rounded),
                title: Text(l10n.shareApp),
                onTap: () => controller.shareApp(context),
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