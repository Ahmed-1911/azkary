import 'package:azkary/core/services/ads_service.dart';
import 'package:azkary/features/azkar/presentation/providers/azkar_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/azkar_category.dart';
import '../widgets/azkar_card.dart';
import '../providers/azkar_provider.dart';
import '../../../bookmarks/presentation/providers/bookmark_providers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AzkarListScreen extends ConsumerStatefulWidget {
  final AzkarCategory category;

  const AzkarListScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<AzkarListScreen> createState() => _AzkarListScreenState();
}

class _AzkarListScreenState extends ConsumerState<AzkarListScreen> {
  final Map<String, bool> _fadingItems = {};
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!_isDisposed) {
        ref.read(azkarListControllerProvider(widget.category).notifier).initializeIfNeeded();
        try {
          ref.read(adsServiceProvider).initBannerAd();
        } catch (e) {
          // Ignore ad initialization errors
          debugPrint('Error initializing banner ad: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    try {
      ref.read(adsServiceProvider).disposeBannerAd();
    } catch (e) {
      // Ignore errors during disposal
    }
    super.dispose();
  }

  void _handleCountDecrement(String azkarId, int currentCount) {
    if (_isDisposed) return;
    
    if (currentCount <= 1) {
      setState(() {
        _fadingItems[azkarId] = true;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted && !_isDisposed) {
          setState(() {
            _fadingItems.remove(azkarId);
          });
          ref.read(azkarRepeatCountsProvider.notifier).decrementCount(azkarId);
        }
      });
    } else {
      ref.read(azkarRepeatCountsProvider.notifier).decrementCount(azkarId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adsService = ref.watch(adsServiceProvider);
    final controller = ref.watch(azkarListControllerProvider(widget.category).notifier);
    final displayedAzkar = controller.getDisplayedAzkar();
    final repeatCounts = ref.watch(azkarRepeatCountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.category.name),
            Text(
              widget.category.nameAr,
              style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Amiri',
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.resetAllCounts,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemCount: displayedAzkar.length,
              itemBuilder: (context, index) {
                final azkar = displayedAzkar[index];
                final currentCount = repeatCounts[azkar.id] ?? azkar.repeatCount;
                final isFading = _fadingItems[azkar.id] == true;
                
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: GestureDetector(
                    onTap: () {
                      _handleCountDecrement(azkar.id, currentCount);
                    },
                    child: AzkarCard(
                      azkar: azkar,
                      isBookmarked: ref.watch(bookmarkedAzkarProvider).contains(azkar.id),
                      onBookmarkToggle: () async {
                        await ref.read(bookmarkedAzkarProvider.notifier).toggleBookmark(azkar.id);
                      },
                      remainingCount: currentCount,
                    ),
                  ),
                ).animate(
                  target: isFading ? 1 : 0,
                ).fadeOut(
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(0.4, 0.4),
                  duration: 600.ms,
                  curve: Curves.easeOut,
                ).slideY(
                  begin: 0,
                  end: 0.2,
                  duration: 600.ms,
                  curve: Curves.easeOut,
                );
              },
            ),
          ),
          if (adsService.isBannerAdLoaded && adsService.bannerAd != null)
            SafeArea(
              child: Container(
                width: adsService.bannerAd!.size.width.toDouble(),
                height: adsService.bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: adsService.bannerAd!),
              ),
            ),
        ],
      ),
    );
  }
}