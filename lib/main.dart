import 'package:azkary/features/settings/presentation/providers/settings_providers.dart';
import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/services/storage_service.dart';
import 'core/services/ads_service.dart';
import 'features/azkar/presentation/screens/splash_screen.dart';
import 'features/bookmarks/presentation/providers/bookmark_providers.dart';
import 'features/prayer_times/presentation/providers/prayer_times_providers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter_localizations/flutter_localizations.dart';

// Global provider container for use in main and for background tasks
late ProviderContainer globalContainer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock app orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
}

Future<void> _initializeAds() async {
  try {
    // Initialize Mobile Ads SDK with a timeout
    bool adsInitialized = false;
    
    await Future.any([
      MobileAds.instance.initialize().then((_) {
        adsInitialized = true;
        debugPrint('MobileAds SDK initialized successfully');
      }),
      Future.delayed(const Duration(seconds: 5)).then((_) {
        if (!adsInitialized) {
          debugPrint('MobileAds SDK initialization timed out, continuing anyway');
        }
      })
    ]);
  } catch (e) {
    // Continue even if ads initialization fails
    debugPrint('MobileAds SDK initialization failed: $e');
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
  // Initialize storage service
  try {
    debugPrint('Initializing storage service');
    await container.read(storageServiceProvider).initialize();
    debugPrint('Storage service initialized successfully');
  } catch (e) {
    debugPrint('Error initializing storage service: $e');
  }
  
  // Initialize ads service
  try {
    debugPrint('Initializing ads service');
    await container.read(adsServiceProvider.notifier).initialize();
    debugPrint('Ads service initialized successfully');
  } catch (e) {
    debugPrint('Error initializing ads service: $e');
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
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const AppLifecycleObserver(child: SplashScreen()),
        );
      },
    );
  }
}

// Widget to observe app lifecycle and dispose ads when app is closed
class AppLifecycleObserver extends ConsumerStatefulWidget {
  final Widget child;
  
  const AppLifecycleObserver({super.key, required this.child});
  
  @override
  ConsumerState<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends ConsumerState<AppLifecycleObserver> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('App lifecycle state changed to: $state');
    
    if (state == AppLifecycleState.detached) {
      // App is being terminated, dispose all ads
      debugPrint('App is being terminated, disposing all ads');
      ref.read(adsServiceProvider.notifier).disposeAllAds();
    } else if (state == AppLifecycleState.resumed) {
      // App is coming to the foreground, ensure ads are loaded
      debugPrint('App is resuming, ensuring ads are loaded');
      ref.read(adsServiceProvider.notifier).initialize();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
