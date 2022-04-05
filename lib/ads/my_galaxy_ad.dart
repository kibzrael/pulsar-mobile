import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/ad_provider.dart';

class MyGalaxyAd extends StatefulWidget {
  const MyGalaxyAd({Key? key}) : super(key: key);

  @override
  _MyGalaxyAdState createState() => _MyGalaxyAdState();
}

class _MyGalaxyAdState extends State<MyGalaxyAd>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late AdProvider provider;

  late NativeAd _ad;

  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AdProvider>(context, listen: false);
    try {
      provider.initialization.then((value) {
        setState(() {
          _ad = NativeAd(
            adUnitId: provider.nativeAd,
            factoryId: 'myGalaxy',
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
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
          width: constraints.maxWidth,
          height: 300,
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: _isAdLoaded
              ? AdWidget(ad: _ad)
              : Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text(
                      'Ad.',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ));
    });
  }
}
