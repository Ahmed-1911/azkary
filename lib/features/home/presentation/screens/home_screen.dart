import 'package:azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../azkar/presentation/screens/azkar_categories_screen.dart';
import '../../../tasbih/presentation/screens/tasbih_screen.dart';
import '../../../bookmarks/presentation/screens/bookmarks_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';


final selectedIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      const AzkarCategoriesScreen(),
      const TasbihScreen(),
      const BookmarksScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
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
            icon: const Icon(Icons.touch_app_outlined),
            selectedIcon: const Icon(Icons.touch_app),
            label: l10n.tasbih,
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
      ),
    );
  }
} 