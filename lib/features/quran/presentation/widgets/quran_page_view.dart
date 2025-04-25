import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/quran_providers.dart';
import 'quran_page.dart';

class QuranPageView extends ConsumerWidget {
  final PageController pageController;
  final Function(int) onPageChanged;

  const QuranPageView({
    Key? key,
    required this.pageController,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalPages = ref.watch(totalQuranPagesProvider);
    
    return PageView.builder(
      controller: pageController,
      reverse: true, // To read from right to left
      onPageChanged: (index) {
        final newPage = totalPages - index - 1;
        ref.read(currentQuranPageProvider.notifier).state = newPage;

        // Save the page whenever it changes
        onPageChanged(newPage);

        // Show interstitial ad based on page number
        QuranPage.maybeShowInterstitialAd(ref, newPage);
      },
      itemCount: totalPages,
      itemBuilder: (context, index) {
        // Convert from 0-based index to 1-based page number
        final pageNumber = totalPages - index;
        return QuranPage(pageNumber: pageNumber);
      },
    );
  }
}
