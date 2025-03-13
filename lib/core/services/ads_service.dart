import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform;

class AdsState {
  final bool isBannerAdLoaded;
  final BannerAd? bannerAd;

  const AdsState({
    this.isBannerAdLoaded = false,
    this.bannerAd,
  });

  AdsState copyWith({
    bool? isBannerAdLoaded,
    BannerAd? bannerAd,
  }) {
    return AdsState(
      isBannerAdLoaded: isBannerAdLoaded ?? this.isBannerAdLoaded,
      bannerAd: bannerAd ?? this.bannerAd,
    );
  }
}

final adsServiceProvider = StateNotifierProvider<AdsService, AdsState>((ref) => AdsService());

class AdsService extends StateNotifier<AdsState> {
  AdsService() : super(const AdsState());

  static String get _bannerAdUnitId {
    if (kDebugMode) {
      // Use Google's test ad unit IDs for development
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    // Your real ad unit ID for production
    return 'ca-app-pub-5104972431757675/8554241461';
  }

  int _retryAttempt = 0;
  static const int _maxRetryAttempts = 3;

  void initBannerAd() {
    BannerAd? newBannerAd;
    try {
      newBannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            debugPrint('Banner ad loaded successfully');
            if (!mounted) return;
            state = AdsState(
              isBannerAdLoaded: true,
              bannerAd: newBannerAd,
            );
            _retryAttempt = 0; // Reset retry counter on success
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('Banner ad failed to load: ${error.message}');
            if (!mounted) return;
            state = const AdsState(isBannerAdLoaded: false);
            ad.dispose();
            
            // Implement retry logic with backoff
            if (_retryAttempt < _maxRetryAttempts) {
              _retryAttempt++;
              Future.delayed(
                Duration(seconds: _retryAttempt * 2), // Exponential backoff
                () => initBannerAd(),
              );
            }
          },
        ),
      );

      newBannerAd.load();
    } catch (e) {
      debugPrint('Error initializing banner ad: $e');
      if (!mounted) return;
      state = const AdsState(isBannerAdLoaded: false);
      newBannerAd?.dispose();
    }
  }

  void disposeBannerAd() {
    try {
      state.bannerAd?.dispose();
    } catch (e) {
      debugPrint('Error disposing banner ad: $e');
    } finally {
      state = const AdsState();
      _retryAttempt = 0;
    }
  }
} 