import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io' show Platform;

class AdsState {
  final bool isBannerAdLoaded;
  final BannerAd? bannerAd;
  final bool isNativeAdLoaded;
  final NativeAd? nativeAd;
  final bool isInterstitialAdLoaded;
  final InterstitialAd? interstitialAd;
  final bool isInitialized;
  final bool isInitializing;
  final DateTime? lastNativeAdRequestTime;
  final DateTime? lastBannerAdRequestTime;
  final DateTime? lastInterstitialAdRequestTime;

  const AdsState({
    this.isBannerAdLoaded = false,
    this.bannerAd,
    this.isNativeAdLoaded = false,
    this.nativeAd,
    this.isInterstitialAdLoaded = false,
    this.interstitialAd,
    this.isInitialized = false,
    this.isInitializing = false,
    this.lastNativeAdRequestTime,
    this.lastBannerAdRequestTime,
    this.lastInterstitialAdRequestTime,
  });

  AdsState copyWith({
    bool? isBannerAdLoaded,
    BannerAd? bannerAd,
    bool? isNativeAdLoaded,
    NativeAd? nativeAd,
    bool? isInterstitialAdLoaded,
    InterstitialAd? interstitialAd,
    bool? isInitialized,
    bool? isInitializing,
    DateTime? lastNativeAdRequestTime,
    DateTime? lastBannerAdRequestTime,
    DateTime? lastInterstitialAdRequestTime,
  }) {
    return AdsState(
      isBannerAdLoaded: isBannerAdLoaded ?? this.isBannerAdLoaded,
      bannerAd: bannerAd ?? this.bannerAd,
      isNativeAdLoaded: isNativeAdLoaded ?? this.isNativeAdLoaded,
      nativeAd: nativeAd ?? this.nativeAd,
      isInterstitialAdLoaded: isInterstitialAdLoaded ?? this.isInterstitialAdLoaded,
      interstitialAd: interstitialAd ?? this.interstitialAd,
      isInitialized: isInitialized ?? this.isInitialized,
      isInitializing: isInitializing ?? this.isInitializing,
      lastNativeAdRequestTime: lastNativeAdRequestTime ?? this.lastNativeAdRequestTime,
      lastBannerAdRequestTime: lastBannerAdRequestTime ?? this.lastBannerAdRequestTime,
      lastInterstitialAdRequestTime: lastInterstitialAdRequestTime ?? this.lastInterstitialAdRequestTime,
    );
  }
}

final adsServiceProvider = StateNotifierProvider<AdsService, AdsState>((ref) => AdsService());

class AdsService extends StateNotifier<AdsState> {
  // Cooldown periods to prevent too many requests
  static const Duration _bannerAdCooldown = Duration(seconds: 30);
  static const Duration _nativeAdCooldown = Duration(seconds: 30);
  static const Duration _interstitialAdCooldown = Duration(seconds: 60);
  
  AdsService() : super(const AdsState()) {
    // Configure test devices
    if (kDebugMode) {
      MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: ['65FFD34FB37E602946F82B73928596C1'],
        ),
      );
    }
  }

  // Initialize all ads at once
  Future<void> initialize() async {
    // If already initialized or initializing, don't do it again
    if (state.isInitialized || state.isInitializing) {
      debugPrint('Ads already initialized or initializing. Skipping initialization.');
      return;
    }
    
    // Mark as initializing
    state = state.copyWith(isInitializing: true);
    
    try {
      debugPrint('Starting ad initialization sequence');
      
      // Initialize banner ad first
      debugPrint('Initializing banner ad');
      initBannerAd();
      
      // Add a delay between banner and native ad initialization to prevent resource contention
      await Future.delayed(const Duration(seconds: 2));
      
      // Initialize native ad
      debugPrint('Initializing native ad');
      initNativeAd();

      // Add a delay before initializing interstitial ad
      await Future.delayed(const Duration(seconds: 2));
      
      // Initialize interstitial ad
      debugPrint('Initializing interstitial ad');
      initInterstitialAd();
      
      // Mark as initialized
      state = state.copyWith(
        isInitialized: true,
        isInitializing: false,
      );
      
      debugPrint('Ad initialization sequence completed');
    } catch (e) {
      debugPrint('Error during ad initialization sequence: $e');
      state = state.copyWith(isInitializing: false);
      
      // Retry initialization after a delay
      Future.delayed(
        const Duration(seconds: 10),
        () {
          if (mounted && !state.isInitialized && !state.isInitializing) {
            debugPrint('Retrying ad initialization sequence');
            initialize();
          }
        },
      );
    }
  }

  // Check if native ad is loaded and load if needed
  void ensureNativeAdLoaded() {
    if (!state.isNativeAdLoaded || state.nativeAd == null) {
      debugPrint('Native ad not loaded, loading now');
      initNativeAd();
    } else {
      debugPrint('Native ad already loaded, no need to reload');
    }
  }

  // Check if banner ad is loaded and load if needed
  void ensureBannerAdLoaded() {
    if (!state.isBannerAdLoaded || state.bannerAd == null) {
      debugPrint('Banner ad not loaded, loading now');
      initBannerAd();
    } else {
      debugPrint('Banner ad already loaded, no need to reload');
    }
  }

  // Check if interstitial ad is loaded and load if needed
  void ensureInterstitialAdLoaded() {
    if (!state.isInterstitialAdLoaded || state.interstitialAd == null) {
      debugPrint('Interstitial ad not loaded, loading now');
      initInterstitialAd();
    } else {
      debugPrint('Interstitial ad already loaded, no need to reload');
    }
  }

  static String get _primaryBannerAdUnitId {
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

  static String get _alternativeBannerAdUnitId {
    if (kDebugMode) {
      // Use Google's test ad unit IDs for development
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/6300978111';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/2934735716';
      }
    }
    // Your alternative ad unit ID for production
    return 'ca-app-pub-5104972431757675/6414732081';
  }

  static String get _nativeAdUnitId {
    if (kDebugMode) {
      // Use Google's test ad unit IDs for development
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/2247696110';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/3986624511';
      }
    }
    // Your real native ad unit ID for production
    return 'ca-app-pub-5104972431757675/7021236747';
  }

  static String get _interstitialAdUnitId {
    if (kDebugMode) {
      // Use Google's test ad unit IDs for development
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/1033173712';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/4411468910';
      }
    }
    // Your real interstitial ad unit ID for production
    // NOTE: Ensure this is created as an Interstitial ad format in your AdMob account
    // If you get "Ad unit doesn't match format" error, verify the format in AdMob console
    return 'ca-app-pub-5104972431757675/2301645530'; // Using test ID until correct one is configured
    // TODO: Replace with your correct interstitial ad unit ID
    // return 'ca-app-pub-5104972431757675/4604498959';
  }

  int _bannerRetryAttempt = 0;
  int _nativeRetryAttempt = 0;
  int _interstitialRetryAttempt = 0;
  static const int _maxRetryAttempts = 3;
  bool _isUsingAlternativeBannerAd = false;

  void initBannerAd() {
    // If banner ad is already loaded, don't request a new one
    if (state.isBannerAdLoaded && state.bannerAd != null) {
      debugPrint('Banner ad already loaded. No need to request a new one.');
      return;
    }
    
    // Check if we're within the cooldown period
    final now = DateTime.now();
    if (state.lastBannerAdRequestTime != null) {
      final timeSinceLastRequest = now.difference(state.lastBannerAdRequestTime!);
      if (timeSinceLastRequest < _bannerAdCooldown) {
        debugPrint('Banner ad request cooldown in effect. Try again in ${(_bannerAdCooldown - timeSinceLastRequest).inSeconds} seconds.');
        return;
      }
    }
    
    // Update last request time
    state = state.copyWith(lastBannerAdRequestTime: now);
    
    _loadBannerAd(_isUsingAlternativeBannerAd);
  }

  void _loadBannerAd(bool useAlternative) {
    final adUnitId = useAlternative ? _alternativeBannerAdUnitId : _primaryBannerAdUnitId;
    BannerAd? newBannerAd;
    
    try {
      newBannerAd = BannerAd(
        adUnitId: adUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            debugPrint('Banner ad loaded successfully${useAlternative ? " (alternative)" : ""}');
            if (!mounted) return;
            state = state.copyWith(
              isBannerAdLoaded: true,
              bannerAd: newBannerAd,
            );
            _bannerRetryAttempt = 0; // Reset retry counter on success
            _isUsingAlternativeBannerAd = useAlternative; // Remember which ad unit was successful
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('Banner ad failed to load${useAlternative ? " (alternative)" : ""}: ${error.message}');
            
            try {
              ad.dispose();
            } catch (e) {
              debugPrint('Error disposing banner ad after failure: $e');
            }
            
            if (!mounted) return;
            
            // If primary ad failed and we haven't tried alternative yet, try the alternative
            if (!useAlternative) {
              debugPrint('Trying alternative banner ad unit');
              _loadBannerAd(true);
              return;
            }
            
            // Both primary and alternative failed, implement retry logic with backoff
            state = state.copyWith(isBannerAdLoaded: false);
            
            if (_bannerRetryAttempt < _maxRetryAttempts) {
              _bannerRetryAttempt++;
              final delay = Duration(seconds: _bannerRetryAttempt * 5); // Longer delay for more stability
              debugPrint('Will retry banner ad in ${delay.inSeconds} seconds (attempt $_bannerRetryAttempt of $_maxRetryAttempts)');
              
              Future.delayed(
                delay,
                () {
                  if (mounted) {
                    debugPrint('Retrying banner ad load (attempt $_bannerRetryAttempt)');
                    // Start with primary ad again on retry
                    _isUsingAlternativeBannerAd = false;
                    initBannerAd();
                  }
                },
              );
            } else {
              debugPrint('Maximum banner ad retry attempts reached ($_maxRetryAttempts). Giving up.');
            }
          },
        ),
      );

      newBannerAd.load().onError((error, stackTrace) {
        debugPrint('Banner ad failed to load${useAlternative ? " (alternative)" : ""}: $error');
        debugPrint('Stack trace: $stackTrace');
        return false;
      });
    } catch (e) {
      debugPrint('Error initializing banner ad${useAlternative ? " (alternative)" : ""}: $e');
      if (!mounted) return;
      
      // If primary ad failed and we haven't tried alternative yet, try the alternative
      if (!useAlternative) {
        debugPrint('Trying alternative banner ad unit after error');
        _loadBannerAd(true);
        return;
      }
      
      // Both primary and alternative failed
      state = state.copyWith(isBannerAdLoaded: false);
      
      try {
        newBannerAd?.dispose();
      } catch (disposeError) {
        debugPrint('Error disposing banner ad after initialization error: $disposeError');
      }
      
      // Retry with exponential backoff even for initialization errors
      if (_bannerRetryAttempt < _maxRetryAttempts) {
        _bannerRetryAttempt++;
        final delay = Duration(seconds: _bannerRetryAttempt * 5);
        debugPrint('Will retry banner ad initialization in ${delay.inSeconds} seconds (attempt $_bannerRetryAttempt of $_maxRetryAttempts)');
        
        Future.delayed(
          delay,
          () {
            if (mounted) {
              debugPrint('Retrying banner ad initialization (attempt $_bannerRetryAttempt)');
              _isUsingAlternativeBannerAd = false;
              initBannerAd();
            }
          },
        );
      } else {
        debugPrint('Maximum banner ad retry attempts reached ($_maxRetryAttempts). Giving up.');
      }
    }
  }

  void initNativeAd() {
    // If native ad is already loaded, don't request a new one
    if (state.isNativeAdLoaded && state.nativeAd != null) {
      debugPrint('Native ad already loaded. No need to request a new one.');
      return;
    }
    
    // Check if we're within the cooldown period
    final now = DateTime.now();
    if (state.lastNativeAdRequestTime != null) {
      final timeSinceLastRequest = now.difference(state.lastNativeAdRequestTime!);
      if (timeSinceLastRequest < _nativeAdCooldown) {
        debugPrint('Native ad request cooldown in effect. Try again in ${(_nativeAdCooldown - timeSinceLastRequest).inSeconds} seconds.');
        return;
      }
    }
    
    // Update last request time
    state = state.copyWith(lastNativeAdRequestTime: now);
    
    NativeAd? newNativeAd;
    try {
      newNativeAd = NativeAd(
        adUnitId: _nativeAdUnitId,
        listener: NativeAdListener(
          onAdLoaded: (_) {
            debugPrint('Native ad loaded successfully');
            if (!mounted) return;
            state = state.copyWith(
              isNativeAdLoaded: true,
              nativeAd: newNativeAd,
            );
            _nativeRetryAttempt = 0; // Reset retry counter on success
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('Native ad failed to load: ${error.message}');
            if (!mounted) return;
            state = state.copyWith(isNativeAdLoaded: false);
            
            try {
              ad.dispose();
            } catch (e) {
              debugPrint('Error disposing native ad after failure: $e');
            }
            
            // Implement retry logic with exponential backoff
            if (_nativeRetryAttempt < _maxRetryAttempts) {
              _nativeRetryAttempt++;
              final delay = Duration(seconds: _nativeRetryAttempt * 5); // Longer delay for more stability
              debugPrint('Will retry native ad in ${delay.inSeconds} seconds (attempt $_nativeRetryAttempt of $_maxRetryAttempts)');
              
              Future.delayed(
                delay,
                () {
                  if (mounted) {
                    debugPrint('Retrying native ad load (attempt $_nativeRetryAttempt)');
                    initNativeAd();
                  }
                },
              );
            } else {
              debugPrint('Maximum native ad retry attempts reached ($_maxRetryAttempts). Giving up.');
            }
          },
        ),
        request: const AdRequest(),
        // Use the factory ID we registered in MainActivity
        factoryId: 'listTile',
      );

      newNativeAd.load().onError((error, stackTrace) {
        debugPrint('Native ad failed to load: $error');
        debugPrint('Stack trace: $stackTrace');
        return false;
      });
    } catch (e) {
      debugPrint('Error initializing native ad: $e');
      if (!mounted) return;
      state = state.copyWith(isNativeAdLoaded: false);
      
      try {
        newNativeAd?.dispose();
      } catch (disposeError) {
        debugPrint('Error disposing native ad after initialization error: $disposeError');
      }
      
      // Retry with exponential backoff even for initialization errors
      if (_nativeRetryAttempt < _maxRetryAttempts) {
        _nativeRetryAttempt++;
        final delay = Duration(seconds: _nativeRetryAttempt * 5);
        debugPrint('Will retry native ad initialization in ${delay.inSeconds} seconds (attempt $_nativeRetryAttempt of $_maxRetryAttempts)');
        
        Future.delayed(
          delay,
          () {
            if (mounted) {
              debugPrint('Retrying native ad initialization (attempt $_nativeRetryAttempt)');
              initNativeAd();
            }
          },
        );
      } else {
        debugPrint('Maximum native ad retry attempts reached ($_maxRetryAttempts). Giving up.');
      }
    }
  }

  void initInterstitialAd() {
    // If interstitial ad is already loaded, don't request a new one
    if (state.isInterstitialAdLoaded && state.interstitialAd != null) {
      debugPrint('Interstitial ad already loaded. No need to request a new one.');
      return;
    }
    
    // Check if we're within the cooldown period
    final now = DateTime.now();
    if (state.lastInterstitialAdRequestTime != null) {
      final timeSinceLastRequest = now.difference(state.lastInterstitialAdRequestTime!);
      if (timeSinceLastRequest < _interstitialAdCooldown) {
        debugPrint('Interstitial ad request cooldown in effect. Try again in ${(_interstitialAdCooldown - timeSinceLastRequest).inSeconds} seconds.');
        return;
      }
    }
    
    // Update last request time
    state = state.copyWith(lastInterstitialAdRequestTime: now);
    
    final adUnitId = _interstitialAdUnitId;
    debugPrint('Loading interstitial ad with ID: $adUnitId');
    
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('Interstitial ad loaded successfully');
          
          // Set up full-screen callbacks
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) {
              debugPrint('Interstitial ad showed full screen content');
            },
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              debugPrint('Interstitial ad dismissed full screen content');
              
              // Dispose the ad when it's dismissed
              ad.dispose();
              
              if (!mounted) return;
              
              // Update state to reflect that the interstitial ad is no longer loaded
              state = state.copyWith(
                isInterstitialAdLoaded: false,
                interstitialAd: null,
              );
              
              // Pre-load the next interstitial ad
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  initInterstitialAd();
                }
              });
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              debugPrint('Interstitial ad failed to show full screen content: ${error.message}');
              debugPrint('Error code: ${error.code}, domain: ${error.domain}');
              
              // Dispose the ad on failure
              ad.dispose();
              
              if (!mounted) return;
              
              // Update state to reflect that the interstitial ad is no longer loaded
              state = state.copyWith(
                isInterstitialAdLoaded: false,
                interstitialAd: null,
              );
              
              // Retry loading the interstitial ad
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  initInterstitialAd();
                }
              });
            },
            onAdImpression: (InterstitialAd ad) {
              debugPrint('Interstitial ad impression recorded');
            },
          );
          
          if (!mounted) {
            ad.dispose();
            return;
          }
          
          // Update state to reflect that the interstitial ad is loaded
          state = state.copyWith(
            isInterstitialAdLoaded: true,
            interstitialAd: ad,
          );
          
          _interstitialRetryAttempt = 0; // Reset retry counter on success
        },
        onAdFailedToLoad: (LoadAdError error) {
          // Enhanced logging with detailed error information
          debugPrint('Interstitial ad failed to load: ${error.message}');
          debugPrint('Error details - Code: ${error.code}, Domain: ${error.domain}');
          debugPrint('Response info: ${error.responseInfo?.toString()}');
          debugPrint('Mediation adapter class name: ${error.responseInfo?.mediationAdapterClassName}');
          
          if (error.code == 3) {
            debugPrint('Error code 3 suggests no fill or network connectivity issues');
          } else if (error.code == 0) {
            debugPrint('Error code 0 suggests an internal error');
          } else if (error.code == 1) {
            debugPrint('Error code 1 suggests invalid request - check ad unit ID format');
            debugPrint('Current ad unit ID: $adUnitId');
          }
          
          if (!mounted) return;
          
          // Implement retry logic with exponential backoff
          if (_interstitialRetryAttempt < _maxRetryAttempts) {
            _interstitialRetryAttempt++;
            final delay = Duration(seconds: _interstitialRetryAttempt * 5);
            debugPrint('Will retry interstitial ad in ${delay.inSeconds} seconds (attempt $_interstitialRetryAttempt of $_maxRetryAttempts)');
            
            Future.delayed(
              delay,
              () {
                if (mounted) {
                  debugPrint('Retrying interstitial ad load (attempt $_interstitialRetryAttempt)');
                  initInterstitialAd();
                }
              },
            );
          } else {
            debugPrint('Maximum interstitial ad retry attempts reached ($_maxRetryAttempts). Giving up.');
          }
        },
      ),
    );
  }

  // Show interstitial ad if loaded
  Future<bool> showInterstitialAd() async {
    if (!state.isInterstitialAdLoaded || state.interstitialAd == null) {
      debugPrint('Interstitial ad not loaded, cannot show');
      ensureInterstitialAdLoaded();
      return false;
    }
    
    debugPrint('Showing interstitial ad');
    try {
      await state.interstitialAd!.show();
      return true;
    } catch (e) {
      debugPrint('Error showing interstitial ad: $e');
      
      // Handle error by disposing the ad and loading a new one
      try {
        state.interstitialAd!.dispose();
      } catch (disposeError) {
        debugPrint('Error disposing interstitial ad after show error: $disposeError');
      }
      
      if (mounted) {
        state = state.copyWith(
          isInterstitialAdLoaded: false,
          interstitialAd: null,
        );
        
        // Try to load a new interstitial ad
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            initInterstitialAd();
          }
        });
      }
      
      return false;
    }
  }

  // Dispose interstitial ad
  void disposeInterstitialAd() {
    if (!mounted) {
      debugPrint('AdsService not mounted, skipping interstitial ad disposal');
      return;
    }
    
    try {
      final currentAd = state.interstitialAd;
      if (currentAd != null) {
        debugPrint('Disposing interstitial ad');
        currentAd.dispose();
        debugPrint('Interstitial ad disposed successfully');
      } else {
        debugPrint('No interstitial ad to dispose');
      }
    } catch (e) {
      debugPrint('Error disposing interstitial ad: $e');
    } finally {
      if (mounted) {
        state = state.copyWith(
          isInterstitialAdLoaded: false,
          interstitialAd: null,
        );
        debugPrint('Interstitial ad state reset');
      }
      _interstitialRetryAttempt = 0;
    }
  }

  // Only call this when the app is being closed or when you need to completely reset ads
  void disposeBannerAd() {
    if (!mounted) {
      debugPrint('AdsService not mounted, skipping banner ad disposal');
      return;
    }
     
    try {
      final currentAd = state.bannerAd;
      if (currentAd != null) {
        debugPrint('Disposing banner ad');
        currentAd.dispose();
        debugPrint('Banner ad disposed successfully');
      } else {
        debugPrint('No banner ad to dispose');
      }
    } catch (e) {
      debugPrint('Error disposing banner ad: $e');
    } finally {
      if (mounted) { // Only update state if still mounted
        state = state.copyWith(
          isBannerAdLoaded: false,
          bannerAd: null,
        );
        debugPrint('Banner ad state reset');
      }
      _bannerRetryAttempt = 0;
    }
  }

  // Only call this when the app is being closed or when you need to completely reset ads
  void disposeNativeAd() {
    if (!mounted) {
      debugPrint('AdsService not mounted, skipping native ad disposal');
      return;
    }
    
    try {
      final currentAd = state.nativeAd;
      if (currentAd != null) {
        debugPrint('Disposing native ad');
        currentAd.dispose();
        debugPrint('Native ad disposed successfully');
      } else {
        debugPrint('No native ad to dispose');
      }
    } catch (e) {
      debugPrint('Error disposing native ad: $e');
    } finally {
      if (mounted) {
        state = state.copyWith(
          isNativeAdLoaded: false,
          nativeAd: null,
        );
        debugPrint('Native ad state reset');
      }
      _nativeRetryAttempt = 0;
    }
  }

  // Only call this when the app is being closed or when you need to completely reset ads
  void disposeAllAds() {
    debugPrint('Disposing all ads');
    
    // Use a try-catch block to handle potential errors
    try {
      disposeBannerAd();
    } catch (e) {
      debugPrint('Error disposing banner ad: $e');
    }
    
    try {
      disposeNativeAd();
    } catch (e) {
      debugPrint('Error disposing native ad: $e');
    }
    
    try {
      disposeInterstitialAd();
    } catch (e) {
      debugPrint('Error disposing interstitial ad: $e');
    }
    
    debugPrint('All ads disposed');
  }
} 