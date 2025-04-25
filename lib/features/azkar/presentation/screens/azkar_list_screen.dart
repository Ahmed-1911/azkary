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
import 'dart:async';

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
  Timer? _initTimer;
  
  // Store references to functions we'll need later
  late final Function(String) _decrementFunction;

  @override
  void initState() {
    super.initState();
    
    // Store function references that we'll need throughout the widget's lifecycle
    _decrementFunction = ref.read(azkarRepeatCountsProvider.notifier).decrementCount;
    
    // Capture references before any async operations
    final controller = ref.read(azkarListControllerProvider(widget.category).notifier);
    final initializeFunction = controller.initializeIfNeeded;
    
    // Schedule initialization for the next frame
    _initTimer = Timer(Duration.zero, () {
      if (_isDisposed) return;
      
      try {
        // Use the captured functions instead of accessing ref again
        if (mounted && !_isDisposed) {
          initializeFunction();
        }
        
        // Ensure ads are loaded
        if (mounted && !_isDisposed) {
          ref.read(adsServiceProvider.notifier).ensureNativeAdLoaded();
        }
      } catch (e) {
        debugPrint('Error initializing: $e');
      }
    });
  }

  @override
  void dispose() {
    // Mark as disposed first
    _isDisposed = true;
    
    // Cancel any pending timers
    _initTimer?.cancel();
    
    // Call super.dispose() to mark the widget as disposed
    super.dispose();
  }

  void _handleCountDecrement(String azkarId, int currentCount) {
    if (_isDisposed || !mounted) return;
    
    if (currentCount <= 1) {
      setState(() {
        _fadingItems[azkarId] = true;
      });
      
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted || _isDisposed) return;
        
        setState(() {
          _fadingItems.remove(azkarId);
        });
        
        // Use the stored function reference - no ref access here
        _decrementFunction(azkarId);
      });
    } else {
      // Use the stored function reference
      _decrementFunction(azkarId);
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
          if (adsService.isNativeAdLoaded && adsService.nativeAd != null)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
              child: AdWidget(ad: adsService.nativeAd!),
            ),
        ],
      ),
    );
  }
}