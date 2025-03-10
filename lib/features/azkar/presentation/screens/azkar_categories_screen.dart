import 'dart:developer';
import 'dart:io';

import 'package:azkary/features/azkar/presentation/screens/azkar_list_screen.dart';
import 'package:azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/category_card.dart';
import '../providers/azkar_provider.dart';

class AzkarCategoriesScreen extends ConsumerWidget {
  const AzkarCategoriesScreen({super.key});

  // Show instructions for adding the widget to home screen
  void _showWidgetInstructions(BuildContext context) {
    _showWidgetInfoDialog(context);
  }

  void _showWidgetInfoDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addWidgetToHomeScreen),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.widgetNeededOnHomeScreen,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(l10n.toAddWidget),
              const SizedBox(height: 8),
              _buildInstructionStep(context, 1, l10n.longPressHomeScreen),
              _buildInstructionStep(context, 2, l10n.selectWidgets),
              _buildInstructionStep(context, 3, l10n.findAzkaryWidget),
              _buildInstructionStep(context, 4, l10n.dragWidget),
              const SizedBox(height: 16),
              Text(
                l10n.widgetUpdateInstructions,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
              if (Platform.isAndroid) ...[
                const SizedBox(height: 16),
                Text(
                  l10n.deviceSpecificNote,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(BuildContext context, int number, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(instruction)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categories = ref.watch(azkarCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.azkarCategories),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_to_home_screen),
            tooltip: l10n.addWidgetToHomeScreen,
            onPressed: () => _showWidgetInstructions(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(
              category: category,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AzkarListScreen(category: category),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 