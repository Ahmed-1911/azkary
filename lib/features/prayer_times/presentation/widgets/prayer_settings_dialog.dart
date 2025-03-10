import 'package:azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/prayer_times_providers.dart';
import '../../data/models/location.dart';
import 'package:geolocator/geolocator.dart';

class PrayerSettingsDialog extends ConsumerWidget {
  const PrayerSettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calculationMethod = ref.watch(calculationMethodProvider);
    final madhab = ref.watch(madhhabProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.prayerTimesSettings ?? 'Prayer Times Settings',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.calculationMethod ?? 'Calculation Method',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildCalculationMethodDropdown(context, calculationMethod, ref, isDarkMode),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)?.madhabAsrCalculation ?? 'Madhab (Asr Calculation)',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildMadhabDropdown(context, madhab, ref, isDarkMode),
                    SizedBox(height: 16.h),
                    Text(
                      AppLocalizations.of(context)?.location ?? 'Location',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () async {
                          final repository = ref.read(prayerTimesRepositoryProvider);
                          try {
                            // Show loading indicator
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const CircularProgressIndicator(color: Colors.white),
                                      const SizedBox(width: 16),
                                      Text('Updating location...'),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 10),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                            }
                            
                            // Get current location using Geolocator directly
                            final position = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                              timeLimit: const Duration(seconds: 15),
                            );
                            
                            // Create a Location object from coordinates
                            final location = Location(
                              latitude: position.latitude,
                              longitude: position.longitude,
                            );
                            
                            // Update location with city name
                            await ref.read(updateLocationWithCityProvider)(location);
                            
                            // Invalidate providers to refresh data
                            ref.invalidate(prayerTimesProvider);
                            ref.invalidate(locationWithCityProvider);
                            
                            if (context.mounted) {
                              // Dismiss any existing snackbars
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              
                              Navigator.of(context).pop(); // Close dialog after successful update
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(AppLocalizations.of(context)?.locationUpdatedSuccessfully ?? 'Location updated successfully'),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              // Dismiss any existing snackbars
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error updating location: $e'),
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.my_location),
                        label: Text( AppLocalizations.of(context)?.updateCurrentLocation ?? 'Update Current Location'),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.onPrimaryContainer,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Schedule notifications with new settings
                          ref.read(schedulePrayerNotificationsProvider)();
                        },
                        child: Text( AppLocalizations.of(context)?.saveAndClose ?? 'Save & Close'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationMethodDropdown(BuildContext context, int currentValue, WidgetRef ref, bool isDarkMode) {
    final theme = Theme.of(context);
    final methods = [
      AppLocalizations.of(context)?.egyptianGeneralAuthorityOfSurvey ?? 'Egyptian General Authority of Survey',
      AppLocalizations.of(context)?.universityOfIslamicSciencesKarachi ?? 'University of Islamic Sciences, Karachi',
      AppLocalizations.of(context)?.muslimWorldLeague ?? 'Muslim World League',
      AppLocalizations.of(context)?.northAmericaISNA ?? 'North America (ISNA)',
      AppLocalizations.of(context)?.dubaiUAE ?? 'Dubai (UAE)',
      AppLocalizations.of(context)?.moonsightingCommittee ?? 'Moonsighting Committee',
      AppLocalizations.of(context)?.kuwait ?? 'Kuwait',
      AppLocalizations.of(context)?.qatar ?? 'Qatar',
      AppLocalizations.of(context)?.singapore ?? 'Singapore',
      AppLocalizations.of(context)?.turkey ?? 'Turkey',
      AppLocalizations.of(context)?.tehran ?? 'Tehran',
      AppLocalizations.of(context)?.ummAlQuraUniversityMakkah ?? 'Umm al-Qura University, Makkah',
    ];
    
    return DropdownButtonFormField<int>(
      value: currentValue,
      dropdownColor: isDarkMode ? theme.colorScheme.surface : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        filled: true,
        fillColor: isDarkMode ? theme.colorScheme.surfaceVariant : theme.colorScheme.surface,
      ),
      items: List.generate(methods.length, (index) {
        return DropdownMenuItem<int>(
          value: index,
          child: Text(
            methods[index],
            style: TextStyle(
              fontSize: 14.sp,
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
      }),
      onChanged: (value) {
        if (value != null) {
          ref.read(calculationMethodProvider.notifier).state = value;
          ref.read(prayerTimesRepositoryProvider).saveCalculationMethod(value);
          ref.invalidate(prayerTimesProvider);
        }
      },
    );
  }

  Widget _buildMadhabDropdown(BuildContext context, int currentValue, WidgetRef ref, bool isDarkMode) {
    final theme = Theme.of(context);
    final madhabs = [
      AppLocalizations.of(context)?.shafiMalikiHanbali ?? 'Shafi, Maliki, Hanbali',
      AppLocalizations.of(context)?.hanafi ?? 'Hanafi',
    ];
    
    return DropdownButtonFormField<int>(
      value: currentValue,
      dropdownColor: isDarkMode ? theme.colorScheme.surface : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        filled: true,
        fillColor: isDarkMode ? theme.colorScheme.surfaceVariant : theme.colorScheme.surface,
      ),
      items: List.generate(madhabs.length, (index) {
        return DropdownMenuItem<int>(
          value: index,
          child: Text(
            madhabs[index],
            style: TextStyle(
              fontSize: 14.sp,
              color: theme.colorScheme.onSurface,
            ),
          ),
        );
      }),
      onChanged: (value) {
        if (value != null) {
          ref.read(madhhabProvider.notifier).state = value;
          ref.read(prayerTimesRepositoryProvider).saveMadhab(value);
          ref.invalidate(prayerTimesProvider);
        }
      },
    );
  }
} 