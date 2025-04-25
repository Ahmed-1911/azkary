package com.am.azkary

import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.ImageView
import android.widget.Button
import android.graphics.Color
import android.util.TypedValue
import android.view.Gravity
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class ListTileNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        // Create the Native Ad View
        val nativeAdView = NativeAdView(context)
        nativeAdView.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        
        // Create main container
        val mainContainer = LinearLayout(context)
        mainContainer.orientation = LinearLayout.VERTICAL
        mainContainer.layoutParams = ViewGroup.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT
        )
        mainContainer.setPadding(16, 16, 16, 16)
        mainContainer.setBackgroundColor(Color.WHITE)
        
        // Create a horizontal layout for icon and headline
        val headerLayout = LinearLayout(context)
        headerLayout.orientation = LinearLayout.HORIZONTAL
        headerLayout.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )
        
        // Ad Icon
        val iconView = ImageView(context)
        val iconParams = LinearLayout.LayoutParams(
            64, // width in pixels
            64  // height in pixels
        )
        iconParams.marginEnd = 16 // right margin
        iconView.layoutParams = iconParams
        iconView.scaleType = ImageView.ScaleType.FIT_CENTER
        headerLayout.addView(iconView)
        
        // Vertical layout for headline and ad indicator
        val textContainer = LinearLayout(context)
        textContainer.orientation = LinearLayout.VERTICAL
        textContainer.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )
        
        // Create ad indicator label
        val adIndicator = TextView(context)
        val adIndicatorParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.WRAP_CONTENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )
        adIndicator.layoutParams = adIndicatorParams
        adIndicator.text = "Ad"
        adIndicator.setTextSize(TypedValue.COMPLEX_UNIT_SP, 10f)
        adIndicator.setTextColor(Color.WHITE)
        adIndicator.setPadding(8, 2, 8, 2)
        adIndicator.background = android.graphics.drawable.GradientDrawable().apply {
            setColor(Color.parseColor("#4285F4")) // Google blue
            cornerRadius = 4f
        }
        textContainer.addView(adIndicator)
        
        // Add some spacing
        val spacer1 = View(context)
        spacer1.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            4
        )
        textContainer.addView(spacer1)
        
        // Create headline
        val headlineView = TextView(context)
        headlineView.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )
        headlineView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
        headlineView.setTextColor(Color.BLACK)
        headlineView.maxLines = 2
        headlineView.ellipsize = android.text.TextUtils.TruncateAt.END
        textContainer.addView(headlineView)
        
        // Add the text container to the header layout
        headerLayout.addView(textContainer)
        
        // Add the header layout to the main container
        mainContainer.addView(headerLayout)
        
        // Add spacing after header
        val spacer2 = View(context)
        spacer2.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            8
        )
        mainContainer.addView(spacer2)
        
        // Create body text
        val bodyView = TextView(context)
        bodyView.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )
        bodyView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
        bodyView.setTextColor(Color.GRAY)
        bodyView.maxLines = 2
        bodyView.ellipsize = android.text.TextUtils.TruncateAt.END
        mainContainer.addView(bodyView)
        
        // Add spacing before button
        val spacer3 = View(context)
        spacer3.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            12
        )
        mainContainer.addView(spacer3)
        
        // Create call to action button
        val callToActionView = Button(context)
        callToActionView.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.WRAP_CONTENT,
            LinearLayout.LayoutParams.WRAP_CONTENT
        )
        callToActionView.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
        callToActionView.setTextColor(Color.WHITE)
        callToActionView.setPadding(16, 8, 16, 8)
        callToActionView.isAllCaps = false
        callToActionView.background = android.graphics.drawable.GradientDrawable().apply {
            setColor(Color.parseColor("#4285F4")) // Google blue
            cornerRadius = 4f
        }
        mainContainer.addView(callToActionView)
        
        // Add the main container to the native ad view
        nativeAdView.addView(mainContainer)
        
        // Register ad asset views
        nativeAdView.headlineView = headlineView
        nativeAdView.bodyView = bodyView
        nativeAdView.callToActionView = callToActionView
        nativeAdView.iconView = iconView
        
        // Populate the views with ad content
        if (nativeAd.headline != null) {
            headlineView.text = nativeAd.headline
        } else {
            headlineView.visibility = View.GONE
        }
        
        if (nativeAd.body != null) {
            bodyView.text = nativeAd.body
        } else {
            bodyView.visibility = View.GONE
        }
        
        if (nativeAd.callToAction != null) {
            callToActionView.text = nativeAd.callToAction
        } else {
            callToActionView.visibility = View.GONE
        }
        
        if (nativeAd.icon != null && nativeAd.icon?.drawable != null) {
            iconView.setImageDrawable(nativeAd.icon?.drawable)
            iconView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
        }
        
        // Set the native ad on the view
        nativeAdView.setNativeAd(nativeAd)
        
        return nativeAdView
    }
} 