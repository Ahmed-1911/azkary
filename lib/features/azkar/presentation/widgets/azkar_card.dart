import 'package:azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/azkar.dart';

class AzkarCard extends ConsumerWidget {
  final Azkar azkar;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;
  final int remainingCount;

  const AzkarCard({
    super.key,
    required this.azkar,
    required this.isBookmarked,
    required this.onBookmarkToggle,
    required this.remainingCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    Future<void> handlePlayback() async {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n?.audioComingSoon ?? 'Audio feature coming soon!'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: l10n?.ok ?? 'OK',
            onPressed: () {},
          ),
        ),
      );
      return;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    azkar.arabicText,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Amiri',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: onBookmarkToggle,
                ),
              ],
            ),
            if (azkar.reference != null) ...[
              SizedBox(height: 8.h),
              Text(
                azkar.reference!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.repeat,
                      size: 16.w,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${l10n?.repeat} $remainingCount ${l10n?.times}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                // IconButton(
                //   icon: const Icon(
                //     Icons.play_circle_outline,
                //     color: Colors.grey,
                //   ),
                //   onPressed: handlePlayback,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 