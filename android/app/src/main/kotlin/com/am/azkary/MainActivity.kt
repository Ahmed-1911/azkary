package com.am.azkary

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.util.Log
import android.widget.Toast
import android.os.Bundle

class MainActivity: FlutterActivity() {
    private val WIDGET_CHANNEL = "com.am.azkary/widget"
    private val TAG = "MainActivity"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d(TAG, "MainActivity onCreate")
        
        // Force update widgets when app starts
        updateWidgets()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        Log.d(TAG, "Configuring Flutter Engine")
        
        // Widget update channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL).setMethodCallHandler { call, result ->
            Log.d(TAG, "Received method call: ${call.method}")
            
            if (call.method == "updateWidget") {
                val zikr = call.argument<String>("zikr")
                if (zikr != null) {
                    try {
                        // Save to SharedPreferences
                        val prefs = getSharedPreferences("com.am.azkary.AzkarWidget", 0)
                        
                        // Get all widget IDs
                        val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
                        val ids = appWidgetManager.getAppWidgetIds(
                            ComponentName(applicationContext, AzkarWidget::class.java)
                        )
                        
                        Log.d(TAG, "Found ${ids.size} widgets to update")
                        
                        if (ids.isEmpty()) {
                            // No widgets found, show a toast message
                            Toast.makeText(
                                this,
                                "No widgets found. Please add the Azkary widget to your home screen first.",
                                Toast.LENGTH_LONG
                            ).show()
                            Log.d(TAG, "No widgets found")
                        } else {
                            // Update all widgets
                            for (id in ids) {
                                prefs.edit().putString("zikr_$id", zikr).apply()
                                Log.d(TAG, "Updated SharedPreferences for widget ID: $id")
                            }
                            
                            // Send broadcast to update widgets
                            updateWidgets()
                            
                            Log.d(TAG, "Broadcast sent to update widgets")
                            Toast.makeText(this, "Widget updated successfully", Toast.LENGTH_SHORT).show()
                        }
                        
                        result.success(null)
                    } catch (e: Exception) {
                        Log.e(TAG, "Error updating widget", e)
                        result.error("UPDATE_ERROR", "Error updating widget: ${e.message}", null)
                    }
                } else {
                    Log.e(TAG, "Zikr is null")
                    result.error("INVALID_ZIKR", "Zikr cannot be null", null)
                }
            } else {
                Log.e(TAG, "Method not implemented: ${call.method}")
                result.notImplemented()
            }
        }
    }
    
    private fun updateWidgets() {
        try {
            val appWidgetManager = AppWidgetManager.getInstance(applicationContext)
            val ids = appWidgetManager.getAppWidgetIds(
                ComponentName(applicationContext, AzkarWidget::class.java)
            )
            
            if (ids.isNotEmpty()) {
                // Send broadcast to update widgets
                val intent = Intent(this, AzkarWidget::class.java)
                intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
                intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                sendBroadcast(intent)
                Log.d(TAG, "Broadcast sent to update ${ids.size} widgets")
            }
        } catch (e: Exception) {
            Log.e(TAG, "Error updating widgets: ${e.message}")
        }
    }
} 