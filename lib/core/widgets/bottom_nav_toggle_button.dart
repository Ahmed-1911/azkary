import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ui_providers.dart';

/// A button that toggles the visibility of the bottom navigation bar
class BottomNavToggleButton extends ConsumerWidget {
  /// The icon to display when the bottom navigation bar is visible
  final IconData visibleIcon;
  
  /// The icon to display when the bottom navigation bar is hidden
  final IconData hiddenIcon;
  
  /// The color of the icon
  final Color? iconColor;
  
  /// The size of the icon
  final double? iconSize;
  
  /// The tooltip to display when hovering over the button
  final String? tooltip;

  const BottomNavToggleButton({
    super.key,
    this.visibleIcon = Icons.keyboard_arrow_down,
    this.hiddenIcon = Icons.keyboard_arrow_up,
    this.iconColor,
    this.iconSize,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isVisible = ref.watch(bottomNavBarVisibilityProvider);
    
    return IconButton(
      icon: Icon(
        isVisible ? visibleIcon : hiddenIcon,
        color: iconColor,
        size: iconSize,
      ),
      tooltip: tooltip ?? (isVisible ? 'Hide navigation bar' : 'Show navigation bar'),
      onPressed: () => toggleBottomNavBarVisibility(ref),
    );
  }
} 