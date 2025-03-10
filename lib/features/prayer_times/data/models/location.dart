import 'package:adhan/adhan.dart';

class Location {
  final double latitude;
  final double longitude;
  final String? cityName;

  Location({
    this.latitude = 21.4225, // Default to Mecca coordinates
    this.longitude = 39.8262,
    this.cityName,
  });

  Coordinates toCoordinates() {
    return Coordinates(latitude, longitude);
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
    );
  }

  @override
  String toString() {
    return 'Location(latitude: $latitude, longitude: $longitude, cityName: $cityName)';
  }
} 