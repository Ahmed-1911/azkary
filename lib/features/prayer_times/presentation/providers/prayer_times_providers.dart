import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
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

// Provider to get current location
final getCurrentLocationProvider = FutureProvider<Location>((ref) async {
  // Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled');
  }

  // Check location permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied');
  }

  // Get current position
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high
  );

  return Location(
    latitude: position.latitude,
    longitude: position.longitude,
  );
});

// Provider for location with city name
final locationWithCityProvider = FutureProvider<Location>((ref) async {
  final location = ref.watch(locationProvider);
  final geocodingService = ref.watch(geocodingServiceProvider);
  return geocodingService.getLocationWithCityName(location);
});

// Provider for location
final locationProvider = StateProvider<Location>((ref) {
  return Location();
});

// Provider to initialize location from repository
final initializeLocationProvider = FutureProvider<void>((ref) async {
  final repository = ref.watch(prayerTimesRepositoryProvider);
  final savedLocation = await repository.getSavedLocation();
  
  if (savedLocation != null) {
    ref.read(locationProvider.notifier).state = savedLocation;
  } else {
    try {
      // Try to get current location if no saved location exists
      final currentLocation = await ref.read(getCurrentLocationProvider.future);
      // Update location with city name
      await ref.read(updateLocationWithCityProvider)(currentLocation);
    } catch (e) {
      debugPrint('Error getting current location: $e');
      // Keep default Makkah location if current location cannot be obtained
      ref.read(locationProvider.notifier).state = Location();
    }
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