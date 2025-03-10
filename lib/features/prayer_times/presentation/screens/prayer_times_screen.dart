import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:azkary/l10n/app_localizations.dart';
import '../../../../core/services/notification_service.dart';
import '../providers/prayer_times_providers.dart';
import '../widgets/prayer_time_card.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_settings_dialog.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Add location listener
    ref.listen(locationProvider, (previous, next) {
      // Invalidate prayer times when location changes
      ref.invalidate(prayerTimesProvider);
      ref.invalidate(locationWithCityProvider);
    });

    final l10n = AppLocalizations.of(context)!;
    final prayerTimesAsync = ref.watch(prayerTimesProvider);
    final locationWithCityAsync = ref.watch(locationWithCityProvider);
    final notificationsEnabled = ref.watch(prayerNotificationsEnabledProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prayerTimes),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context, ref),
          ),
        ],
      ),
      body: prayerTimesAsync.when(
        data: (prayerTimes) {
          final now = DateTime.now();
          final nextPrayer = prayerTimes.getNextPrayer(now);
          final nextPrayerTime = prayerTimes.getNextPrayerTime(now);
          
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(prayerTimesProvider);
              ref.invalidate(locationWithCityProvider);
              await ref.read(prayerTimesProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // City name display
                    locationWithCityAsync.when(
                      data: (location) => location.cityName != null
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, size: 16.sp, color: Theme.of(context).primaryColor),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      location.cityName!,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, size: 16.sp, color: Colors.grey),
                                  SizedBox(width: 4.w),
                                  Text(
                                    AppLocalizations.of(context)!.locationNotAvailable,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.refresh, size: 16.sp),
                                    onPressed: () {
                                      ref.invalidate(locationWithCityProvider);
                                    },
                                    tooltip: 'Refresh location',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                      loading: () => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16.sp,
                              height: 16.sp,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.w,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              AppLocalizations.of(context)?.loadingLocation ?? 'Loading location...',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      error: (_, __) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, size: 16.sp, color: Colors.red),
                            SizedBox(width: 4.w),
                            Text(
                              AppLocalizations.of(context)?.errorLoadingLocation ?? 'Error loading location',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.refresh, size: 16.sp),
                              onPressed: () {
                                ref.invalidate(locationWithCityProvider);
                              },
                              tooltip: 'Retry',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    NextPrayerCard(
                      nextPrayer: nextPrayer,
                      nextPrayerTime: nextPrayerTime,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.todayPrayerTimes,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              l10n.notifications,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            Switch(
                              value: notificationsEnabled,
                              onChanged: (value) {
                                ref.read(prayerNotificationsEnabledProvider.notifier).state = value;
                                ref.read(schedulePrayerNotificationsProvider)();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    PrayerTimeCard(
                      name: 'Fajr',
                      time: prayerTimes.fajr,
                      isNext: nextPrayer == 'Fajr',
                    ),
                    PrayerTimeCard(
                      name: 'Sunrise',
                      time: prayerTimes.sunrise,
                      isNext: nextPrayer == 'Sunrise',
                    ),
                    PrayerTimeCard(
                      name: 'Dhuhr',
                      time: prayerTimes.dhuhr,
                      isNext: nextPrayer == 'Dhuhr',
                    ),
                    PrayerTimeCard(
                      name: 'Asr',
                      time: prayerTimes.asr,
                      isNext: nextPrayer == 'Asr',
                    ),
                    PrayerTimeCard(
                      name: 'Maghrib',
                      time: prayerTimes.maghrib,
                      isNext: nextPrayer == 'Maghrib',
                    ),
                    PrayerTimeCard(
                      name: 'Isha',
                      time: prayerTimes.isha,
                      isNext: nextPrayer == 'Isha',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48.w, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  l10n.errorLoadingPrayerTimes,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () => ref.invalidate(prayerTimesProvider),
                  child: Text(l10n.tryAgain),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const PrayerSettingsDialog(),
    );
  }
} 