import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/azkar.dart';
import '../../domain/entities/azkar_category.dart';
import '../providers/azkar_provider.dart';

class AzkarListController extends StateNotifier<Map<String, bool>> {
  final Ref ref;
  final AzkarCategory category;
  bool _isInitialized = false;

  AzkarListController(this.ref, this.category) : super({});

  void initializeIfNeeded() {
    if (!_isInitialized) {
      _initializeRepeatCounts();
      _isInitialized = true;
    }
  }

  void _initializeRepeatCounts() {
    final azkarList = ref.read(azkarByCategoryProvider(category.id));
    for (final azkar in azkarList) {
      ref.read(azkarRepeatCountsProvider.notifier).initializeCount(azkar.id, azkar.repeatCount);
    }
  }

  List<Azkar> getDisplayedAzkar() {
    final azkarList = ref.read(azkarByCategoryProvider(category.id));
    return azkarList.where((azkar) => 
      !ref.read(azkarRepeatCountsProvider.notifier).isCompleted(azkar.id)
    ).toList();
  }

  void handleCountDecrement(String azkarId, int currentCount) {
    if (currentCount <= 1) {
      state = Map<String, bool>.from(state)..addAll({azkarId: true});
      
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(azkarRepeatCountsProvider.notifier).decrementCount(azkarId);
        state = Map<String, bool>.from(state)..remove(azkarId);
      });
    } else {
      ref.read(azkarRepeatCountsProvider.notifier).decrementCount(azkarId);
    }
  }

  void resetAllCounts() {
    state = {};
    final azkarList = ref.read(azkarByCategoryProvider(category.id));
    for (final azkar in azkarList) {
      ref.read(azkarRepeatCountsProvider.notifier)
         .resetCount(azkar.id, azkar.repeatCount);
    }
  }

  bool isItemFading(String azkarId) {
    return state[azkarId] ?? false;
  }
} 