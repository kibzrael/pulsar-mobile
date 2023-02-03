import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/ad_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';

class MyGalaxyAd extends StatefulWidget {
  const MyGalaxyAd({Key? key}) : super(key: key);

  @override
  State<MyGalaxyAd> createState() => _MyGalaxyAdState();
}

class _MyGalaxyAdState extends State<MyGalaxyAd>
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
            factoryId: themeProvider.isDark ? 'myGalaxyDark' : 'myGalaxy',
            request: const AdRequest(
                // keywords: [],
                // extras: {'theme': 'dark'},
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
    return LayoutBuilder(builder: (context, constraints) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: SizedBox(
              width: constraints.maxWidth,
              height: 300,
              child: _isAdLoaded
                  ? AdWidget(ad: _ad)
                  : Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Text(
                          'Ad.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    )),
        ),
      );
    });
  }
}
