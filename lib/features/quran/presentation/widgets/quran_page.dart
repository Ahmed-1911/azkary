import 'package:azkary/features/quran/data/models/surah_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:azkary/generated/l10n.dart';
import 'package:azkary/core/services/ads_service.dart';

class QuranPage extends ConsumerWidget {
  final int pageNumber;
  final Function? onPageChanged;

  const QuranPage({
    Key? key,
    required this.pageNumber,
    this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final adsService = ref.read(adsServiceProvider.notifier);

    return Container(
        color: const Color.fromARGB(255, 245, 243, 233),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildPageHeader(context),
            5.verticalSpace,
            _buildPageImage(context, l10n),
          ],
        ),
      
    );  
  }

  // Show interstitial ad based on certain conditions
  static bool shouldShowInterstitialAd(int pageNumber) {
    // Primary strategy: Show interstitial ad every 22 pages
    // This provides good balance between monetization and user experience
    bool shouldShow =
        ((pageNumber % 20 == 0) || (pageNumber % 20 == 1)) && (pageNumber > 1);

    return shouldShow;
  }

  // Method to check if interstitial should be shown and show it
  static Future<void> maybeShowInterstitialAd(
      WidgetRef ref, int pageNumber) async {
    if (shouldShowInterstitialAd(pageNumber)) {
      final adsService = ref.read(adsServiceProvider.notifier);
      await adsService.showInterstitialAd();
    }
  }

  Widget _buildPageHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Surah name
          Text(
            surahs
                .firstWhere(
                  (surah) =>
                      surah.startPage <= pageNumber &&
                      (surah.endPage ?? surah.startPage) >= pageNumber,
                  orElse: () => surahs.first,
                )
                .nameArabic,
            style: TextStyle(
              fontSize: 12.spMin,
              fontFamily: 'Uthmanic',
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 145, 64, 11),
            ),
          ),
          // Page number
          Text(
            '$pageNumber',
            style: TextStyle(
              fontSize: 12.spMin,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 145, 64, 11),
            ),
          ),
          // Juz number
          Text(
            ' جزء ${((pageNumber - 2) ~/ 20 + 1)}',
            style: TextStyle(
              fontSize: 12.spMin,
              color: const Color.fromARGB(255, 145, 64, 11),
              fontWeight: FontWeight.bold,
              fontFamily: 'Uthmanic',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageImage(BuildContext context, S l10n) {
    return Center(
      child: Image.asset(
        'assets/images/quran/p$pageNumber.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              l10n.pageNotAvailable(pageNumber),
              style: TextStyle(
                fontSize: 18.spMin,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}
