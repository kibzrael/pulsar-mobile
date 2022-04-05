package com.pulsar.pulsar

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // TODO: Register the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "listTile", ListTileNativeAdFactory(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "grid", GridAdFactory(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "discoverChallenges", DiscoverChallengesAdFactory(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine, "myGalaxy", MyGalaxyAdFactory(context)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

        // TODO: Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "grid")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "discoverChallenges")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "myGalaxy")
    }
}
