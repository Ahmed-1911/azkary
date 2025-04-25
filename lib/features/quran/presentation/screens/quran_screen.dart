import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:azkary/generated/l10n.dart';
import 'package:azkary/core/services/storage_service.dart';
import 'package:azkary/core/services/ads_service.dart';
import 'package:azkary/core/providers/ui_providers.dart';
import '../widgets/surah_selection_dialog.dart';
import '../widgets/quran_page_view.dart';
import '../widgets/quran_control_buttons.dart';
import '../providers/quran_providers.dart';
import 'quran_bookmarks_screen.dart';

class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({super.key});

  @override
  ConsumerState<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends ConsumerState<QuranScreen> {
  late PageController _pageController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializePageController();

    // Ensure ads are loaded when the screen is created
    Future.microtask(() {
      if (!_isDisposed && mounted) {
        ref.read(adsServiceProvider.notifier).ensureBannerAdLoaded();
      }
    });
  }

  void _initializePageController() {
    final currentPage = ref.read(currentQuranPageProvider);
    final totalPages = ref.read(totalQuranPagesProvider);

    _pageController = PageController(
      initialPage: totalPages - currentPage - 1,
    );
  }

  Future<void> _saveLastPage(int page) async {
    try {
      final storageService = ref.read(storageServiceProvider);
      await storageService.setLastQuranPage(page);
    } catch (e) {
      debugPrint('Error saving last Quran page: $e');
    }
  }

  void _showSurahSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => SurahSelectionDialog(
        onPageSelected: (page) {
          final totalPages = ref.read(totalQuranPagesProvider);
          _pageController.jumpToPage(totalPages - page);
        },
      ),
    );
  }

  // void _showBookmarksDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => QuranBookmarksDialog(
  //       onPageSelected: (page) {
  //         final totalPages = ref.read(totalQuranPagesProvider);
  //         _pageController.jumpToPage(totalPages - page);
  //       },
  //     ),
  //   );
  // }

  Future<void> _navigateToBookmarksScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuranBookmarksScreen(),
      ),
    );

    if (result != null && result is int) {
      final totalPages = ref.read(totalQuranPagesProvider);
      _pageController.jumpToPage(totalPages - result);
    }
  }

  void _toggleFullScreen() {
    final isFullScreen = ref.read(isQuranFullScreenProvider);
    // Toggle full screen state
    ref.read(isQuranFullScreenProvider.notifier).state = !isFullScreen;
    setBottomNavBarVisibility(ref, isFullScreen);

    if (isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _exitFullScreenMode() {
    final isFullScreen = ref.read(isQuranFullScreenProvider);
    if (isFullScreen) {
      ref.read(isQuranFullScreenProvider.notifier).state = false;
      setBottomNavBarVisibility(ref, true);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _toggleBookmark(int page) {
    ref.read(quranBookmarksProvider.notifier).toggleBookmark(page, context);
  }

  void _showBookmarkContextMenu(BuildContext context, int currentPage,
      bool isCurrentPageBookmarked, List<int> bookmarks) {
    final l10n = S.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + 1,
        position.dy + 70,
        position.dx + 100,
        position.dy + 0,
      ),
      items: [
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                isCurrentPageBookmarked
                    ? Icons.bookmark_remove
                    : Icons.bookmark_add,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                isCurrentPageBookmarked
                    ? l10n.removeBookmark
                    : l10n.addBookmark,
              ),
            ],
          ),
        ),
        if (bookmarks.isNotEmpty)
          PopupMenuItem(
            value: 'view',
            child: Row(
              children: [
                Icon(
                  Icons.list,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(l10n.viewBookmarks),
              ],
            ),
          ),
      ],
    ).then(
      (value) {
        if (value == 'toggle') {
          _toggleBookmark(currentPage);
        } else if (value == 'view') {
          _navigateToBookmarksScreen();
        }
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFullScreen = ref.watch(isQuranFullScreenProvider);
    final currentPage = ref.watch(currentQuranPageProvider);
    final bookmarks = ref.watch(quranBookmarksProvider);
    final isCurrentPageBookmarked = bookmarks.contains(currentPage);
    final adsService = ref.watch(adsServiceProvider);

    return PopScope(
      canPop: !isFullScreen,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }

        // If in full screen mode, exit full screen mode first
        if (isFullScreen) {
          _exitFullScreenMode();
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 243, 233),
        body: SafeArea(
          child: GestureDetector(
            onTap: _toggleFullScreen,
            child: Column(
              children: [
                // Expanded area containing the Quran content
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Main content - Quran pages
                      QuranPageView(
                        pageController: _pageController,
                        onPageChanged: _saveLastPage,
                      ),
                      
                      // Control buttons overlay
                      QuranControlButtons(
                        isFullScreen: isFullScreen,
                        currentPage: currentPage,
                        bookmarks: bookmarks,
                        isCurrentPageBookmarked: isCurrentPageBookmarked,
                        onSurahSelectionPressed: _showSurahSelectionDialog,
                        onToggleBookmark: _toggleBookmark,
                        onShowBookmarkContextMenu: _showBookmarkContextMenu,
                      ),
                    ],
                  ),
                ),
                
                // Fixed height container for ad in fullscreen mode
                Container(
                  height: isFullScreen ? 70.h : 0.0, // Fixed height
                  width: double.infinity,
                  color: isFullScreen ? Colors.transparent : Colors.transparent,
                  child: isFullScreen && adsService.isNativeAdLoaded && adsService.nativeAd != null
                    ? AdWidget(ad: adsService.nativeAd!)
                    : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
