import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../azkar/presentation/widgets/azkar_card.dart';
import '../../../azkar/presentation/providers/azkar_provider.dart';
import '../../../azkar/domain/entities/azkar.dart';
import '../providers/bookmark_providers.dart';

class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final bookmarkedIds = ref.read(bookmarkedAzkarProvider);
      final bookmarkedAzkar = getBookmarkedAzkar(ref, bookmarkedIds);
      for (final azkar in bookmarkedAzkar) {
        ref.read(azkarRepeatCountsProvider.notifier).initializeCount(azkar.id, azkar.repeatCount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkedIds = ref.watch(bookmarkedAzkarProvider);
    final bookmarkedAzkar = getBookmarkedAzkar(ref, bookmarkedIds);
    final l10n = S.of(context);

    // Filter out completed items
    final displayedAzkar = bookmarkedAzkar.where((azkar) => 
      !ref.read(azkarRepeatCountsProvider.notifier).isCompleted(azkar.id)
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookmarks),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              for (final azkar in bookmarkedAzkar) {
                ref.read(azkarRepeatCountsProvider.notifier)
                   .resetCount(azkar.id, azkar.repeatCount);
              }
            },
          ),
        ],
      ),
      body: displayedAzkar.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80.w,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.noBookmarks,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.addBookmarksHint,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: displayedAzkar.length,
              itemBuilder: (context, index) {
                final azkar = displayedAzkar[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Dismissible(
                    key: Key(azkar.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.w),
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) async {
                      await ref.read(bookmarkedAzkarProvider.notifier).toggleBookmark(azkar.id);
                    },
                    child: GestureDetector(
                      onTap: () {
                        ref.read(azkarRepeatCountsProvider.notifier).decrementCount(azkar.id);
                      },
                      child: AzkarCard(
                        azkar: azkar,
                        isBookmarked: true,
                        onBookmarkToggle: () async {
                          await ref.read(bookmarkedAzkarProvider.notifier).toggleBookmark(azkar.id);
                        },
                        remainingCount: ref.watch(azkarRepeatCountsProvider)[azkar.id] ?? azkar.repeatCount,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  List<Azkar> getBookmarkedAzkar(WidgetRef ref, Set<String> bookmarkedIds) {
    if (bookmarkedIds.isEmpty) return [];

    final allCategories = ref.read(azkarCategoriesProvider);
    final bookmarkedAzkar = <Azkar>[];

    for (final category in allCategories) {
      final categoryAzkar = ref.read(azkarByCategoryProvider(category.id));
      bookmarkedAzkar.addAll(
        categoryAzkar.where((azkar) => bookmarkedIds.contains(azkar.id))
      );
    }

    return bookmarkedAzkar;
  }
} 