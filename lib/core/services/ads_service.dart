import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adsServiceProvider = Provider((ref) => AdsService());

class AdsService {
  static const String _bannerAdUnitId = 'ca-app-pub-5104972431757675/2103070101';
  // Use test ad unit ID for development
  // static const String _bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';

  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  int _retryAttempt = 0;
  static const int _maxRetryAttempts = 3;

  bool get isBannerAdLoaded => _isBannerAdLoaded;
  BannerAd? get bannerAd => _bannerAd;

  void initBannerAd() {
    try {
      _bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            _isBannerAdLoaded = true;
            _retryAttempt = 0; // Reset retry counter on success
          },
          onAdFailedToLoad: (ad, error) {
            _isBannerAdLoaded = false;
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

      _bannerAd?.load();
    } catch (e) {
      // Silently handle exceptions to prevent app crashes
      _isBannerAdLoaded = false;
    }
  }

  void disposeBannerAd() {
    try {
      _bannerAd?.dispose();
    } catch (e) {
      // Ignore errors during disposal
    } finally {
      _bannerAd = null;
      _isBannerAdLoaded = false;
      _retryAttempt = 0;
    }
  }
} 