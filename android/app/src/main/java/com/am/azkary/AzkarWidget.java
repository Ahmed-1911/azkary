package com.am.azkary;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.widget.RemoteViews;
import android.app.AlarmManager;
import android.util.Log;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Random;

public class AzkarWidget extends AppWidgetProvider {
    private static final String TAG = "AzkarWidget";
    private static final String UPDATE_ACTION = "UPDATE_AZKAR_WIDGET";
    private static final String REFRESH_ACTION = "com.am.azkary.REFRESH_WIDGET";
    private static final String PREFS_NAME = "com.am.azkary.AzkarWidget";
    private static final String PREF_ZIKR_KEY = "zikr_";
    private static final String PREF_LAST_UPDATED_KEY = "last_updated_";
    
    // Array of common Azkar to display in the widget
    private static final String[] COMMON_AZKAR = {
        "سُبْحَانَ اللهِ وَبِحَمْدِهِ",
        "لا إله إلا الله وحده لا شريك له",
        "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
        "أستغفر الله العظيم",
        "سبحان الله والحمد لله ولا إله إلا الله والله أكبر",
        "سُبْحَانَ اللَّهِ العَظِيمِ وَبِحَمْدِهِ",
        "لا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ",
        "اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي",
        "الحَمْدُ لِلَّهِ رَبِّ العَالَمِينَ",
        "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ",
        "رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ",
        "حَسْبِيَ اللَّهُ لا إِلَهَ إِلا هُوَ عَلَيْهِ تَوَكَّلْتُ",
        "اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ",
        "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
        "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ الْهَمِّ وَالْحَزَنِ",
        "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
        "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى",
        "سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَاللَّهُ أَكْبَرُ",
        "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ",
        "اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ",
        "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ",
        "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ",
        "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ سُبْحَانَ اللَّهِ الْعَظِيمِ",
        "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا"
    };
    
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        try {
            // Get a random Zikr
            String randomZikr = getRandomZikr();
            
            // Update all widgets
            for (int appWidgetId : appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId, randomZikr);
            }
            
            // Schedule next update in 10 seconds
            scheduleNextUpdate(context);
        } catch (Exception e) {
            Log.e(TAG, "Error in onUpdate: " + e.getMessage());
        }
    }
    
    private void scheduleNextUpdate(Context context) {
        try {
            // Create intent for update
            Intent intent = new Intent(context, AzkarWidget.class);
            intent.setAction(UPDATE_ACTION);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(
                context, 
                0, 
                intent, 
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
            );
            
            // Get alarm manager
            AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
            
            // Schedule next update in 10 seconds
            long triggerTime = System.currentTimeMillis() + 10000; // 10 seconds
            
            // Set alarm
            if (alarmManager != null) {
                alarmManager.setExact(AlarmManager.RTC, triggerTime, pendingIntent);
                Log.d(TAG, "Next update scheduled for 10 seconds from now");
            }
        } catch (Exception e) {
            Log.e(TAG, "Error scheduling next update: " + e.getMessage());
        }
    }
    
    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            super.onReceive(context, intent);
            
            String action = intent.getAction();
            if (AppWidgetManager.ACTION_APPWIDGET_UPDATE.equals(action) || 
                REFRESH_ACTION.equals(action) || 
                UPDATE_ACTION.equals(action)) {
                
                // Get widget IDs
                AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
                int[] appWidgetIds = appWidgetManager.getAppWidgetIds(
                    new ComponentName(context, AzkarWidget.class));
                
                // Get a random Zikr
                String randomZikr = getRandomZikr();
                
                // Update all widgets
                for (int appWidgetId : appWidgetIds) {
                    updateAppWidget(context, appWidgetManager, appWidgetId, randomZikr);
                }
                
                // If this is from our scheduled update, schedule the next one
                if (UPDATE_ACTION.equals(action)) {
                    scheduleNextUpdate(context);
                }
            }
        } catch (Exception e) {
            Log.e(TAG, "Error in onReceive: " + e.getMessage());
        }
    }
    
    /**
     * Get a random Zikr from the predefined list
     */
    private String getRandomZikr() {
        try {
            Random random = new Random();
            int index = random.nextInt(COMMON_AZKAR.length);
            return COMMON_AZKAR[index];
        } catch (Exception e) {
            Log.e(TAG, "Error getting random zikr: " + e.getMessage());
            return "سبحان الله وبحمده";
        }
    }
    
    /**
     * Update a specific widget with the given Zikr
     */
    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager, int appWidgetId, String zikr) {
        try {
            // Use default if zikr is null
            if (zikr == null || zikr.isEmpty()) {
                zikr = "سبحان الله وبحمده";
            }
            
            // Create RemoteViews
            RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.azkar_widget);
            
            // Set text
            views.setTextViewText(R.id.widget_zikr_text, zikr);
            
            // Set click intent for widget content
            Intent mainIntent = new Intent(context, MainActivity.class);
            PendingIntent mainPendingIntent = PendingIntent.getActivity(
                context, 
                0, 
                mainIntent, 
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
            );
            views.setOnClickPendingIntent(R.id.widget_zikr_text, mainPendingIntent);
            
            // Set refresh button click intent
            Intent refreshIntent = new Intent(context, AzkarWidget.class);
            refreshIntent.setAction(REFRESH_ACTION);
            PendingIntent refreshPendingIntent = PendingIntent.getBroadcast(
                context,
                0,
                refreshIntent,
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
            );
            views.setOnClickPendingIntent(R.id.refresh_button, refreshPendingIntent);
            
            // Update widget
            appWidgetManager.updateAppWidget(appWidgetId, views);
            
            // Log update time
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
            String currentTime = sdf.format(new Date());
            Log.d(TAG, "Widget updated at " + currentTime + " with zikr: " + zikr);
        } catch (Exception e) {
            Log.e(TAG, "Error updating widget: " + e.getMessage());
        }
    }
    
    @Override
    public void onEnabled(Context context) {
        super.onEnabled(context);
        try {
            // Schedule first update
            scheduleNextUpdate(context);
            Log.d(TAG, "Widget enabled, scheduled first update");
        } catch (Exception e) {
            Log.e(TAG, "Error in onEnabled: " + e.getMessage());
        }
    }
    
    @Override
    public void onDisabled(Context context) {
        super.onDisabled(context);
        try {
            // Cancel pending updates
            Intent intent = new Intent(context, AzkarWidget.class);
            intent.setAction(UPDATE_ACTION);
            PendingIntent pendingIntent = PendingIntent.getBroadcast(
                context, 
                0, 
                intent, 
                PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE
            );
            
            AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
            if (alarmManager != null) {
                alarmManager.cancel(pendingIntent);
                Log.d(TAG, "Widget disabled, canceled updates");
            }
        } catch (Exception e) {
            Log.e(TAG, "Error in onDisabled: " + e.getMessage());
        }
    }
    
    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
        // Called when widgets are deleted
        try {
            super.onDeleted(context, appWidgetIds);
            Log.d(TAG, "onDeleted called");
            
            // Clean up SharedPreferences for deleted widgets
            SharedPreferences prefs = context.getSharedPreferences(PREFS_NAME, 0);
            SharedPreferences.Editor editor = prefs.edit();
            
            for (int appWidgetId : appWidgetIds) {
                editor.remove(PREF_ZIKR_KEY + appWidgetId);
                editor.remove(PREF_LAST_UPDATED_KEY + appWidgetId);
            }
            
            editor.apply();
        } catch (Exception e) {
            Log.e(TAG, "Error in onDeleted: " + e.getMessage());
        }
    }
} 