import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../controllers/qibla_controller.dart';

// Provider for the QiblaController
final qiblaControllerProvider = Provider<QiblaController>((ref) {
  return QiblaController(ref);
});

// A state notifier to handle loading state
class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);
  
  void setLoading(bool isLoading) => state = isLoading;
}

// A state notifier to handle error messages
class ErrorMessageNotifier extends StateNotifier<String?> {
  ErrorMessageNotifier() : super(null);
  
  void setError(String? message) => state = message;
}

// A state notifier to handle position data
class PositionNotifier extends StateNotifier<Position?> {
  PositionNotifier() : super(null);
  
  void setPosition(Position? position) => state = position;
}

// A state notifier to handle compass direction
class CompassDirectionNotifier extends StateNotifier<double?> {
  CompassDirectionNotifier() : super(null);
  
  void setDirection(double? direction) => state = direction;
}

// A state notifier to handle qibla direction
class QiblaDirectionNotifier extends StateNotifier<double?> {
  QiblaDirectionNotifier() : super(null);
  
  void setDirection(double? direction) => state = direction;
}

// A state notifier to handle manual mode
class ManualModeNotifier extends StateNotifier<bool> {
  ManualModeNotifier() : super(false);
  
  void toggleMode() => state = !state;
  void setMode(bool isManual) => state = isManual;
}

// A state notifier to handle qibla angle
class QiblaAngleNotifier extends StateNotifier<double?> {
  QiblaAngleNotifier() : super(null);
  
  void setAngle(double? angle) => state = angle;
}

// StateNotifierProviders
final isLoadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});

final errorMessageProvider = StateNotifierProvider<ErrorMessageNotifier, String?>((ref) {
  return ErrorMessageNotifier();
});

final currentPositionProvider = StateNotifierProvider<PositionNotifier, Position?>((ref) {
  return PositionNotifier();
});

final compassDirectionProvider = StateNotifierProvider<CompassDirectionNotifier, double?>((ref) {
  return CompassDirectionNotifier();
});

final qiblaDirectionProvider = StateNotifierProvider<QiblaDirectionNotifier, double?>((ref) {
  return QiblaDirectionNotifier();
});

final manualModeProvider = StateNotifierProvider<ManualModeNotifier, bool>((ref) {
  return ManualModeNotifier();
});

final qiblaAngleProvider = StateNotifierProvider<QiblaAngleNotifier, double?>((ref) {
  return QiblaAngleNotifier();
}); 