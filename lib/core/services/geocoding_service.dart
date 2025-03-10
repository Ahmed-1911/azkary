import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart' as geo;
import '../../features/prayer_times/data/models/location.dart';

class GeocodingService {
  /// Get the city name from coordinates
  Future<String?> getCityFromCoordinates(double latitude, double longitude) async {
    try {
      debugPrint('Getting city name for coordinates: $latitude, $longitude');
      final placemarks = await geo.placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        
        // Try to get the most specific location name
        final locality = placemark.locality; // City
        final subAdministrativeArea = placemark.subAdministrativeArea; // District/County
        final administrativeArea = placemark.administrativeArea; // State/Province
        final country = placemark.country; // Country
        
        debugPrint('Placemark data: locality=$locality, subAdministrativeArea=$subAdministrativeArea, '
            'administrativeArea=$administrativeArea, country=$country');
        
        // Return the most specific non-null location name
        if (locality != null && locality.isNotEmpty) {
          debugPrint('Using locality: $locality');
          return locality;
        } else if (subAdministrativeArea != null && subAdministrativeArea.isNotEmpty) {
          debugPrint('Using subAdministrativeArea: $subAdministrativeArea');
          return subAdministrativeArea;
        } else if (administrativeArea != null && administrativeArea.isNotEmpty) {
          debugPrint('Using administrativeArea: $administrativeArea');
          return administrativeArea;
        } else if (country != null && country.isNotEmpty) {
          debugPrint('Using country: $country');
          return country;
        }
      } else {
        debugPrint('No placemarks found for coordinates: $latitude, $longitude');
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting city name: $e');
      return null;
    }
  }
  
  /// Get a location with city name from coordinates
  Future<Location> getLocationWithCityName(Location location) async {
    debugPrint('Getting location with city name for: $location');
    
    if (location.cityName != null) {
      debugPrint('Location already has city name: ${location.cityName}');
      return location;
    }
    
    final cityName = await getCityFromCoordinates(location.latitude, location.longitude);
    final updatedLocation = location.copyWith(cityName: cityName);
    debugPrint('Updated location with city name: $updatedLocation');
    return updatedLocation;
  }
} 