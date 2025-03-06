import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/azkar.dart';
import '../../domain/entities/azkar_category.dart';
import '../providers/azkar_provider.dart';

class AzkarListController extends StateNotifier<Map<String, bool>> {
  final Ref ref;
  final AzkarCategory category;
  bool _isInitialized = false;
  bool _isDisposed = false;

  AzkarListController(this.ref, this.category) : super({});

  void initializeIfNeeded() {
    if (!_isInitialized && !_isDisposed) {
      _initializeRepeatCounts();
      _isInitialized = true;
    }
  }

  void _initializeRepeatCounts() {
    if (_isDisposed) return;
    
    try {
      final azkarList = ref.read(azkarByCategoryProvider(category.id));
      for (final azkar in azkarList) {
        ref.read(azkarRepeatCountsProvider.notifier).initializeCount(azkar.id, azkar.repeatCount);
      }
    } catch (e) {
      // Ignore errors during initialization
    }
  }

  List<Azkar> getDisplayedAzkar() {
    if (_isDisposed) return [];
    
    try {
      final azkarList = ref.read(azkarByCategoryProvider(category.id));
      return azkarList.where((azkar) => 
        !ref.read(azkarRepeatCountsProvider.notifier).isCompleted(azkar.id)
      ).toList();
    } catch (e) {
      return [];
    }
  }

  void handleCountDecrement(String azkarId, int currentCount) {
    if (_isDisposed) return;
    
    if (currentCount <= 1) {
      state = Map<String, bool>.from(state)..addAll({azkarId: true});
      
      // Capture ref before async operation
      final capturedRef = ref;
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!_isDisposed) {
          try {
            capturedRef.read(azkarRepeatCountsProvider.notifier).decrementCount(azkarId);
            state = Map<String, bool>.from(state)..remove(azkarId);
          } catch (e) {
            // Ignore errors during delayed operation
          }
        }
      });
    } else {
      try {
        ref.read(azkarRepeatCountsProvider.notifier).decrementCount(azkarId);
      } catch (e) {
        // Ignore errors during decrement
      }
    }
  }

  void resetAllCounts() {
    if (_isDisposed) return;
    
    try {
      state = {};
      final azkarList = ref.read(azkarByCategoryProvider(category.id));
      for (final azkar in azkarList) {
        ref.read(azkarRepeatCountsProvider.notifier)
           .resetCount(azkar.id, azkar.repeatCount);
      }
    } catch (e) {
      // Ignore errors during reset
    }
  }

  bool isItemFading(String azkarId) {
    return state[azkarId] ?? false;
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
} 