import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/prayer_time_model.dart';
import '../models/location.dart';

class PrayerTimesRepository {
  // Keys for SharedPreferences
  static const String _latitudeKey = 'prayer_latitude';
  static const String _longitudeKey = 'prayer_longitude';
  static const String _cityNameKey = 'prayer_city_name';
  static const String _calculationMethodKey = 'calculation_method';
  static const String _madhhabKey = 'madhab';

  final SharedPreferences _prefs;

  PrayerTimesRepository(this._prefs);

  // Get saved location or null if not available
  Future<Location?> getSavedLocation() async {
    final double? latitude = _prefs.getDouble(_latitudeKey);
    final double? longitude = _prefs.getDouble(_longitudeKey);
    final String? cityName = _prefs.getString(_cityNameKey);

    if (latitude != null && longitude != null) {
      return Location(
        latitude: latitude,
        longitude: longitude,
        cityName: cityName,
      );
    }
    return null;
  }

  // Save location to SharedPreferences
  Future<void> saveLocation(Location location) async {
    debugPrint('Saving location to SharedPreferences: $location');
    await _prefs.setDouble(_latitudeKey, location.latitude);
    await _prefs.setDouble(_longitudeKey, location.longitude);
    
    if (location.cityName != null) {
      debugPrint('Saving city name: ${location.cityName}');
      await _prefs.setString(_cityNameKey, location.cityName!);
    } else {
      debugPrint('No city name to save');
    }
    
    // Verify the saved values
    final savedLatitude = _prefs.getDouble(_latitudeKey);
    final savedLongitude = _prefs.getDouble(_longitudeKey);
    final savedCityName = _prefs.getString(_cityNameKey);
    debugPrint('Verified saved values - latitude: $savedLatitude, longitude: $savedLongitude, cityName: $savedCityName');
  }

  // Get current location
  Future<Coordinates> getCurrentLocation() async {
    // Check if we have saved location
    final savedLocation = await getSavedLocation();
    if (savedLocation != null) {
      return savedLocation.toCoordinates();
    }

    // Request location permission
    final status = await Permission.location.request();
    if (status.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        
        // Save the location for future use
        await saveLocation(Location(
          latitude: position.latitude,
          longitude: position.longitude,
        ));
        
        return Coordinates(position.latitude, position.longitude);
      } catch (e) {
        debugPrint('Error getting location: $e');
        // Return default coordinates (Mecca)
        return Coordinates(21.4225, 39.8262);
      }
    } else {
      // Return default coordinates (Mecca) if permission not granted
      return Coordinates(21.4225, 39.8262);
    }
  }

  // Get calculation method from preferences or default
  CalculationParameters getCalculationMethod() {
    final methodIndex = _prefs.getInt(_calculationMethodKey) ?? 0;
    final methods = [
      CalculationMethod.egyptian,
      CalculationMethod.karachi,
      CalculationMethod.muslim_world_league,
      CalculationMethod.north_america,
      CalculationMethod.dubai,
      CalculationMethod.moon_sighting_committee,
      CalculationMethod.kuwait,
      CalculationMethod.qatar,
      CalculationMethod.singapore,
      CalculationMethod.turkey,
      CalculationMethod.tehran,
      CalculationMethod.umm_al_qura,
    ];
    
    return methods[methodIndex].getParameters();
  }

  // Save calculation method
  Future<void> saveCalculationMethod(int methodIndex) async {
    await _prefs.setInt(_calculationMethodKey, methodIndex);
  }

  // Get madhab from preferences or default
  Madhab getMadhab() {
    final madhhabIndex = _prefs.getInt(_madhhabKey) ?? 0;
    return madhhabIndex == 0 ? Madhab.shafi : Madhab.hanafi;
  }

  // Save madhab
  Future<void> saveMadhab(int madhhabIndex) async {
    await _prefs.setInt(_madhhabKey, madhhabIndex);
  }

  // Get prayer times for a specific date
  Future<PrayerTimeModel> getPrayerTimes({DateTime? date, Location? location}) async {
    Coordinates coordinates;
    
    if (location != null) {
      coordinates = location.toCoordinates();
    } else {
      coordinates = await getCurrentLocation();
    }
    
    final calculationParameters = getCalculationMethod();
    calculationParameters.madhab = getMadhab();
    
    final dateComponents = date != null 
        ? DateComponents.from(date)
        : DateComponents.from(DateTime.now());
    
    final prayerTimes = PrayerTimes(coordinates, dateComponents, calculationParameters);
    
    return PrayerTimeModel.fromPrayerTimes(prayerTimes, coordinates, calculationParameters);
  }
} 