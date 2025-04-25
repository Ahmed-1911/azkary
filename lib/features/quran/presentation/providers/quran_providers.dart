import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:azkary/core/services/storage_service.dart';
import 'package:azkary/core/services/ads_service.dart';
import 'package:flutter/material.dart';
import 'package:azkary/generated/l10n.dart';

// Provider for the current Quran page
final currentQuranPageProvider = StateProvider<int>((ref) {
  // Initialize with the last viewed page from storage
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getLastQuranPage();
});

// Provider for the total number of pages in the Quran
final totalQuranPagesProvider = Provider<int>((ref) => 604);

// Provider for the full-screen mode state
final isQuranFullScreenProvider = StateProvider<bool>((ref) => false);

// Provider for Quran bookmarks
final quranBookmarksProvider = StateNotifierProvider<QuranBookmarksNotifier, List<int>>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return QuranBookmarksNotifier(storageService, ref);
});

class QuranBookmarksNotifier extends StateNotifier<List<int>> {
  final StorageService _storageService;
  final Ref _ref;

  QuranBookmarksNotifier(this._storageService, this._ref) : super([]) {
    _loadBookmarks();
  }

  void _loadBookmarks() {
    state = _storageService.getQuranBookmarks();
  }

  Future<void> toggleBookmark(int page, [BuildContext? context]) async {
    if (context == null) return;
    
    final l10n = S.of(context);
    final isCurrentlyBookmarked = state.contains(page);
    final adsService = _ref.read(adsServiceProvider.notifier);
    
    // Determine the dialog title and message based on current bookmark status
    final title = isCurrentlyBookmarked
        ? l10n.removeBookmark
        : l10n.addBookmark;
        
    final message = isCurrentlyBookmarked
        ? l10n.pressBackToExit
        : l10n.pressBackToExit;
        
    bool confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.ok),
          ),
        ],
      ),
    ) ?? false;
    
    if (confirmed) {
      if (isCurrentlyBookmarked) {
        await _storageService.removeQuranBookmark(page);
      } else {
        await _storageService.addQuranBookmark(page);
        // Show interstitial ad when adding a bookmark
        await adsService.showInterstitialAd();
      }
      _loadBookmarks();
    }
  }

  bool isBookmarked(int page) {
    return state.contains(page);
  }

  int get bookmarksCount => state.length;
} 