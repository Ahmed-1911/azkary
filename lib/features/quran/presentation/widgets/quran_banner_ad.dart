import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:azkary/core/services/ads_service.dart';

class QuranBannerAd extends StatelessWidget {
  final bool isFullScreen;
  final AdsState adsService;
  // Standard height of the bottom navigation bar - this ensures consistent UI
  final double navBarHeight = 56.0;

  const QuranBannerAd({
    Key? key,
    required this.isFullScreen,
    required this.adsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Always return a Positioned widget to maintain consistent layout
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: navBarHeight,
        // Only show decoration and content in fullscreen mode
        decoration: isFullScreen 
          ? BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            )
          : null,
        child: isFullScreen && adsService.isNativeAdLoaded && adsService.nativeAd != null
            ? AdWidget(ad: adsService.nativeAd!)
            : const SizedBox.shrink(),
      ),
    );
  }
} 