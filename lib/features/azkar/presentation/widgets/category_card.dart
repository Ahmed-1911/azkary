import 'package:azkary/features/azkar/presentation/providers/azkar_provider.dart';
import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/azkar_category.dart';

class CategoryCard extends StatelessWidget {
  final AzkarCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withAlpha(200),
                Theme.of(context).primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category.icon,
                  size: 40.spMin,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Text(
                  Localizations.localeOf(context).languageCode == 'en'
                      ? category.name
                      : category.nameAr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Consumer(builder: (context, ref, child) {
                  return Text(
                    '${ref.read(azkarByCategoryProvider(category.id)).length} ${ S.of(context).azkar}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                        ),
                  );
                },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
