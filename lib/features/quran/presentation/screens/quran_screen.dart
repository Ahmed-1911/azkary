import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:azkary/l10n/app_localizations.dart';
import 'package:azkary/core/services/storage_service.dart';
import 'package:azkary/core/services/ads_service.dart';
import 'package:azkary/core/providers/ui_providers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
          ref.read(adsServiceProvider).initBannerAd();
        } catch (e) {
          // Ignore ad initialization errors
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

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    try {
      ref.read(adsServiceProvider).disposeBannerAd();
    } catch (e) {
      // Ignore errors during disposal
    }
    super.dispose();
  }

  void _toggleFullScreen() {
    final isFullScreen = ref.read(isFullScreenProvider);
    // Toggle full screen state
    ref.read(isFullScreenProvider.notifier).state = !isFullScreen;
    setBottomNavBarVisibility(ref, !isFullScreen);
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: _toggleFullScreen,
          child: Stack(
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
                      color: Colors.white,
                      child: Center(
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
                    ),
                  );
                },
              ),
              // Page number indicator
              Positioned(
                top: 5,
                left: 10,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${currentPage + 1} / $totalPages',
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: 14.spMin,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Add banner ad at the bottom
              if (adsService.isBannerAdLoaded && adsService.bannerAd != null )
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    width: adsService.bannerAd!.size.width.toDouble(),
                    height: adsService.bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: adsService.bannerAd!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
