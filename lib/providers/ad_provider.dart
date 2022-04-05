import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider {
  Future<InitializationStatus> initialization;

  String get nativeAd => "ca-app-pub-3940256099942544/2247696110";

  String get listTileAd => 'ca-app-pub-9604738881391509/6843298268';

  String get myGalaxyAd => "ca-app-pub-9604738881391509/9846799070";

  String get discoverUsersAd => 'ca-app-pub-9604738881391509/6707566895';

  String get gridPostsAd => 'ca-app-pub-9604738881391509/6021079296';

  String get discoverChallengesAd => 'ca-app-pub-9604738881391509/9413529393';

  String get homePageAd => "ca-app-pub-9604738881391509/6219271601";

  String get inLineBannerAd => "ca-app-pub-9604738881391509/1940388894";

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
