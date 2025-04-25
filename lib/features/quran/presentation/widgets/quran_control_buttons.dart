import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:azkary/generated/l10n.dart';
import '../providers/quran_providers.dart';

class QuranControlButtons extends ConsumerWidget {
  final bool isFullScreen;
  final int currentPage;
  final List<int> bookmarks;
  final bool isCurrentPageBookmarked;
  final VoidCallback onSurahSelectionPressed;
  final Function(int) onToggleBookmark;
  final Function(BuildContext, int, bool, List<int>) onShowBookmarkContextMenu;

  const QuranControlButtons({
    Key? key,
    required this.isFullScreen,
    required this.currentPage,
    required this.bookmarks,
    required this.isCurrentPageBookmarked,
    required this.onSurahSelectionPressed,
    required this.onToggleBookmark,
    required this.onShowBookmarkContextMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    
    return Positioned(
      top: 10,
      right: 10,
      child: AnimatedOpacity(
        opacity: isFullScreen ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: AnimatedSlide(
          offset: isFullScreen ? const Offset(0, -1) : Offset.zero,
          duration: const Duration(milliseconds: 300),
          child: Row(
            children: [
              _buildSurahSelectionButton(context),
              5.horizontalSpace,
              _buildBookmarkButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahSelectionButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.spMin),
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
        onPressed: isFullScreen ? null : onSurahSelectionPressed,
      ),
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onLongPress: isFullScreen 
              ? null 
              : () => onShowBookmarkContextMenu(
                  context, 
                  currentPage, 
                  isCurrentPageBookmarked, 
                  bookmarks
                ),
          child: Container(
            padding: EdgeInsets.all(5.spMin),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                isCurrentPageBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
                size: 20.spMin,
              ),
              onPressed: isFullScreen 
                  ? null 
                  : () => onToggleBookmark(currentPage),
            ),
          ),
        ),
        if (bookmarks.isNotEmpty)
          _buildBookmarkCounter(),
      ],
    );
  }

  Widget _buildBookmarkCounter() {
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding: EdgeInsets.all(5.r),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Text(
          '${bookmarks.length}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.spMin,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 