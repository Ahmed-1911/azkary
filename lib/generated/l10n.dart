// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Azkar`
  String get azkar {
    return Intl.message(
      'Azkar',
      name: 'azkar',
      desc: 'Label for Azkar navigation item',
      args: [],
    );
  }

  /// `Tasbih`
  String get tasbih {
    return Intl.message(
      'Tasbih',
      name: 'tasbih',
      desc: 'Label for Tasbih navigation item',
      args: [],
    );
  }

  /// `Bookmarks`
  String get bookmarks {
    return Intl.message(
      'Bookmarks',
      name: 'bookmarks',
      desc: 'Label for Bookmarks navigation item',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: 'Label for Settings navigation item',
      args: [],
    );
  }

  /// `Tools`
  String get tools {
    return Intl.message(
      'Tools',
      name: 'tools',
      desc: 'Label for Tools section in settings',
      args: [],
    );
  }

  /// `No internet connection, please check you network and try again`
  String get no_internet_connection {
    return Intl.message(
      'No internet connection, please check you network and try again',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `No Available Data`
  String get no_data {
    return Intl.message(
      'No Available Data',
      name: 'no_data',
      desc: '',
      args: [],
    );
  }

  /// `No Available Orders Now!`
  String get no_order {
    return Intl.message(
      'No Available Orders Now!',
      name: 'no_order',
      desc: '',
      args: [],
    );
  }

  /// `Internal Server Error`
  String get internal_server_error {
    return Intl.message(
      'Internal Server Error',
      name: 'internal_server_error',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Log in`
  String get login {
    return Intl.message('Log in', name: 'login', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Welcome to Dawar`
  String get welcomeMessage {
    return Intl.message(
      'Welcome to Dawar',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add all the data first`
  String get addAllFieldsFirst {
    return Intl.message(
      'Add all the data first',
      name: 'addAllFieldsFirst',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is incorrect`
  String get phoneInvalid {
    return Intl.message(
      'Phone number is incorrect',
      name: 'phoneInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Password has entered successfully`
  String get passwordCompleted {
    return Intl.message(
      'Password has entered successfully',
      name: 'passwordCompleted',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Register with OTP`
  String get registerWithOtp {
    return Intl.message(
      'Register with OTP',
      name: 'registerWithOtp',
      desc: '',
      args: [],
    );
  }

  /// `OTP`
  String get otp {
    return Intl.message('OTP', name: 'otp', desc: '', args: []);
  }

  /// `Success...`
  String get success {
    return Intl.message('Success...', name: 'success', desc: '', args: []);
  }

  /// `Already registered`
  String get alreadyRegistered {
    return Intl.message(
      'Already registered',
      name: 'alreadyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message('Weight', name: 'weight', desc: '', args: []);
  }

  /// `KG`
  String get kg {
    return Intl.message('KG', name: 'kg', desc: '', args: []);
  }

  /// `Receive load`
  String get receiveLoad {
    return Intl.message(
      'Receive load',
      name: 'receiveLoad',
      desc: '',
      args: [],
    );
  }

  /// `Vehicle Loads`
  String get vehicleLoads {
    return Intl.message(
      'Vehicle Loads',
      name: 'vehicleLoads',
      desc: '',
      args: [],
    );
  }

  /// `Orders number`
  String get ordersNumber {
    return Intl.message(
      'Orders number',
      name: 'ordersNumber',
      desc: '',
      args: [],
    );
  }

  /// `Bags number`
  String get bagsNumber {
    return Intl.message('Bags number', name: 'bagsNumber', desc: '', args: []);
  }

  /// `Ticket No`
  String get ticketNo {
    return Intl.message('Ticket No', name: 'ticketNo', desc: '', args: []);
  }

  /// `Total previous weight from this material  `
  String get totalWeight {
    return Intl.message(
      'Total previous weight from this material  ',
      name: 'totalWeight',
      desc: '',
      args: [],
    );
  }

  /// `Choose Waste Type First`
  String get chooseWasteType {
    return Intl.message(
      'Choose Waste Type First',
      name: 'chooseWasteType',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Log Out`
  String get logOut {
    return Intl.message('Log Out', name: 'logOut', desc: '', args: []);
  }

  /// `Azkary`
  String get appName {
    return Intl.message(
      'Azkary',
      name: 'appName',
      desc: 'The name of the application',
      args: [],
    );
  }

  /// `Quran`
  String get quran {
    return Intl.message(
      'Quran',
      name: 'quran',
      desc: 'Label for Quran navigation item',
      args: [],
    );
  }

  /// `Morning Azkar`
  String get morningAzkar {
    return Intl.message(
      'Morning Azkar',
      name: 'morningAzkar',
      desc: 'Title for morning remembrance category',
      args: [],
    );
  }

  /// `أذكار الصباح`
  String get morningAzkarAr {
    return Intl.message(
      'أذكار الصباح',
      name: 'morningAzkarAr',
      desc: 'Arabic title for morning remembrance category',
      args: [],
    );
  }

  /// `Morning remembrance and supplications`
  String get morningAzkarDesc {
    return Intl.message(
      'Morning remembrance and supplications',
      name: 'morningAzkarDesc',
      desc: 'Description for morning azkar category',
      args: [],
    );
  }

  /// `Evening Azkar`
  String get eveningAzkar {
    return Intl.message(
      'Evening Azkar',
      name: 'eveningAzkar',
      desc: 'Title for evening remembrance category',
      args: [],
    );
  }

  /// `أذكار المساء`
  String get eveningAzkarAr {
    return Intl.message(
      'أذكار المساء',
      name: 'eveningAzkarAr',
      desc: 'Arabic title for evening remembrance category',
      args: [],
    );
  }

  /// `Evening remembrance and supplications`
  String get eveningAzkarDesc {
    return Intl.message(
      'Evening remembrance and supplications',
      name: 'eveningAzkarDesc',
      desc: 'Description for evening azkar category',
      args: [],
    );
  }

  /// `Sleep Azkar`
  String get sleepAzkar {
    return Intl.message(
      'Sleep Azkar',
      name: 'sleepAzkar',
      desc: 'Title for sleep remembrance category',
      args: [],
    );
  }

  /// `أذكار النوم`
  String get sleepAzkarAr {
    return Intl.message(
      'أذكار النوم',
      name: 'sleepAzkarAr',
      desc: 'Arabic title for sleep remembrance category',
      args: [],
    );
  }

  /// `Azkar before sleeping`
  String get sleepAzkarDesc {
    return Intl.message(
      'Azkar before sleeping',
      name: 'sleepAzkarDesc',
      desc: 'Description for sleep azkar category',
      args: [],
    );
  }

  /// `Wake Up Azkar`
  String get wakeupAzkar {
    return Intl.message(
      'Wake Up Azkar',
      name: 'wakeupAzkar',
      desc: 'Title for wake up remembrance category',
      args: [],
    );
  }

  /// `أذكار الاستيقاظ`
  String get wakeupAzkarAr {
    return Intl.message(
      'أذكار الاستيقاظ',
      name: 'wakeupAzkarAr',
      desc: 'Arabic title for wake up remembrance category',
      args: [],
    );
  }

  /// `Azkar after waking up`
  String get wakeupAzkarDesc {
    return Intl.message(
      'Azkar after waking up',
      name: 'wakeupAzkarDesc',
      desc: 'Description for wake up azkar category',
      args: [],
    );
  }

  /// `After Prayer`
  String get prayerAzkar {
    return Intl.message(
      'After Prayer',
      name: 'prayerAzkar',
      desc: 'Title for after prayer remembrance category',
      args: [],
    );
  }

  /// `أذكار بعد الصلاة`
  String get prayerAzkarAr {
    return Intl.message(
      'أذكار بعد الصلاة',
      name: 'prayerAzkarAr',
      desc: 'Arabic title for after prayer remembrance category',
      args: [],
    );
  }

  /// `Azkar after completing prayer`
  String get prayerAzkarDesc {
    return Intl.message(
      'Azkar after completing prayer',
      name: 'prayerAzkarDesc',
      desc: 'Description for after prayer azkar category',
      args: [],
    );
  }

  /// `Quranic Duas`
  String get quranicDuas {
    return Intl.message(
      'Quranic Duas',
      name: 'quranicDuas',
      desc: 'Title for Quranic supplications category',
      args: [],
    );
  }

  /// `أدعية قرآنية`
  String get quranicDuasAr {
    return Intl.message(
      'أدعية قرآنية',
      name: 'quranicDuasAr',
      desc: 'Arabic title for Quranic supplications category',
      args: [],
    );
  }

  /// `Supplications from the Holy Quran`
  String get quranicDuasDesc {
    return Intl.message(
      'Supplications from the Holy Quran',
      name: 'quranicDuasDesc',
      desc: 'Description for Quranic supplications category',
      args: [],
    );
  }

  /// `Azkar Categories`
  String get azkarCategories {
    return Intl.message(
      'Azkar Categories',
      name: 'azkarCategories',
      desc: 'Title for the categories screen',
      args: [],
    );
  }

  /// `Repeat {count} times`
  String repeatCount(int count) {
    return Intl.message(
      'Repeat $count times',
      name: 'repeatCount',
      desc: 'Text showing how many times to repeat the zikr',
      args: [count],
    );
  }

  /// `No bookmarks yet`
  String get noBookmarks {
    return Intl.message(
      'No bookmarks yet',
      name: 'noBookmarks',
      desc: 'Message shown when no bookmarks exist',
      args: [],
    );
  }

  /// `Add Azkar to your bookmarks\nto access them quickly`
  String get addBookmarksHint {
    return Intl.message(
      'Add Azkar to your bookmarks\nto access them quickly',
      name: 'addBookmarksHint',
      desc: 'Hint text shown when bookmarks list is empty',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: 'Title for appearance section in settings',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: 'Label for dark mode toggle',
      args: [],
    );
  }

  /// `Font Size`
  String get fontSize {
    return Intl.message(
      'Font Size',
      name: 'fontSize',
      desc: 'Label for font size slider',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: 'Title for notifications section in settings',
      args: [],
    );
  }

  /// `Morning Azkar Reminder`
  String get morningReminder {
    return Intl.message(
      'Morning Azkar Reminder',
      name: 'morningReminder',
      desc: 'Label for morning reminder toggle',
      args: [],
    );
  }

  /// `Daily reminder for morning azkar`
  String get morningReminderDesc {
    return Intl.message(
      'Daily reminder for morning azkar',
      name: 'morningReminderDesc',
      desc: 'Description for morning reminder setting',
      args: [],
    );
  }

  /// `Evening Azkar Reminder`
  String get eveningReminder {
    return Intl.message(
      'Evening Azkar Reminder',
      name: 'eveningReminder',
      desc: 'Label for evening reminder toggle',
      args: [],
    );
  }

  /// `Daily reminder for evening azkar`
  String get eveningReminderDesc {
    return Intl.message(
      'Daily reminder for evening azkar',
      name: 'eveningReminderDesc',
      desc: 'Description for evening reminder setting',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: 'Title for about section in settings',
      args: [],
    );
  }

  /// `Version`
  String get version {
    return Intl.message(
      'Version',
      name: 'version',
      desc: 'Label for app version',
      args: [],
    );
  }

  /// `Developer`
  String get developer {
    return Intl.message(
      'Developer',
      name: 'developer',
      desc: 'Label for developer info',
      args: [],
    );
  }

  /// `Permission Required`
  String get permissionRequired {
    return Intl.message(
      'Permission Required',
      name: 'permissionRequired',
      desc: 'Title for permission dialog',
      args: [],
    );
  }

  /// `Please enable notifications in system settings`
  String get notificationPermission {
    return Intl.message(
      'Please enable notifications in system settings',
      name: 'notificationPermission',
      desc: 'Message asking for notification permission',
      args: [],
    );
  }

  /// `This app needs permission to schedule exact alarms for Azkar reminders. Please grant this permission in system settings.`
  String get exactAlarmPermission {
    return Intl.message(
      'This app needs permission to schedule exact alarms for Azkar reminders. Please grant this permission in system settings.',
      name: 'exactAlarmPermission',
      desc: 'Message asking for exact alarm permission',
      args: [],
    );
  }

  /// `Settings`
  String get openSettings {
    return Intl.message(
      'Settings',
      name: 'openSettings',
      desc: 'Label for button to open settings',
      args: [],
    );
  }

  /// `Digital Tasbih`
  String get digitalTasbih {
    return Intl.message(
      'Digital Tasbih',
      name: 'digitalTasbih',
      desc: 'Title for tasbih screen',
      args: [],
    );
  }

  /// `Target: {count}`
  String target(int count) {
    return Intl.message(
      'Target: $count',
      name: 'target',
      desc: 'Label showing target count for tasbih',
      args: [count],
    );
  }

  /// `Names of Allah`
  String get namesOfAllah {
    return Intl.message(
      'Names of Allah',
      name: 'namesOfAllah',
      desc: 'Label for 99 names option',
      args: [],
    );
  }

  /// `Century`
  String get century {
    return Intl.message(
      'Century',
      name: 'century',
      desc: 'Label for 100 count option',
      args: [],
    );
  }

  /// `Morning Azkar Reminder`
  String get morningAzkarReminder {
    return Intl.message(
      'Morning Azkar Reminder',
      name: 'morningAzkarReminder',
      desc: 'Title for morning azkar reminder setting',
      args: [],
    );
  }

  /// `Evening Azkar Reminder`
  String get eveningAzkarReminder {
    return Intl.message(
      'Evening Azkar Reminder',
      name: 'eveningAzkarReminder',
      desc: 'Title for evening azkar reminder setting',
      args: [],
    );
  }

  /// `Daily reminder for morning azkar`
  String get dailyReminderForMorningAzkar {
    return Intl.message(
      'Daily reminder for morning azkar',
      name: 'dailyReminderForMorningAzkar',
      desc: 'Description for morning azkar reminder',
      args: [],
    );
  }

  /// `Daily reminder for evening azkar`
  String get dailyReminderForEveningAzkar {
    return Intl.message(
      'Daily reminder for evening azkar',
      name: 'dailyReminderForEveningAzkar',
      desc: 'Description for evening azkar reminder',
      args: [],
    );
  }

  /// `Time for your morning remembrance`
  String get timeForYourMorningRemembrance {
    return Intl.message(
      'Time for your morning remembrance',
      name: 'timeForYourMorningRemembrance',
      desc: 'Notification message for morning azkar',
      args: [],
    );
  }

  /// `Time for your evening remembrance`
  String get timeForYourEveningRemembrance {
    return Intl.message(
      'Time for your evening remembrance',
      name: 'timeForYourEveningRemembrance',
      desc: 'Notification message for evening azkar',
      args: [],
    );
  }

  /// `Repeat`
  String get repeat {
    return Intl.message(
      'Repeat',
      name: 'repeat',
      desc: 'Text for repeat count label',
      args: [],
    );
  }

  /// `times`
  String get times {
    return Intl.message(
      'times',
      name: 'times',
      desc: 'Text for number of times',
      args: [],
    );
  }

  /// `No audio available for this dhikr`
  String get noAudioAvailable {
    return Intl.message(
      'No audio available for this dhikr',
      name: 'noAudioAvailable',
      desc: 'Message shown when no audio is available for an Azkar',
      args: [],
    );
  }

  /// `Error playing audio: {error}`
  String errorPlayingAudio(String error) {
    return Intl.message(
      'Error playing audio: $error',
      name: 'errorPlayingAudio',
      desc: 'Message shown when there\'s an error playing audio',
      args: [error],
    );
  }

  /// `Audio feature coming soon!`
  String get audioComingSoon {
    return Intl.message(
      'Audio feature coming soon!',
      name: 'audioComingSoon',
      desc: 'Message shown when audio feature is not yet available',
      args: [],
    );
  }

  /// `{name}`
  String categoryName(String name) {
    return Intl.message(
      '$name',
      name: 'categoryName',
      desc: 'The name of a category',
      args: [name],
    );
  }

  /// `Add Widget to Home Screen`
  String get addWidgetToHomeScreen {
    return Intl.message(
      'Add Widget to Home Screen',
      name: 'addWidgetToHomeScreen',
      desc: 'Title for the widget info dialog',
      args: [],
    );
  }

  /// `Widget needed on home screen`
  String get widgetNeededOnHomeScreen {
    return Intl.message(
      'Widget needed on home screen',
      name: 'widgetNeededOnHomeScreen',
      desc: 'Explanation about widget requirement',
      args: [],
    );
  }

  /// `To add the widget to your home screen:`
  String get toAddWidget {
    return Intl.message(
      'To add the widget to your home screen:',
      name: 'toAddWidget',
      desc: 'Header for widget addition instructions',
      args: [],
    );
  }

  /// `Long press on an empty area of your home screen`
  String get longPressHomeScreen {
    return Intl.message(
      'Long press on an empty area of your home screen',
      name: 'longPressHomeScreen',
      desc: 'Step 1 for adding widget',
      args: [],
    );
  }

  /// `Select 'Widgets' or 'Add widget'`
  String get selectWidgets {
    return Intl.message(
      'Select \'Widgets\' or \'Add widget\'',
      name: 'selectWidgets',
      desc: 'Step 2 for adding widget',
      args: [],
    );
  }

  /// `Find and select 'Azkary' widget`
  String get findAzkaryWidget {
    return Intl.message(
      'Find and select \'Azkary\' widget',
      name: 'findAzkaryWidget',
      desc: 'Step 3 for adding widget',
      args: [],
    );
  }

  /// `Drag and place the widget where you want it`
  String get dragWidget {
    return Intl.message(
      'Drag and place the widget where you want it',
      name: 'dragWidget',
      desc: 'Step 4 for adding widget',
      args: [],
    );
  }

  /// `The widget will update automatically with new Azkar periodically.`
  String get widgetUpdateInstructions {
    return Intl.message(
      'The widget will update automatically with new Azkar periodically.',
      name: 'widgetUpdateInstructions',
      desc: 'Instructions for updating the widget',
      args: [],
    );
  }

  /// `Note: The exact steps may vary slightly depending on your device model and Android version.`
  String get deviceSpecificNote {
    return Intl.message(
      'Note: The exact steps may vary slightly depending on your device model and Android version.',
      name: 'deviceSpecificNote',
      desc: 'Note about device-specific differences',
      args: [],
    );
  }

  /// `Widget updated successfully`
  String get widgetUpdatedSuccessfully {
    return Intl.message(
      'Widget updated successfully',
      name: 'widgetUpdatedSuccessfully',
      desc: 'Success message for widget update',
      args: [],
    );
  }

  /// `Prayer Times`
  String get prayerTimes {
    return Intl.message(
      'Prayer Times',
      name: 'prayerTimes',
      desc: '',
      args: [],
    );
  }

  /// `Fajr`
  String get fajr {
    return Intl.message('Fajr', name: 'fajr', desc: '', args: []);
  }

  /// `Sunrise`
  String get sunrise {
    return Intl.message('Sunrise', name: 'sunrise', desc: '', args: []);
  }

  /// `Dhuhr`
  String get dhuhr {
    return Intl.message('Dhuhr', name: 'dhuhr', desc: '', args: []);
  }

  /// `Asr`
  String get asr {
    return Intl.message('Asr', name: 'asr', desc: '', args: []);
  }

  /// `Maghrib`
  String get maghrib {
    return Intl.message('Maghrib', name: 'maghrib', desc: '', args: []);
  }

  /// `Isha`
  String get isha {
    return Intl.message('Isha', name: 'isha', desc: '', args: []);
  }

  /// `Today's Prayer Times`
  String get todayPrayerTimes {
    return Intl.message(
      'Today\'s Prayer Times',
      name: 'todayPrayerTimes',
      desc: '',
      args: [],
    );
  }

  /// `Error loading prayer times. Please check your location settings and try again.`
  String get errorLoadingPrayerTimes {
    return Intl.message(
      'Error loading prayer times. Please check your location settings and try again.',
      name: 'errorLoadingPrayerTimes',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgain {
    return Intl.message('Try Again', name: 'tryAgain', desc: '', args: []);
  }

  /// `Next Prayer`
  String get nextPrayer {
    return Intl.message('Next Prayer', name: 'nextPrayer', desc: '', args: []);
  }

  /// `Location updated successfully`
  String get locationUpdatedSuccessfully {
    return Intl.message(
      'Location updated successfully',
      name: 'locationUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error updating location`
  String get errorUpdatingLocation {
    return Intl.message(
      'Error updating location',
      name: 'errorUpdatingLocation',
      desc: '',
      args: [],
    );
  }

  /// `Update Current Location`
  String get updateCurrentLocation {
    return Intl.message(
      'Update Current Location',
      name: 'updateCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Location not available`
  String get locationNotAvailable {
    return Intl.message(
      'Location not available',
      name: 'locationNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Loading location...`
  String get loadingLocation {
    return Intl.message(
      'Loading location...',
      name: 'loadingLocation',
      desc: '',
      args: [],
    );
  }

  /// `Error loading location`
  String get errorLoadingLocation {
    return Intl.message(
      'Error loading location',
      name: 'errorLoadingLocation',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: 'Text for close button',
      args: [],
    );
  }

  /// `Prayer Times Settings`
  String get prayerTimesSettings {
    return Intl.message(
      'Prayer Times Settings',
      name: 'prayerTimesSettings',
      desc: '',
      args: [],
    );
  }

  /// `Calculation Method`
  String get calculationMethod {
    return Intl.message(
      'Calculation Method',
      name: 'calculationMethod',
      desc: '',
      args: [],
    );
  }

  /// `Madhab (Asr Calculation)`
  String get madhabAsrCalculation {
    return Intl.message(
      'Madhab (Asr Calculation)',
      name: 'madhabAsrCalculation',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Save & Close`
  String get saveAndClose {
    return Intl.message(
      'Save & Close',
      name: 'saveAndClose',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian General Authority of Survey`
  String get egyptianGeneralAuthorityOfSurvey {
    return Intl.message(
      'Egyptian General Authority of Survey',
      name: 'egyptianGeneralAuthorityOfSurvey',
      desc: '',
      args: [],
    );
  }

  /// `University of Islamic Sciences, Karachi`
  String get universityOfIslamicSciencesKarachi {
    return Intl.message(
      'University of Islamic Sciences, Karachi',
      name: 'universityOfIslamicSciencesKarachi',
      desc: '',
      args: [],
    );
  }

  /// `Muslim World League`
  String get muslimWorldLeague {
    return Intl.message(
      'Muslim World League',
      name: 'muslimWorldLeague',
      desc: '',
      args: [],
    );
  }

  /// `North America (ISNA)`
  String get northAmericaISNA {
    return Intl.message(
      'North America (ISNA)',
      name: 'northAmericaISNA',
      desc: '',
      args: [],
    );
  }

  /// `Dubai (UAE)`
  String get dubaiUAE {
    return Intl.message('Dubai (UAE)', name: 'dubaiUAE', desc: '', args: []);
  }

  /// `Moonsighting Committee`
  String get moonsightingCommittee {
    return Intl.message(
      'Moonsighting Committee',
      name: 'moonsightingCommittee',
      desc: '',
      args: [],
    );
  }

  /// `Kuwait`
  String get kuwait {
    return Intl.message('Kuwait', name: 'kuwait', desc: '', args: []);
  }

  /// `Qatar`
  String get qatar {
    return Intl.message('Qatar', name: 'qatar', desc: '', args: []);
  }

  /// `Singapore`
  String get singapore {
    return Intl.message('Singapore', name: 'singapore', desc: '', args: []);
  }

  /// `Turkey`
  String get turkey {
    return Intl.message('Turkey', name: 'turkey', desc: '', args: []);
  }

  /// `Tehran`
  String get tehran {
    return Intl.message('Tehran', name: 'tehran', desc: '', args: []);
  }

  /// `Umm al-Qura University, Makkah`
  String get ummAlQuraUniversityMakkah {
    return Intl.message(
      'Umm al-Qura University, Makkah',
      name: 'ummAlQuraUniversityMakkah',
      desc: '',
      args: [],
    );
  }

  /// `Shafi, Maliki, Hanbali`
  String get shafiMalikiHanbali {
    return Intl.message(
      'Shafi, Maliki, Hanbali',
      name: 'shafiMalikiHanbali',
      desc: '',
      args: [],
    );
  }

  /// `Hanafi`
  String get hanafi {
    return Intl.message('Hanafi', name: 'hanafi', desc: '', args: []);
  }

  /// `h`
  String get hours {
    return Intl.message('h', name: 'hours', desc: '', args: []);
  }

  /// `min`
  String get minutes {
    return Intl.message('min', name: 'minutes', desc: '', args: []);
  }

  /// `Tomorrow`
  String get tomorrow {
    return Intl.message(
      'Tomorrow',
      name: 'tomorrow',
      desc: 'Label for tomorrow',
      args: [],
    );
  }

  /// `Rate App`
  String get rateApp {
    return Intl.message(
      'Rate App',
      name: 'rateApp',
      desc: 'Label for rate app option in settings',
      args: [],
    );
  }

  /// `Share App`
  String get shareApp {
    return Intl.message(
      'Share App',
      name: 'shareApp',
      desc: 'Label for share app option in settings',
      args: [],
    );
  }

  /// `Page {number}`
  String page(int number) {
    return Intl.message(
      'Page $number',
      name: 'page',
      desc: 'Text for page number',
      args: [number],
    );
  }

  /// `Hide navigation bar`
  String get hideNavigationBar {
    return Intl.message(
      'Hide navigation bar',
      name: 'hideNavigationBar',
      desc: 'Tooltip for the button to hide the bottom navigation bar',
      args: [],
    );
  }

  /// `Show navigation bar`
  String get showNavigationBar {
    return Intl.message(
      'Show navigation bar',
      name: 'showNavigationBar',
      desc: 'Tooltip for the button to show the bottom navigation bar',
      args: [],
    );
  }

  /// `Enter full screen`
  String get enterFullScreen {
    return Intl.message(
      'Enter full screen',
      name: 'enterFullScreen',
      desc: 'Tooltip for the button to enter full screen mode',
      args: [],
    );
  }

  /// `Exit full screen`
  String get exitFullScreen {
    return Intl.message(
      'Exit full screen',
      name: 'exitFullScreen',
      desc: 'Tooltip for the button to exit full screen mode',
      args: [],
    );
  }

  /// `Location services are disabled. Please enable the services`
  String get locationServicesDisabled {
    return Intl.message(
      'Location services are disabled. Please enable the services',
      name: 'locationServicesDisabled',
      desc: 'Message shown when location services are disabled',
      args: [],
    );
  }

  /// `Location permissions are denied`
  String get locationPermissionDenied {
    return Intl.message(
      'Location permissions are denied',
      name: 'locationPermissionDenied',
      desc: 'Message shown when location permissions are denied',
      args: [],
    );
  }

  /// `Location permissions are permanently denied, please enable them in app settings`
  String get locationPermissionPermanentlyDenied {
    return Intl.message(
      'Location permissions are permanently denied, please enable them in app settings',
      name: 'locationPermissionPermanentlyDenied',
      desc: 'Message shown when location permissions are permanently denied',
      args: [],
    );
  }

  /// `Updating location...`
  String get updatingLocation {
    return Intl.message(
      'Updating location...',
      name: 'updatingLocation',
      desc: 'Message shown when updating location',
      args: [],
    );
  }

  /// `Ads are disabled in this version`
  String get adsDisabled {
    return Intl.message(
      'Ads are disabled in this version',
      name: 'adsDisabled',
      desc: 'Message shown when ads are disabled',
      args: [],
    );
  }

  /// `Are you sure you want to exit?`
  String get pressBackToExit {
    return Intl.message(
      'Are you sure you want to exit?',
      name: 'pressBackToExit',
      desc: '',
      args: [],
    );
  }

  /// `Select Surah`
  String get selectSurah {
    return Intl.message(
      'Select Surah',
      name: 'selectSurah',
      desc: 'Title for the surah selection dialog',
      args: [],
    );
  }

  /// `Page {number} not available`
  String pageNotAvailable(int number) {
    return Intl.message(
      'Page $number not available',
      name: 'pageNotAvailable',
      desc: 'Message shown when a Quran page is not available',
      args: [number],
    );
  }

  /// `Add Bookmark`
  String get addBookmark {
    return Intl.message(
      'Add Bookmark',
      name: 'addBookmark',
      desc: 'Text for add bookmark action',
      args: [],
    );
  }

  /// `Remove Bookmark`
  String get removeBookmark {
    return Intl.message(
      'Remove Bookmark',
      name: 'removeBookmark',
      desc: 'Text for remove bookmark action',
      args: [],
    );
  }

  /// `View Bookmarks`
  String get viewBookmarks {
    return Intl.message(
      'View Bookmarks',
      name: 'viewBookmarks',
      desc: 'Text for view bookmarks action',
      args: [],
    );
  }

  /// `Tap to view this page`
  String get tapToView {
    return Intl.message(
      'Tap to view this page',
      name: 'tapToView',
      desc: 'Hint text for tapping on a bookmark to view it',
      args: [],
    );
  }

  /// `No bookmarks yet`
  String get bookmarksEmpty {
    return Intl.message(
      'No bookmarks yet',
      name: 'bookmarksEmpty',
      desc: 'Message shown when no bookmarks exist',
      args: [],
    );
  }

  /// `Qibla Direction`
  String get qiblaDirection {
    return Intl.message(
      'Qibla Direction',
      name: 'qiblaDirection',
      desc: 'Title for Qibla direction feature',
      args: [],
    );
  }

  /// `Compass not available on this device`
  String get compassNotAvailable {
    return Intl.message(
      'Compass not available on this device',
      name: 'compassNotAvailable',
      desc: 'Message shown when compass is not available',
      args: [],
    );
  }

  /// `Enter city name`
  String get enterCityName {
    return Intl.message(
      'Enter city name',
      name: 'enterCityName',
      desc: 'Label for city name input field',
      args: [],
    );
  }

  /// `Use my location`
  String get useMyLocation {
    return Intl.message(
      'Use my location',
      name: 'useMyLocation',
      desc: 'Label for use my location button',
      args: [],
    );
  }

  /// `Qibla direction:`
  String get qiblaIs {
    return Intl.message(
      'Qibla direction:',
      name: 'qiblaIs',
      desc: 'Label for Qibla direction info',
      args: [],
    );
  }

  /// `Distance to Kaaba`
  String get distanceToKaaba {
    return Intl.message(
      'Distance to Kaaba',
      name: 'distanceToKaaba',
      desc: 'Label for distance to Kaaba info',
      args: [],
    );
  }

  /// `Latitude`
  String get latitude {
    return Intl.message(
      'Latitude',
      name: 'latitude',
      desc: 'Label for latitude info',
      args: [],
    );
  }

  /// `Longitude`
  String get longitude {
    return Intl.message(
      'Longitude',
      name: 'longitude',
      desc: 'Label for longitude info',
      args: [],
    );
  }

  /// `Qibla Compass`
  String get qiblaCompass {
    return Intl.message(
      'Qibla Compass',
      name: 'qiblaCompass',
      desc: 'Label for Qibla compass',
      args: [],
    );
  }

  /// `You are facing Qibla direction`
  String get youAreFacingQiblaDirection {
    return Intl.message(
      'You are facing Qibla direction',
      name: 'youAreFacingQiblaDirection',
      desc: 'Label for you are facing Qibla direction',
      args: [],
    );
  }

  /// `Turn to find Qibla direction`
  String get turnToFindQiblaDirection {
    return Intl.message(
      'Turn to find Qibla direction',
      name: 'turnToFindQiblaDirection',
      desc: 'Label for turn to find Qibla direction',
      args: [],
    );
  }

  /// `Current heading`
  String get currentHeading {
    return Intl.message(
      'Current heading',
      name: 'currentHeading',
      desc: 'Label for current heading',
      args: [],
    );
  }

  /// `Your Location`
  String get yourLocation {
    return Intl.message(
      'Your Location',
      name: 'yourLocation',
      desc: 'Label for your location',
      args: [],
    );
  }

  /// `Angle to Qibla`
  String get angleToQibla {
    return Intl.message(
      'Angle to Qibla',
      name: 'angleToQibla',
      desc: 'Label for angle to Qibla',
      args: [],
    );
  }

  /// `Qibla direction is:`
  String get qiblaDirectionIs {
    return Intl.message(
      'Qibla direction is:',
      name: 'qiblaDirectionIs',
      desc: 'Label for qibla direction',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
