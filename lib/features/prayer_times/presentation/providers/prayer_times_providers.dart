import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/services/geocoding_service.dart';
import '../../../bookmarks/presentation/providers/bookmark_providers.dart';
import '../../data/models/prayer_time_model.dart';
import '../../data/repositories/prayer_times_repository.dart';
import '../../data/models/location.dart';

// Provider for the prayer times repository
final prayerTimesRepositoryProvider = Provider<PrayerTimesRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PrayerTimesRepository(prefs);
});

// Provider for the geocoding service
final geocodingServiceProvider = Provider<GeocodingService>((ref) {
  return GeocodingService();
});

// Provider for location with city name
final locationWithCityProvider = FutureProvider<Location>((ref) async {
  final location = ref.watch(locationProvider);
  final geocodingService = ref.watch(geocodingServiceProvider);
  return geocodingService.getLocationWithCityName(location);
});

// Provider for location
final locationProvider = StateProvider<Location>((ref) {
  // This will be initialized with default values
  // and later updated with actual values
  return Location();
});

// Provider to initialize location from repository
final initializeLocationProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(prayerTimesRepositoryProvider);
  final savedLocation = await repository.getSavedLocation();
  
  if (savedLocation != null) {
    ref.read(locationProvider.notifier).state = savedLocation;
  }
});

// Provider to update location with city name
final updateLocationWithCityProvider = Provider<Future<void> Function(Location)>((ref) {
  return (Location location) async {
    debugPrint('Updating location with city name: $location');
    final repository = ref.read(prayerTimesRepositoryProvider);
    final geocodingService = ref.read(geocodingServiceProvider);
    
    try {
      // Get location with city name
      final locationWithCity = await geocodingService.getLocationWithCityName(location);
      debugPrint('Got location with city name: $locationWithCity');
      
      // Save location with city name
      await repository.saveLocation(locationWithCity);
      debugPrint('Saved location with city name to repository');
      
      // Update location provider
      ref.read(locationProvider.notifier).state = locationWithCity;
      debugPrint('Updated location provider state with new location');
      
      // Force refresh of dependent providers
      ref.invalidate(prayerTimesProvider);
      ref.invalidate(locationWithCityProvider);
    } catch (e) {
      debugPrint('Error updating location with city name: $e');
      // Still update the location even if getting the city name fails
      await repository.saveLocation(location);
      ref.read(locationProvider.notifier).state = location;
      
      // Force refresh of dependent providers
      ref.invalidate(prayerTimesProvider);
      ref.invalidate(locationWithCityProvider);
    }
  };
});

// Provider for the current day's prayer times
final prayerTimesProvider = FutureProvider<PrayerTimeModel>((ref) async {
  final location = ref.watch(locationProvider);
  final repository = ref.watch(prayerTimesRepositoryProvider);
  return repository.getPrayerTimes(location: location);
});

// Provider for a specific date's prayer times
final prayerTimesForDateProvider = FutureProvider.family<PrayerTimeModel, DateTime>((ref, date) async {
  final location = ref.watch(locationProvider);
  final repository = ref.watch(prayerTimesRepositoryProvider);
  return repository.getPrayerTimes(date: date, location: location);
});

// Provider for the next prayer
final nextPrayerProvider = Provider<String>((ref) {
  final prayerTimesAsync = ref.watch(prayerTimesProvider);
  
  return prayerTimesAsync.when(
    data: (prayerTimes) {
      final now = DateTime.now();
      return prayerTimes.getNextPrayer(now);
    },
    loading: () => 'Loading...',
    error: (_, __) => 'Error',
  );
});

// Provider for the next prayer time
final nextPrayerTimeProvider = Provider<DateTime?>((ref) {
  final prayerTimesAsync = ref.watch(prayerTimesProvider);
  
  return prayerTimesAsync.when(
    data: (prayerTimes) {
      final now = DateTime.now();
      return prayerTimes.getNextPrayerTime(now);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Provider for prayer notifications enabled state
final prayerNotificationsEnabledProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('prayer_notifications_enabled') ?? true;
});

// Provider to schedule prayer notifications
final schedulePrayerNotificationsProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    debugPrint('Scheduling prayer notifications...');
    final notificationService = ref.read(notificationServiceProvider);
    final isEnabled = ref.read(prayerNotificationsEnabledProvider);
    
    // Save the notification preference
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('prayer_notifications_enabled', isEnabled);
    
    // Initialize notification service
    final initialized = await notificationService.initialize();
    if (!initialized) {
      debugPrint('Failed to initialize notification service');
    }
    
    if (!isEnabled) {
      // If notifications are disabled, cancel all notifications
      debugPrint('Prayer notifications disabled, cancelling all notifications');
      await notificationService.cancelAllNotifications();
      return;
    }
    
    // Get today's prayer times
    try {
      final prayerTimes = await ref.read(prayerTimesProvider.future);
      
      // First cancel all existing notifications
      await notificationService.cancelAllNotifications();
      
      final now = DateTime.now();
      final prayers = {
        'Fajr': prayerTimes.fajr,
        'Sunrise': prayerTimes.sunrise,
        'Dhuhr': prayerTimes.dhuhr,
        'Asr': prayerTimes.asr,
        'Maghrib': prayerTimes.maghrib,
        'Isha': prayerTimes.isha,
      };
      
      // Schedule notifications for today's remaining prayers
      int idOffset = 0;
      for (final entry in prayers.entries) {
        final prayerName = entry.key;
        final prayerTime = entry.value;
        
        if (prayerTime.isAfter(now)) {
          final time = TimeOfDay(hour: prayerTime.hour, minute: prayerTime.minute);
          debugPrint('Scheduling notification for $prayerName at ${time.hour}:${time.minute}');
          
          await notificationService.schedulePrayerNotification(
            id: 1000 + idOffset,
            title: 'Prayer Time',
            body: 'It\'s time for $prayerName prayer',
            time: time,
          );
          
          idOffset++;
        } else {
          debugPrint('Skipping $prayerName as it has already passed today');
        }
      }
      
      // Schedule tomorrow's Fajr
      try {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        debugPrint('Getting prayer times for tomorrow: ${tomorrow.toString()}');
        
        final tomorrowPrayerTimes = await ref.read(prayerTimesForDateProvider(tomorrow).future);
        
        final fajrTime = TimeOfDay(
          hour: tomorrowPrayerTimes.fajr.hour, 
          minute: tomorrowPrayerTimes.fajr.minute
        );
        
        debugPrint('Scheduling notification for tomorrow\'s Fajr at ${fajrTime.hour}:${fajrTime.minute}');
        
        await notificationService.schedulePrayerNotification(
          id: 1000 + 6,
          title: 'Prayer Time',
          body: 'It\'s time for Fajr prayer',
          time: fajrTime,
        );
      } catch (e) {
        debugPrint('Error scheduling notification for tomorrow\'s Fajr: $e');
      }
    } catch (e) {
      debugPrint('Error scheduling prayer notifications: $e');
    }
  };
});

// Provider for calculation method
final calculationMethodProvider = StateProvider<int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt('calculation_method') ?? 0;
});

// Provider for madhab
final madhhabProvider = StateProvider<int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getInt('madhab') ?? 0;
}); 