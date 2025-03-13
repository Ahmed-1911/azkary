import 'package:azkary/features/quran/data/models/surah_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:azkary/generated/l10n.dart';
import 'package:azkary/core/services/storage_service.dart';
import 'package:azkary/core/services/ads_service.dart';
import 'package:azkary/core/providers/ui_providers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widgets/surah_selection_dialog.dart';

final isFullScreenProvider = StateProvider<bool>((ref) => false);
final currentPageProvider = StateProvider<int>((ref) {
  // Initialize with the last viewed page from storage
  final storageService = ref.watch(storageServiceProvider);
  return storageService.getLastQuranPage();
});
final totalPagesProvider = Provider<int>((ref) => 604);

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
    final currentPage = ref.read(currentPageProvider);
    final totalPages = ref.read(totalPagesProvider);

    // Initialize the page controller with the current page
    _pageController = PageController(
      initialPage: totalPages - currentPage - 1,
    );

    // Initialize ads
    Future.microtask(() {
      if (!_isDisposed) {
        try {
          ref.read(adsServiceProvider.notifier).initBannerAd();
        } catch (e) {
          debugPrint('Error initializing banner ad: $e');
        }
      }
    });
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
          final totalPages = ref.read(totalPagesProvider);
          _pageController.jumpToPage(totalPages - page);
        },
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    try {
      ref.read(adsServiceProvider.notifier).disposeBannerAd();
    } catch (e) {
      debugPrint('Error disposing banner ad: $e');
    }
    super.dispose();
  }

  void _toggleFullScreen() {
    final isFullScreen = ref.read(isFullScreenProvider);
    // Toggle full screen state
    ref.read(isFullScreenProvider.notifier).state = !isFullScreen;
    setBottomNavBarVisibility(ref, isFullScreen);
    if (!isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFullScreen = ref.watch(isFullScreenProvider);
    final currentPage = ref.watch(currentPageProvider);
    final totalPages = ref.watch(totalPagesProvider);
    final adsService = ref.watch(adsServiceProvider);
    final l10n = S.of(context);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: _toggleFullScreen,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                reverse: true, // To read from right to left
                onPageChanged: (index) {
                  final newPage = totalPages - index - 1;
                  ref.read(currentPageProvider.notifier).state = newPage;
                  // Save the page whenever it changes
                  _saveLastPage(newPage);
                },
                itemCount: totalPages,
                itemBuilder: (context, index) {
                  // Convert from 0-based index to 1-based page number
                  final pageNumber = totalPages - index;
                  return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 3.0,
                    child: Container(
                      color: const Color.fromARGB(255, 245, 243, 233),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  surahs
                                      .firstWhere(
                                        (surah) =>
                                            surah.startPage <= pageNumber &&
                                            (surah.endPage ??
                                                    surah.startPage) >=
                                                pageNumber,
                                        orElse: () => surahs.first,
                                      )
                                      .nameArabic,
                                  style: TextStyle(
                                    fontSize: 12.spMin,
                                    fontFamily: 'Uthmanic',
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 145, 64, 11),
                                  ),
                                ),
                                Text(
                                  '$pageNumber',
                                  style: TextStyle(
                                    fontSize: 12.spMin,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 145, 64, 11),
                                  ),
                                ),
                                Text(
                                  '  جزء ${((pageNumber - 2) ~/ 20 + 1)}',
                                  style: TextStyle(
                                    fontSize: 12.spMin,
                                    color: const Color.fromARGB(255, 145, 64, 11),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Uthmanic',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          5.verticalSpace,
                          Center(
                            child: Image.asset(
                              'assets/images/quran/p$pageNumber.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    l10n.pageNotAvailable(pageNumber),
                                    style: TextStyle(
                                      fontSize: 18.spMin,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // fehrs
              if (isFullScreen)
                Positioned(
                  top: 5,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.menu_book,
                        color: Colors.white,
                        size: 20.spMin,
                      ),
                      onPressed: _showSurahSelectionDialog,
                    ),
                  ),
                ),
              // Add banner ad at the bottom
              if (ref.watch(adsServiceProvider).isBannerAdLoaded &&
                  ref.watch(adsServiceProvider).bannerAd != null &&
                  isFullScreen)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    width: ref
                        .watch(adsServiceProvider)
                        .bannerAd!
                        .size
                        .width
                        .toDouble(),
                    height: ref
                        .watch(adsServiceProvider)
                        .bannerAd!
                        .size
                        .height
                        .toDouble(),
                    child:
                        AdWidget(ad: ref.watch(adsServiceProvider).bannerAd!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
