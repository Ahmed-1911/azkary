import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:azkary/generated/l10n.dart';

class PrayerTimeCard extends StatelessWidget {
  final String name;
  final DateTime time;
  final bool isNext;

  const PrayerTimeCard({
    super.key,
    required this.name,
    required this.time,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final timeFormat = DateFormat.jm();
    final theme = Theme.of(context);
    
    // Translate prayer name
    String translatedName;
    switch (name) {
      case 'Fajr':
        translatedName = l10n.fajr;
        break;
      case 'Sunrise':
        translatedName = l10n.sunrise;
        break;
      case 'Dhuhr':
        translatedName = l10n.dhuhr;
        break;
      case 'Asr':
        translatedName = l10n.asr;
        break;
      case 'Maghrib':
        translatedName = l10n.maghrib;
        break;
      case 'Isha':
        translatedName = l10n.isha;
        break;
      default:
        translatedName = name;
    }

    return Card(
      elevation: isNext ? 4 : 1,
      margin: EdgeInsets.only(bottom: 8.h),
      color: isNext ? theme.colorScheme.primary.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: isNext 
            ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForPrayer(name),
                  color: isNext ? theme.colorScheme.primary : Colors.grey[600],
                  size: 24.w,
                ),
                SizedBox(width: 12.w),
                Text(
                  translatedName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                    color: isNext ? theme.colorScheme.primary : null,
                  ),
                ),
              ],
            ),
            Text(
              timeFormat.format(time),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
                color: isNext ? theme.colorScheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForPrayer(String prayer) {
    switch (prayer) {
      case 'Fajr':
        return Icons.nightlight_round;
      case 'Sunrise':
        return Icons.wb_sunny_outlined;
      case 'Dhuhr':
        return Icons.wb_sunny;
      case 'Asr':
        return Icons.sunny_snowing;
      case 'Maghrib':
        return Icons.sunny;
      case 'Isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }
} 