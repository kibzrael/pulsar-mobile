import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider {
  Future<InitializationStatus> initialization;

  String get listTileAd => 'ca-app-pub-3940256099942544/2247696110';

  String get naviveAd => "ca-app-pub-3940256099942544/2247696110";

  AdProvider(this.initialization);

  BannerAdListener get bannerAdListener => _bannerAdListener;

  final BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) {
      debugPrint('Ad Loaded');
    },
    onAdClosed: (ad) {
      debugPrint('Ad Closed');
    },
    onAdFailedToLoad: (ad, error) {
      debugPrint('Ad Failed');
    },
    onAdOpened: (ad) {
      debugPrint('Ad Opened');
    },
    onAdImpression: (ad) {
      debugPrint('Ad Impression');
    },
    onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
    onAdWillDismissScreen: (ad) {},
  );
}
