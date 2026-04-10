package com.yoshi.rain

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Build
import android.widget.RemoteViews
import androidx.core.util.SizeFCompat
import androidx.core.widget.updateAppWidget
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Implementation of App Widget functionality.
 */
class OreoWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { appWidgetId ->
            val supportedSizes = listOf(
                SizeFCompat(50.0f, 0.0f),
                SizeFCompat(100.0f, 0.0f),
                SizeFCompat(250.0f, 0.0f),
                SizeFCompat(300.0f, 0.0f),
            )
            appWidgetManager.updateAppWidget(appWidgetId, supportedSizes) { size ->
                val layoutId = when (size) {
                    supportedSizes[0] -> R.layout.oreo_widget_mini
                    supportedSizes[1] -> R.layout.oreo_widget_small
                    supportedSizes[2] -> R.layout.oreo_widget_medium
                    else -> R.layout.oreo_widget_big
                }
                RemoteViews(context.packageName, layoutId).apply {
                    val pendingIntentFlags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    } else {
                        PendingIntent.FLAG_UPDATE_CURRENT
                    }
                    val pendingIntent = PendingIntent.getActivity(
                        context,
                        0,
                        Intent(context, MainActivity::class.java),
                        pendingIntentFlags
                    )
                    setOnClickPendingIntent(R.id.widget_day_oreo, pendingIntent)

                    val image = widgetData.getString("weather_icon", null)
                    if (!image.isNullOrEmpty()) {
                        val bitmap = BitmapFactory.decodeFile(image)
                        if (bitmap != null) {
                            setImageViewBitmap(R.id.widget_day_icon, bitmap)
                        }
                    }

                    val degree = widgetData.getString("weather_degree", null)
                    setTextViewText(R.id.widget_day_title, degree ?: "--°")

                    val backgroundColor = widgetData.getString("background_color", null)
                    if (!backgroundColor.isNullOrEmpty()) {
                        try {
                            setInt(R.id.widget_day_oreo, "setBackgroundColor", Color.parseColor(backgroundColor))
                        } catch (e: IllegalArgumentException) {
                            // Use default theme color
                        }
                    }

                    val textColor = widgetData.getString("text_color", null)
                    if (!textColor.isNullOrEmpty()) {
                        try {
                            setTextColor(R.id.widget_day_title, Color.parseColor(textColor))
                            setTextColor(R.id.widget_day_time, Color.parseColor(textColor))
                        } catch (e: IllegalArgumentException) {
                            // Use default theme color
                        }
                    }
                }
            }
        }
    }
}
