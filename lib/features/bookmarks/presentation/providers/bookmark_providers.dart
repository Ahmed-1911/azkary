import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _bookmarksKey = 'bookmarked_azkar';

class BookmarkedAzkarNotifier extends StateNotifier<Set<String>> {
  final SharedPreferences prefs;

  BookmarkedAzkarNotifier(this.prefs) : super({}) {
    _loadBookmarks();
  }

  void _loadBookmarks() {
    final bookmarksJson = prefs.getStringList(_bookmarksKey) ?? [];
    state = Set.from(bookmarksJson);
  }

  Future<void> _saveBookmarks() async {
    await prefs.setStringList(_bookmarksKey, state.toList());
  }

  Future<void> toggleBookmark(String azkarId) async {
    if (state.contains(azkarId)) {
      state = Set.from(state)..remove(azkarId);
    } else {
      state = Set.from(state)..add(azkarId);
    }
    await _saveBookmarks();
  }

  Future<void> removeBookmark(String azkarId) async {
    state = Set.from(state)..remove(azkarId);
    await _saveBookmarks();
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final bookmarkedAzkarProvider = StateNotifierProvider<BookmarkedAzkarNotifier, Set<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BookmarkedAzkarNotifier(prefs);
}); 