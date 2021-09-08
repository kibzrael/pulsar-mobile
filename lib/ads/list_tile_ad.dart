import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/ad_provider.dart';

class ListTileAd extends StatefulWidget {
  @override
  _ListTileAdState createState() => _ListTileAdState();
}

class _ListTileAdState extends State<ListTileAd> {
  late AdProvider provider;

  late NativeAd _ad;

  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<AdProvider>(context);
    provider.initialization.then((value) {
      setState(() {
        _ad = NativeAd(
          adUnitId: provider.listTileAd,
          factoryId: 'listTile',
          request: AdRequest(),
          listener: NativeAdListener(
            onAdLoaded: (_) {
              setState(() {
                _isAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {
              // Releases an ad resource when it fails to load
              ad.dispose();

              print(
                  'Ad load failed (code=${error.code} message=${error.message})');
            },
          ),
        )..load();
      });
    });
  }

  @override
  void dispose() {
    _ad.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 8),
        height: 72,
        color: Theme.of(context).colorScheme.surface,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: _isAdLoaded
                ? AdWidget(ad: _ad)
                : Text(
                    'Ad.',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
          ),
        ));
  }
}
