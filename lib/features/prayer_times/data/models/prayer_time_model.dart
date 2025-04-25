import 'package:adhan/adhan.dart';

class PrayerTimeModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final Coordinates coordinates;
  final CalculationParameters calculationParameters;

  PrayerTimeModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.coordinates,
    required this.calculationParameters,
  });

  factory PrayerTimeModel.fromPrayerTimes(PrayerTimes prayerTimes, Coordinates coordinates, CalculationParameters params) {
    return PrayerTimeModel(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
      coordinates: coordinates,
      calculationParameters: params,
    );
  }

  String getNextPrayer(DateTime currentTime) {
    if (currentTime.isBefore(fajr)) {
      return 'Fajr';
    } else if (currentTime.isBefore(sunrise)) {
      return 'Sunrise';
    } else if (currentTime.isBefore(dhuhr)) {
      return 'Dhuhr';
    } else if (currentTime.isBefore(asr)) {
      return 'Asr';
    } else if (currentTime.isBefore(maghrib)) {
      return 'Maghrib';
    } else if (currentTime.isBefore(isha)) {
      return 'Isha';
    } else {
      return 'Fajr'; // Next day's Fajr
    }
  }

  DateTime getNextPrayerTime(DateTime currentTime) {
    if (currentTime.isBefore(fajr)) {
      return fajr;
    } else if (currentTime.isBefore(sunrise)) {
      return sunrise;
    } else if (currentTime.isBefore(dhuhr)) {
      return dhuhr;
    } else if (currentTime.isBefore(asr)) {
      return asr;
    } else if (currentTime.isBefore(maghrib)) {
      return maghrib;
    } else if (currentTime.isBefore(isha)) {
      return isha;
    } else {
      // Calculate next day's Fajr using the same coordinates and calculation parameters
      final date = DateComponents.from(currentTime.add(const Duration(days: 1)));
      final prayerTimes = PrayerTimes(coordinates, date, calculationParameters);
      return prayerTimes.fajr;
    }
  }
} 