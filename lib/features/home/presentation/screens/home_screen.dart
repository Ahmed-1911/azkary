import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';
import '../../../../core/providers/ui_providers.dart';
import '../../../../core/services/ads_service.dart';
import '../../../azkar/presentation/screens/azkar_categories_screen.dart';
import '../../../quran/presentation/screens/quran_screen.dart';
import '../../../bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../prayer_times/presentation/screens/prayer_times_screen.dart';


final selectedIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    
    // Ensure ads are loaded when the screen is created
    Future.microtask(() {
      if (!_isDisposed && mounted) {
        ref.read(adsServiceProvider.notifier).ensureNativeAdLoaded();
      }
    });
  }

  @override
  void dispose() {
    // Mark as disposed first
    _isDisposed = true;
    
    // Call super.dispose() to mark the widget as disposed
    super.dispose();
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    final l10n = S.of(context);
    
    // Default result is false (don't exit)
    bool shouldExit = false;
    
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Consumer(
          builder: (context, ref, child) {
            final adsService = ref.watch(adsServiceProvider);
            
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24.sp,
                  ),
                 
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pressBackToExit,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Native Ad at the bottom of dialog
                  if (adsService.isNativeAdLoaded && adsService.nativeAd != null)
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      height: 80.h,
                      width: double.infinity,
                      child: AdWidget(ad: adsService.nativeAd!),
                    ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    l10n.cancel,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    l10n.ok,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  onPressed: () {
                    shouldExit = true;
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              elevation: 8,
            );
          },
        );
      },
    );
    
    return shouldExit;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final isBottomNavBarVisible = ref.watch(bottomNavBarVisibilityProvider);
    final l10n = S.of(context);

    final screens = [
      const AzkarCategoriesScreen(),
      const PrayerTimesScreen(),
      const QuranScreen(),
      const BookmarksScreen(),
      const SettingsScreen(),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        
        // If not on the first tab, just go back to the first tab
        if (selectedIndex != 0) {
          ref.read(selectedIndexProvider.notifier).state = 0;
          return;
        }
        
        // Show exit dialog and exit if confirmed
        final shouldExit = await _showExitDialog(context);
        if (shouldExit) {
          // Use SystemNavigator to exit the app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
          body: screens[selectedIndex],
          bottomNavigationBar: isBottomNavBarVisible 
            ? NavigationBar(
                selectedIndex: selectedIndex,   
                elevation: 15,
                height: 70.h,
                shadowColor: Colors.black,     
                onDestinationSelected: (index) =>
                    ref.read(selectedIndexProvider.notifier).state = index,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.menu_book_outlined),
                    selectedIcon: const Icon(Icons.menu_book),
                    label: l10n.azkar,
                  ),
                  
                  NavigationDestination(
                    icon: const Icon(Icons.access_time_outlined),
                    selectedIcon: const Icon(Icons.access_time_filled),
                    label: l10n.prayerTimes ,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.auto_stories_outlined),
                    selectedIcon: const Icon(Icons.auto_stories),
                    label: l10n.quran,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.bookmark_border),
                    selectedIcon: const Icon(Icons.bookmark),
                    label: l10n.bookmarks,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    label: l10n.settings,
                  ),
                ],
              )
            : null,
      ),
    );
  }
} 