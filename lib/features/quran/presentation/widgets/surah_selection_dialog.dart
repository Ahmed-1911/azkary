import 'package:azkary/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/surah_model.dart';

class SurahSelectionDialog extends StatelessWidget {
  final Function(int) onPageSelected;

  const SurahSelectionDialog({
    super.key,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 0.9.sw,
        height: 0.7.sh,
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Text(
              S.of(context).selectSurah,
              style: TextStyle(
                fontSize: 20.spMin,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: surahs.length,
                itemBuilder: (context, index) {
                  final surah = surahs[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          '${surah.number}.',
                          style: TextStyle(
                            fontSize: 16.spMin,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                surah.nameArabic,
                                style: TextStyle(
                                  fontSize: 18.spMin,
                                  fontFamily: 'Uthmanic',
                                ),
                              ),
                            
                            ],
                          ),
                        ),
                        Text(
                          'ص ${surah.startPage}',
                          style: TextStyle(
                            fontSize: 14.spMin,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onPageSelected(surah.startPage);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 