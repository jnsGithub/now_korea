import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// This example demonstrates inline adaptive banner ads.
///
/// Loads and shows an inline adaptive banner ad in a scrolling view,
/// and reloads the ad when the orientation changes.
class YoutubeBoxBanner extends StatefulWidget {
  const YoutubeBoxBanner({super.key});

  @override
  InlineAdaptiveState createState() => InlineAdaptiveState();
}

class InlineAdaptiveState extends State<YoutubeBoxBanner> {
  Map<String, String> UNIT_ID = kReleaseMode
      ? {
    'ios': 'ca-app-pub-6941395151791292/3484164105',
    'android': 'ca-app-pub-6941395151791292/9834105569',
  }
      : {
    'ios': '/6499/example/native',
    'android': 'ca-app-pub-3940256099942544/6300978111',
  };
  late NativeAd nativeAd;
  bool _nativeAdIsLoaded = false;
  void loadAd() {
    TargetPlatform os = Theme.of(context).platform;
    nativeAd = NativeAd(
        adUnitId:  UNIT_ID[os == TargetPlatform.iOS ? 'ios' : 'android']!,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            debugPrint('$NativeAd loaded.');
            setState(() {
              _nativeAdIsLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            // Dispose the ad here to free resources.
            debugPrint('$NativeAd failed to load: $error');
            ad.dispose();
          },
        ),
        request: const AdManagerAdRequest(),
        // Styling
        nativeTemplateStyle: NativeTemplateStyle(
          // Required: Choose a template.
            templateType: TemplateType.medium,
            // Optional: Customize the ad's style.
            mainBackgroundColor: Colors.purple,
            cornerRadius: 10.0,
            callToActionTextStyle: NativeTemplateTextStyle(
                textColor: Colors.cyan,
                backgroundColor: Colors.red,
                style: NativeTemplateFontStyle.monospace,
                size: 16.0),
            primaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.red,
                backgroundColor: Colors.cyan,
                style: NativeTemplateFontStyle.italic,
                size: 16.0),
            secondaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.green,
                backgroundColor: Colors.black,
                style: NativeTemplateFontStyle.bold,
                size: 16.0),
            tertiaryTextStyle: NativeTemplateTextStyle(
                textColor: Colors.brown,
                backgroundColor: Colors.amber,
                style: NativeTemplateFontStyle.normal,
                size: 16.0)))
      ..load();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadAd();
  }
  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_nativeAdIsLoaded) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 320, // minimum recommended width
              minHeight: 320, // minimum recommended height
              maxWidth: 400,
              maxHeight: 400,
            ),
            child: AdWidget(ad: nativeAd),
          );
        }
        // Reload the ad if the orientation changes.
        return Container();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return _getAdWidget();
  }

  @override
  void dispose() {
    super.dispose();
    nativeAd.dispose();
  }
}
