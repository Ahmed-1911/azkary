import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class QiblaController {
  final Ref ref;

  QiblaController(this.ref);

  // Coordinates for Kaaba in Mecca
  static const double kaabaLatitude = 21.422487;
  static const double kaabaLongitude = 39.826206;

  // Calculate the Qibla direction
  double calculateQiblaDirection(Position currentPosition) {
    // Calculate the Qibla direction using the great circle formula
    double lat1 = currentPosition.latitude * (pi / 180);
    double lon1 = currentPosition.longitude * (pi / 180);
    double lat2 = kaabaLatitude * (pi / 180);
    double lon2 = kaabaLongitude * (pi / 180);

    double y = sin(lon2 - lon1) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon2 - lon1);
    double qiblaRadians = atan2(y, x);
    double qiblaDegrees = qiblaRadians * (180 / pi);
    
    // Convert to 0-360 range
    return (qiblaDegrees + 360) % 360;
  }

  // Calculate distance to Kaaba in kilometers
  double calculateDistanceToKaaba(Position currentPosition) {
    return Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      kaabaLatitude,
      kaabaLongitude,
    ) / 1000; // Convert meters to kilometers
  }

  // Get cardinal direction based on angle in degrees
  String getCardinalDirection(double degrees) {
    const List<String> directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW', 'N'];
    return directions[(degrees / 45).round() % 8];
  }
} 