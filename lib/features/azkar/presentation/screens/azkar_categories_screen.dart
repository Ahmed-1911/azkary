import 'package:azkary/features/azkar/presentation/screens/azkar_list_screen.dart';
import 'package:azkary/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/category_card.dart';
import '../providers/azkar_provider.dart';

class AzkarCategoriesScreen extends ConsumerWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categories = ref.watch(azkarCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.azkarCategories),
        centerTitle: true,
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