import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../tasbih/presentation/screens/tasbih_screen.dart';
import '../providers/settings_providers.dart';
import '../../../qibla/presentation/screens/qibla_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(settingsControllerProvider);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
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
            title: l10n.tools ,
            children: [
              ListTile(
                leading: const Icon(Icons.touch_app),
                title: Text(l10n.tasbih),
                subtitle: Text(l10n.digitalTasbih),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TasbihScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.explore),
                title: Text(l10n.qiblaDirection),
                subtitle: Text(l10n.qiblaIs.split(':')[0]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QiblaCompass(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildSection(
            title: l10n.about,
            children: [
              ListTile(
                title: Text(l10n.version),
                trailing: const Text('1.0.10'),
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