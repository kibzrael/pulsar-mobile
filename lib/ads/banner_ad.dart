import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:pulsar/providers/ad_provider.dart';

class MyBannerAd extends StatefulWidget {
  @override
  _MyBannerAdState createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AdProvider provider = Provider.of<AdProvider>(context);
    provider.initialization.then((value) {
      if (mounted)
        setState(() {
          banner = BannerAd(
              adUnitId: provider.bannerAd,
              size: AdSize(
                  width: MediaQuery.of(context).size.width.floor(), height: 60),
              listener: provider.bannerAdListener,
              request: AdRequest())
            ..load();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4),
      height: 60,
      color: Theme.of(context).cardColor,
      child: banner == null
          ? Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Text(
                  'Ad.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            )
          : AdWidget(ad: banner!),
    );
  }
}
