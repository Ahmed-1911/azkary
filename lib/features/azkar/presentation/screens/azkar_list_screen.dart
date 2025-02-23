import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/azkar_category.dart';
import '../widgets/azkar_card.dart';
import '../providers/azkar_provider.dart';
import '../../../bookmarks/presentation/providers/bookmark_providers.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final azkarList = ref.read(azkarByCategoryProvider(widget.category.id));
      for (final azkar in azkarList) {
        ref.read(azkarRepeatCountsProvider.notifier).initializeCount(azkar.id, azkar.repeatCount);
      }
    });
  }

  void _handleCountDecrement(String azkarId, int currentCount) {
    if (currentCount <= 1) {
      setState(() {
        _fadingItems[azkarId] = true;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
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
    final azkarList = ref.watch(azkarByCategoryProvider(widget.category.id));
    final repeatCounts = ref.watch(azkarRepeatCountsProvider);

    final displayedAzkar = azkarList.where((azkar) => 
      !ref.read(azkarRepeatCountsProvider.notifier).isCompleted(azkar.id)
    ).toList();

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
            onPressed: () {
              setState(() {
                _fadingItems.clear();
              });
              for (final azkar in azkarList) {
                ref.read(azkarRepeatCountsProvider.notifier)
                   .resetCount(azkar.id, azkar.repeatCount);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.w),
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
    );
  }
}