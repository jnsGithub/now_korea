import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// This example demonstrates inline adaptive banner ads.
///
/// Loads and shows an inline adaptive banner ad in a scrolling view,
/// and reloads the ad when the orientation changes.
class RankingBanner extends StatefulWidget {
  const RankingBanner({super.key});

  @override
  InlineAdaptiveState createState() => InlineAdaptiveState();
}

class InlineAdaptiveState extends State<RankingBanner> {
  Map<String, String> UNIT_ID = kReleaseMode
      ? {
    'ios': 'ca-app-pub-6941395151791292/8137994489',
    'android': 'ca-app-pub-6941395151791292/8447866116',
  }
      : {
    'ios': 'ca-app-pub-3940256099942544/4411468910',
    'android': 'ca-app-pub-3940256099942544/1033173712',
  };

  InterstitialAd? _interstitialAd;
  static const _insets = 16.0;
  double get _adWidth => MediaQuery.of(context).size.width - (2 * _insets);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  void _loadAd() async {
    TargetPlatform os = Theme.of(context).platform;
    await InterstitialAd.load(
        adUnitId: UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  // Dispose the ad here to free resources.
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {

                });

            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
    _interstitialAd?.show();
  }

  /// Gets a widget containing the ad, if one is loaded.
  ///
  /// Returns an empty container if no ad is loaded, or the orientation
  /// has changed. Also loads a new ad if the orientation changes.
  // Widget _getAdWidget() {
  //   return OrientationBuilder(
  //     builder: (context, orientation) {
  //       if (_currentOrientation == orientation &&
  //           _interstitialAd != null &&
  //           _isLoaded &&
  //           _adSize != null) {
  //         return Align(
  //             child: SizedBox(
  //               width: _adWidth,
  //               height: _adSize!.height.toDouble(),
  //               child: _interstitialAd?.show()
  //             ));
  //       }
  //       // Reload the ad if the orientation changes.
  //       if (_currentOrientation != orientation) {
  //         _currentOrientation = orientation;
  //         _loadAd();
  //       }
  //       return Container();
  //     },
  //   );
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return _getAdWidget();
  // }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
