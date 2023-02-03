import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/ad_provider.dart';
import 'package:pulsar/providers/theme_provider.dart';

class ListTileAd extends StatefulWidget {
  final bool dark;
  const ListTileAd({Key? key, this.dark = false}) : super(key: key);

  @override
  State<ListTileAd> createState() => _ListTileAdState();
}

class _ListTileAdState extends State<ListTileAd>
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
            factoryId: widget.dark || themeProvider.isDark
                ? 'listTileDark'
                : 'listTile',
            request: const AdRequest(),
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
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 72,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _isAdLoaded
                ? AdWidget(ad: _ad)
                : Text(
                    'Ad.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
          ),
        ));
  }
}
