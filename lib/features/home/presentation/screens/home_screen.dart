import 'package:azkary/generated/l10n.dart';
import 'package:azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/ui_providers.dart';
import '../../../azkar/presentation/screens/azkar_categories_screen.dart';
import '../../../quran/presentation/screens/quran_screen.dart';
import '../../../bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../prayer_times/presentation/screens/prayer_times_screen.dart';


final selectedIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final isBottomNavBarVisible = ref.watch(bottomNavBarVisibilityProvider);
    final l10n = S.of(context)!;

    final screens = [
      const AzkarCategoriesScreen(),
      const PrayerTimesScreen(),
      const QuranScreen(),
      const BookmarksScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: isBottomNavBarVisible 
        ? NavigationBar(
            selectedIndex: selectedIndex,   
            elevation: 15,
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
    );
  }
} 