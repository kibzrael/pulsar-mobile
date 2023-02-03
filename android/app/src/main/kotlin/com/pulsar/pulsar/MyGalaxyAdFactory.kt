package com.pulsar.pulsar

import android.content.Context
import android.graphics.Color
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MyGalaxyAdFactory(val context: Context, val dark: Boolean = false) :
    GoogleMobileAdsPlugin.NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.my_galaxy_ad, null) as NativeAdView

        with(nativeAdView) {
            val attributionViewSmall =
                findViewById<TextView>(R.id.my_galaxy_ad_attribution)


            val headlineView = findViewById<TextView>(R.id.my_galaxy_ad_headline)
            headlineView.text = nativeAd.headline?.trim()

            val bodyView = findViewById<TextView>(R.id.my_galaxy_ad_body)
            with(bodyView) {
                text = nativeAd.body
                visibility = if (nativeAd.body?.isNotEmpty() == true) View.VISIBLE else View.INVISIBLE
            }

            val iconView = findViewById<ImageView>(R.id.my_galaxy_ad_icon)
            val icon = nativeAd.icon
            if (icon != null) {
                attributionViewSmall.visibility = View.VISIBLE
                iconView.setImageDrawable(icon.drawable)
            } else {
                iconView.visibility = View.INVISIBLE
                headlineView.gravity = Gravity.CENTER
                bodyView.gravity = Gravity.CENTER
            }

            val background = findViewById<FrameLayout>(R.id.my_galaxy_ad_background)

            if (dark) {
                background.setBackgroundColor(Color.parseColor("#242424"))
                headlineView.setTextColor(Color.parseColor("#FFFFFF"))
                bodyView.setTextColor(Color.parseColor("#BDBDBD"))
            }

            this.headlineView = headlineView

            this.bodyView = bodyView

            this.iconView = iconView

            val actionText = nativeAd.callToAction
            val actionView = findViewById<Button>(R.id.my_galaxy_ad_action)

            if (actionText != null) {
                actionView.text = actionText
            } else {
                actionView.visibility = View.INVISIBLE
            }

            this.callToActionView = actionView


            val media = nativeAd.mediaContent
            val mediaView = findViewById<MediaView>(R.id.my_galaxy_ad_media)

            if (media != null) {
                mediaView.setMediaContent(media)
            } else {
                (mediaView.parent as ViewGroup).removeView(mediaView)
            }

            this.mediaView = mediaView

            setNativeAd(nativeAd)
        }

        return nativeAdView
    }
}