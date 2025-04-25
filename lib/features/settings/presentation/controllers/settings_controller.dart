import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/l10n.dart';
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
    final l10n = S.of(context);
    final appName = l10n.appName;
    
    final message = 'Check out $appName - a great app for Islamic remembrance and prayer times!\n\nhttps://play.google.com/store/apps/details?id=com.am.azkary';
    
    try {
      await Share.share(message);
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar(context, 'Error sharing app: $e');
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
      ),
    );
  }

  void showLanguageDialog(BuildContext context) {
    final currentLanguage = ref.read(languageProvider);
    final l10n = S.of(context);
    
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