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
import 'features/prayer_times/presentation/providers/prayer_times_providers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

// Global provider container for use in main and for background tasks
late ProviderContainer globalContainer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize ads with timeout
  _initializeAds();
  
  // Initialize shared preferences
  final prefs = await _initializeSharedPreferences();
  
  // Create the global provider container
  globalContainer = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  
  // Initialize services
  await _initializeServices(globalContainer);
  
  // Run the app
  runApp(
    UncontrolledProviderScope(
      container: globalContainer,
      child: const MyApp(),
    ),
  );
  
  // Schedule notifications after app is running
  // This is done after runApp to ensure the app is responsive first
  _scheduleNotifications(globalContainer);
}

Future<void> _initializeAds() async {
  try {
    // Initialize Mobile Ads with a timeout
    bool adsInitialized = false;
    
    await Future.any([
      MobileAds.instance.initialize().then((_) {
        adsInitialized = true;
        debugPrint('MobileAds initialized successfully');
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
}

Future<SharedPreferences> _initializeSharedPreferences() async {
  try {
    debugPrint('Initializing SharedPreferences');
    return await SharedPreferences.getInstance();
  } catch (e) {
    // Fallback to create a new instance if there's an error
    debugPrint('Error getting SharedPreferences: $e');
    return await SharedPreferences.getInstance();
  }
}

Future<void> _initializeServices(ProviderContainer container) async {
  // Initialize notification service
  try {
    debugPrint('Initializing notification service');
    await container.read(notificationServiceProvider).initialize();
    debugPrint('Notification service initialized successfully');
  } catch (e) {
    debugPrint('Error initializing notification service: $e');
  }
  
  // Initialize storage service
  try {
    debugPrint('Initializing storage service');
    await container.read(storageServiceProvider).initialize();
    debugPrint('Storage service initialized successfully');
  } catch (e) {
    debugPrint('Error initializing storage service: $e');
  }
  
  // Initialize location
  try {
    debugPrint('Initializing location');
    await container.read(initializeLocationProvider.future);
    debugPrint('Location initialized successfully');
  } catch (e) {
    debugPrint('Error initializing location: $e');
  }
}

void _scheduleNotifications(ProviderContainer container) {
  // Schedule notifications after a short delay to ensure app is responsive
  Future.delayed(const Duration(seconds: 2), () async {
    try {
      debugPrint('Scheduling prayer notifications');
      await container.read(schedulePrayerNotificationsProvider)();
      debugPrint('Prayer notifications scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling prayer notifications: $e');
    }
  });
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
