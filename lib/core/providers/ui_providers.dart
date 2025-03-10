import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to control the visibility of the bottom navigation bar
final bottomNavBarVisibilityProvider = StateProvider<bool>((ref) => true);

/// Function to toggle the bottom navigation bar visibility
void toggleBottomNavBarVisibility(WidgetRef ref) {
  final isVisible = ref.read(bottomNavBarVisibilityProvider);
  ref.read(bottomNavBarVisibilityProvider.notifier).state = !isVisible;
}

/// Function to set the bottom navigation bar visibility
void setBottomNavBarVisibility(WidgetRef ref, bool isVisible) {
  ref.read(bottomNavBarVisibilityProvider.notifier).state = isVisible;
} 