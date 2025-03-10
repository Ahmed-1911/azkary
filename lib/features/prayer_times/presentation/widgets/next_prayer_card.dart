import 'package:azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NextPrayerCard extends StatelessWidget {
  final String nextPrayer;
  final DateTime nextPrayerTime;

  const NextPrayerCard({
    super.key,
    required this.nextPrayer,
    required this.nextPrayerTime,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.jm();
    final dateFormat = DateFormat.yMMMMd();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    // Calculate time remaining
    final now = DateTime.now();
    final difference = nextPrayerTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    
    // Check if the time calculation is valid (positive)
    if (difference.inMinutes <= 0) {
      debugPrint('Warning: Negative or zero time difference detected for $nextPrayer: $difference');
    }
    
    String timeRemaining;
    if (hours > 0) {
      timeRemaining = '$hours ${l10n.hours} $minutes ${l10n.minutes}';
    } else {
      timeRemaining = '$minutes ${l10n.minutes}';
    }

    // Translate prayer name
    String translatedPrayer = _getTranslatedPrayerName(context, nextPrayer);
    
    // Get gradient colors based on prayer
    List<Color> gradientColors = _getGradientColors(nextPrayer, theme);

    // Determine if we're showing tomorrow's Fajr
    final isTomorrowFajr = nextPrayer == 'Fajr' && 
                           now.day != nextPrayerTime.day;
    
    // Format the date to show
    final dateToShow = isTomorrowFajr ? 
                      DateTime.now().add(const Duration(days: 1)) : 
                      DateTime.now();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withAlpha(100),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isTomorrowFajr ? '${l10n.nextPrayer} (${l10n.tomorrow})' : l10n.nextPrayer,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dateFormat.format(dateToShow),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(100),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    timeRemaining,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              translatedPrayer,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              timeFormat.format(nextPrayerTime),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String prayerName, ThemeData theme) {
    switch (prayerName) {
      case 'Fajr':
        return [
          const Color(0xFF1E3A8A), // deep blue
          const Color(0xFF3B82F6), // lighter blue
        ];
      case 'Sunrise':
        return [
          const Color(0xFFEA580C), // orange
          const Color(0xFFF97316), // lighter orange
        ];
      case 'Dhuhr':
        return [
          const Color(0xFFB45309), // amber
          const Color(0xFFF59E0B), // lighter amber
        ];
      case 'Asr':
        return [
          const Color(0xFF15803D), // green
          const Color(0xFF22C55E), // lighter green
        ];
      case 'Maghrib':
        return [
          const Color(0xFF7C2D12), // brown
          const Color(0xFFEF4444), // red
        ];
      case 'Isha':
        return [
          const Color(0xFF312E81), // indigo
          const Color(0xFF4F46E5), // lighter indigo
        ];
      default:
        return [
          theme.colorScheme.primary,
          theme.colorScheme.primary.withAlpha(700),
        ];
    }
  }

  String _getTranslatedPrayerName(BuildContext context, String prayerName) {
    final l10n = AppLocalizations.of(context);
    
    switch (prayerName) {
      case 'Fajr':
        return l10n?.fajr ?? prayerName;
      case 'Sunrise':
        return l10n?.sunrise ?? prayerName;
      case 'Dhuhr':
        return l10n?.dhuhr ?? prayerName;
      case 'Asr':
        return l10n?.asr ?? prayerName;
      case 'Maghrib':
        return l10n?.maghrib ?? prayerName;
      case 'Isha':
        return l10n?.isha ?? prayerName;
      default:
        return prayerName;
    }
  }
} 