import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:azkary/generated/l10n.dart';
import '../providers/quran_providers.dart';

class QuranBookmarksDialog extends ConsumerWidget {
  final Function(int) onPageSelected;

  const QuranBookmarksDialog({
    Key? key,
    required this.onPageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(quranBookmarksProvider);
    final l10n = S.of(context);

    return AlertDialog(
      title: Text(
        l10n.bookmarks,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: bookmarks.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 48.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      l10n.noBookmarks,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final page = bookmarks[index];
                  return Dismissible(
                    key: Key('bookmark_$page'),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16.w),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      ref.read(quranBookmarksProvider.notifier).toggleBookmark(page, context);
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        'Page $page',
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onPageSelected(page);
                      },
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          ref.read(quranBookmarksProvider.notifier).toggleBookmark(page, context);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.close),
        ),
      ],
    );
  }
} 