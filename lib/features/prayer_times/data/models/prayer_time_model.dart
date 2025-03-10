import 'package:adhan/adhan.dart';

class PrayerTimeModel {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;

  PrayerTimeModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory PrayerTimeModel.fromPrayerTimes(PrayerTimes prayerTimes) {
    return PrayerTimeModel(
      fajr: prayerTimes.fajr,
      sunrise: prayerTimes.sunrise,
      dhuhr: prayerTimes.dhuhr,
      asr: prayerTimes.asr,
      maghrib: prayerTimes.maghrib,
      isha: prayerTimes.isha,
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
      // Calculate next day's Fajr
      final coordinates = Coordinates(0, 0); // Placeholder, will be replaced
      final date = DateComponents.from(currentTime.add(const Duration(days: 1)));
      final params = CalculationMethod.egyptian.getParameters();
      final prayerTimes = PrayerTimes(coordinates, date, params);
      return prayerTimes.fajr;
    }
  }
} 