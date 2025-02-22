import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/azkar_category.dart';
import '../providers/azkar_provider.dart';
import '../providers/azkar_list_provider.dart';
import '../widgets/azkar_card.dart';
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
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(azkarListControllerProvider(widget.category).notifier);
    final displayedAzkar = controller.getDisplayedAzkar();
    final repeatCounts = ref.watch(azkarRepeatCountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.resetAllCounts,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: displayedAzkar.length,
        itemBuilder: (context, index) {
          final azkar = displayedAzkar[index];
          final currentCount = repeatCounts[azkar.id] ?? azkar.repeatCount;
          final isFading = controller.isItemFading(azkar.id);

          return GestureDetector(
            onTap: () => controller.handleCountDecrement(azkar.id, currentCount),
            child: Animate(
              effects: isFading ? [FadeEffect(duration: 800.ms)] : null,
              child: Animate(
                effects: currentCount == 1 ? [ShakeEffect(duration: 500.ms)] : null,
                child: AzkarCard(
                  azkar: azkar,
                  remainingCount: currentCount,
                  isBookmarked: ref.watch(bookmarkedAzkarProvider).contains(azkar.id),
                  onBookmarkToggle: () async {
                    await ref.read(bookmarkedAzkarProvider.notifier).toggleBookmark(azkar.id);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 