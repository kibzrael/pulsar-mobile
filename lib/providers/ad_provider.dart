import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider {
  Future<InitializationStatus> initialization;

  String get bannerAd => 'ca-app-pub-3940256099942544/6300978111';

  AdProvider(this.initialization);

  BannerAdListener get bannerAdListener => _bannerAdListener;

  BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) {
      print('Ad Loaded');
    },
    onAdClosed: (ad) {
      print('Ad Closed');
    },
    onAdFailedToLoad: (ad, error) {
      print('Ad Failed');
    },
    onAdOpened: (ad) {
      print('Ad Opened');
    },
    onAdImpression: (ad) {
      print('Ad Impression');
    },
    onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
    onAdWillDismissScreen: (ad) {},
  );
}
