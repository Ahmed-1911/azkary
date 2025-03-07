import 'package:azkary/features/settings/presentation/providers/settings_providers.dart';
import 'package:azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'features/azkar/presentation/screens/splash_screen.dart';
import 'features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Mobile Ads with a timeout
    bool adsInitialized = false;
    
    await Future.any([
      MobileAds.instance.initialize().then((_) {
        adsInitialized = true;
      }),
      Future.delayed(const Duration(seconds: 5)).then((_) {
        if (!adsInitialized) {
          debugPrint('MobileAds initialization timed out, continuing anyway');
        }
      })
    ]);
  } catch (e) {
    // Continue even if ads initialization fails
    debugPrint('MobileAds initialization failed: $e');
  }
  
  late SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    // Fallback to create a new instance if there's an error
    debugPrint('Error getting SharedPreferences: $e');
    prefs = await SharedPreferences.getInstance();
  }
  
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  
  try {
    await container.read(notificationServiceProvider).initialize();
  } catch (e) {
    debugPrint('Error initializing notification service: $e');
  }
  
  try {
    await container.read(storageServiceProvider).initialize();
  } catch (e) {
    debugPrint('Error initializing storage service: $e');
  }
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);
    
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Azkary',
          theme: AppTheme.lightTheme.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: AppTheme.darkTheme.copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          themeMode: ref.watch(themeProvider),
          locale: currentLanguage,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
        );
      },
    );
  }
}
