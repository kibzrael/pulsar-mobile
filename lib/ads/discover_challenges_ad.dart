import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/ad_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';

class DiscoverChallengesAd extends StatefulWidget {
  const DiscoverChallengesAd({Key? key}) : super(key: key);

  @override
  _DiscoverChallengesAdState createState() => _DiscoverChallengesAdState();
}

class _DiscoverChallengesAdState extends State<DiscoverChallengesAd>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late AdProvider provider;

  late ThemeProvider themeProvider;
  late bool isDark;

  late NativeAd _ad;

  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AdProvider>(context, listen: false);
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    isDark = themeProvider.isDark;
    initialize();
  }

  initialize() {
    try {
      provider.initialization.then((value) {
        setState(() {
          _ad = NativeAd(
            adUnitId: provider.nativeAd,
            factoryId: themeProvider.isDark
                ? 'discoverChallengesDark'
                : 'discoverChallenges',
            request: const AdRequest(
                // keywords: [],
                // nonPersonalizedAds: false,
                ),
            listener: NativeAdListener(
              onAdLoaded: (_) {
                setState(() {
                  _isAdLoaded = true;
                });
              },
              onAdFailedToLoad: (ad, error) {
                // Releases an ad resource when it fails to load
                ad.dispose();

                debugPrint(
                    'Ad load failed (code=${error.code} message=${error.message})');
              },
            ),
          )..load();
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void dispose() {
    _ad.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    themeProvider = Provider.of<ThemeProvider>(context);
    if (themeProvider.isDark != isDark) {
      initialize();
      isDark = themeProvider.isDark;
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 10),
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(12), bottom: Radius.circular(15))),
      child: SizedBox(
        width: 180,
        child: LayoutBuilder(builder: (context, constraints) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12), bottom: Radius.circular(15)),
            child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: _isAdLoaded
                    ? AdWidget(ad: _ad)
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Text(
                            'Ad.',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      )),
          );
        }),
      ),
    );
  }
}
