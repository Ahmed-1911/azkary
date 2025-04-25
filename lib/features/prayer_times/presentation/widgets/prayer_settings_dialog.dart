import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/prayer_times_providers.dart';
import '../../data/models/location.dart';
import 'package:geolocator/geolocator.dart';

class PrayerSettingsDialog extends ConsumerWidget {
  const PrayerSettingsDialog({super.key});

  // Function to check and request location permissions
  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).locationServicesDisabled),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).locationPermissionDenied),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    }
    
    // Handle permanently denied permissions
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).locationPermissionPermanentlyDenied),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: S.of(context).openSettings,
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
          ),
        );
      }
      return false;
    }
    
    return true;
  }

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
                    S.of(context).prayerTimesSettings,
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
                      S.of(context).calculationMethod,
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
                      S.of(context).madhabAsrCalculation,
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
                      S.of(context).location,
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
                          // First check and request location permissions
                          final hasPermission = await _handleLocationPermission(context);
                          if (!hasPermission) {
                            return; // Exit if permissions not granted
                          }
                          
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
                                      Text(S.of(context).updatingLocation),
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
                                  content: Text(S.of(context).locationUpdatedSuccessfully),
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
                        label: Text( S.of(context).updateCurrentLocation),
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
                        },
                        child: Text( S.of(context).saveAndClose),
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
      S.of(context).egyptianGeneralAuthorityOfSurvey,
      S.of(context).universityOfIslamicSciencesKarachi,
      S.of(context).muslimWorldLeague,
      S.of(context).northAmericaISNA,
      S.of(context).dubaiUAE,
      S.of(context).moonsightingCommittee,
      S.of(context).kuwait,
      S.of(context).qatar,
      S.of(context).singapore,
      S.of(context).turkey,
      S.of(context).tehran,
      S.of(context).ummAlQuraUniversityMakkah,
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
        fillColor: isDarkMode ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.surface,
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
      S.of(context).shafiMalikiHanbali,
      S.of(context).hanafi,
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
        fillColor: isDarkMode ? theme.colorScheme.surfaceContainerHighest : theme.colorScheme.surface,
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