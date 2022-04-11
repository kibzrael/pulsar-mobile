package com.pulsar.pulsar

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // TODO: Register the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "listTile", ListTileNativeAdFactory(context, dark=false)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "listTileDark", ListTileNativeAdFactory(context, dark=true)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "grid", GridAdFactory(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "discoverChallenges", DiscoverChallengesAdFactory(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "discoverChallengesDark", DiscoverChallengesAdFactory(context, dark=true)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "myGalaxy", MyGalaxyAdFactory(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "myGalaxyDark", MyGalaxyAdFactory(context, dark= true)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // TODO: Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTileDark")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "grid")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "discoverChallenges")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "discoverChallengesDark")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "myGalaxy")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "myGalaxyDark")
    }
}
