import 'package:azkary/features/quran/data/models/surah_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:azkary/generated/l10n.dart';
import '../providers/quran_providers.dart';

class QuranBookmarksScreen extends ConsumerWidget {
  const QuranBookmarksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(quranBookmarksProvider);
    final l10n = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bookmarks),
        centerTitle: true,
      ),
      body: bookmarks.isEmpty
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
                    l10n.bookmarksEmpty,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final page = bookmarks[index];
                return Dismissible(
                  key: Key('bookmark_${page + 1}'),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    ref
                        .read(quranBookmarksProvider.notifier)
                        .toggleBookmark(page, context);
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 8.h),
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
                      title: Row(
                        children: [  
                          Expanded(
                            child: Text(
                              surahs
                                  .firstWhere(
                                    (surah) =>
                                        surah.startPage <= page + 1 &&
                                        (surah.endPage ?? surah.startPage) >=
                                            page + 1,
                                    orElse: () => surahs.first,
                                  )
                                  .nameArabic,
                              style: TextStyle(
                                fontSize: 16.spMin,
                                fontFamily: 'Uthmanic',
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 145, 64, 11),
                              ),
                            ),
                          ),
                           Text(
                            'ص ${page + 1}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        l10n.tapToView,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          ref
                              .read(quranBookmarksProvider.notifier)
                              .toggleBookmark(page, context);
                        },
                      ),
                      onTap: () {
                        // Navigate to the Quran screen and jump to the bookmarked page
                        Navigator.pop(context, page + 1);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
