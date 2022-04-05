package com.pulsar.pulsar

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class DiscoverChallengesAdFactory(val context: Context) : GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.discover_challenges_ad, null) as NativeAdView

        with(nativeAdView) {
            val attributionViewSmall =
                findViewById<TextView>(R.id.discover_challenges_ad_attribution)


            val iconView = findViewById<ImageView>(R.id.discover_challenges_ad_icon)
            val icon = nativeAd.icon
            if (icon != null) {
                attributionViewSmall.visibility = View.VISIBLE
                iconView.setImageDrawable(icon.drawable)
            } else {
                attributionViewSmall.visibility = View.INVISIBLE
                iconView.visibility = View.INVISIBLE
            }

            val headlineView = findViewById<TextView>(R.id.discover_challenges_ad_headline)
            headlineView.text = nativeAd.headline.trim()

            this.headlineView = headlineView

            val bodyView = findViewById<TextView>(R.id.discover_challenges_ad_body)
            with(bodyView) {
                text = nativeAd.body
                visibility = if (nativeAd.body.isNotEmpty()) View.VISIBLE else View.INVISIBLE
            }
            this.bodyView = bodyView


            val media = nativeAd.mediaContent
            val mediaView = findViewById<MediaView>(R.id.discover_challenges_ad_media)

            if (media != null) {
                mediaView.setMediaContent(media)
                iconView.visibility = View.INVISIBLE
            } else {
                mediaView.visibility = View.INVISIBLE
            }
            this.iconView = iconView

            this.mediaView = mediaView

            setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}