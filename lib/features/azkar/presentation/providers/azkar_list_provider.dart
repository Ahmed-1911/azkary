import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/azkar_category.dart';
import '../controllers/azkar_list_controller.dart';

final azkarListControllerProvider = StateNotifierProvider.family<AzkarListController, Map<String, bool>, AzkarCategory>(
  (ref, category) => AzkarListController(ref, category),
); 