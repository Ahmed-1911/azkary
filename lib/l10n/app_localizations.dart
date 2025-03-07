import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// Label for Azkar navigation item
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkar;

  /// Label for Tasbih navigation item
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbih;

  /// Label for Bookmarks navigation item
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// Label for Settings navigation item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection, please check you network and try again'**
  String get no_internet_connection;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No Available Data'**
  String get no_data;

  /// No description provided for @no_order.
  ///
  /// In en, this message translates to:
  /// **'No Available Orders Now!'**
  String get no_order;

  /// No description provided for @internal_server_error.
  ///
  /// In en, this message translates to:
  /// **'Internal Server Error'**
  String get internal_server_error;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Dawar'**
  String get welcomeMessage;

  /// No description provided for @addAllFieldsFirst.
  ///
  /// In en, this message translates to:
  /// **'Add all the data first'**
  String get addAllFieldsFirst;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone number is incorrect'**
  String get phoneInvalid;

  /// No description provided for @passwordCompleted.
  ///
  /// In en, this message translates to:
  /// **'Password has entered successfully'**
  String get passwordCompleted;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @registerWithOtp.
  ///
  /// In en, this message translates to:
  /// **'Register with OTP'**
  String get registerWithOtp;

  /// No description provided for @otp.
  ///
  /// In en, this message translates to:
  /// **'OTP'**
  String get otp;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success...'**
  String get success;

  /// No description provided for @alreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Already registered'**
  String get alreadyRegistered;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'KG'**
  String get kg;

  /// No description provided for @receiveLoad.
  ///
  /// In en, this message translates to:
  /// **'Receive load'**
  String get receiveLoad;

  /// No description provided for @vehicleLoads.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Loads'**
  String get vehicleLoads;

  /// No description provided for @ordersNumber.
  ///
  /// In en, this message translates to:
  /// **'Orders number'**
  String get ordersNumber;

  /// No description provided for @bagsNumber.
  ///
  /// In en, this message translates to:
  /// **'Bags number'**
  String get bagsNumber;

  /// No description provided for @ticketNo.
  ///
  /// In en, this message translates to:
  /// **'Ticket No'**
  String get ticketNo;

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total previous weight from this material  '**
  String get totalWeight;

  /// No description provided for @chooseWasteType.
  ///
  /// In en, this message translates to:
  /// **'Choose Waste Type First'**
  String get chooseWasteType;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Azkary'**
  String get appName;

  /// Title for morning remembrance category
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar'**
  String get morningAzkar;

  /// Arabic title for morning remembrance category
  ///
  /// In en, this message translates to:
  /// **'أذكار الصباح'**
  String get morningAzkarAr;

  /// Description for morning azkar category
  ///
  /// In en, this message translates to:
  /// **'Morning remembrance and supplications'**
  String get morningAzkarDesc;

  /// Title for evening remembrance category
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar'**
  String get eveningAzkar;

  /// Arabic title for evening remembrance category
  ///
  /// In en, this message translates to:
  /// **'أذكار المساء'**
  String get eveningAzkarAr;

  /// Description for evening azkar category
  ///
  /// In en, this message translates to:
  /// **'Evening remembrance and supplications'**
  String get eveningAzkarDesc;

  /// Title for sleep remembrance category
  ///
  /// In en, this message translates to:
  /// **'Sleep Azkar'**
  String get sleepAzkar;

  /// Arabic title for sleep remembrance category
  ///
  /// In en, this message translates to:
  /// **'أذكار النوم'**
  String get sleepAzkarAr;

  /// Description for sleep azkar category
  ///
  /// In en, this message translates to:
  /// **'Azkar before sleeping'**
  String get sleepAzkarDesc;

  /// Title for wake up remembrance category
  ///
  /// In en, this message translates to:
  /// **'Wake Up Azkar'**
  String get wakeupAzkar;

  /// Arabic title for wake up remembrance category
  ///
  /// In en, this message translates to:
  /// **'أذكار الاستيقاظ'**
  String get wakeupAzkarAr;

  /// Description for wake up azkar category
  ///
  /// In en, this message translates to:
  /// **'Azkar after waking up'**
  String get wakeupAzkarDesc;

  /// Title for after prayer remembrance category
  ///
  /// In en, this message translates to:
  /// **'After Prayer'**
  String get prayerAzkar;

  /// Arabic title for after prayer remembrance category
  ///
  /// In en, this message translates to:
  /// **'أذكار بعد الصلاة'**
  String get prayerAzkarAr;

  /// Description for after prayer azkar category
  ///
  /// In en, this message translates to:
  /// **'Azkar after completing prayer'**
  String get prayerAzkarDesc;

  /// Title for Quranic supplications category
  ///
  /// In en, this message translates to:
  /// **'Quranic Duas'**
  String get quranicDuas;

  /// Arabic title for Quranic supplications category
  ///
  /// In en, this message translates to:
  /// **'أدعية قرآنية'**
  String get quranicDuasAr;

  /// Description for Quranic supplications category
  ///
  /// In en, this message translates to:
  /// **'Supplications from the Holy Quran'**
  String get quranicDuasDesc;

  /// Title for the categories screen
  ///
  /// In en, this message translates to:
  /// **'Azkar Categories'**
  String get azkarCategories;

  /// Text showing how many times to repeat the zikr
  ///
  /// In en, this message translates to:
  /// **'Repeat {count} times'**
  String repeatCount(int count);

  /// Message shown when no bookmarks exist
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get noBookmarks;

  /// Hint text shown when bookmarks list is empty
  ///
  /// In en, this message translates to:
  /// **'Add Azkar to your bookmarks\nto access them quickly'**
  String get addBookmarksHint;

  /// Title for appearance section in settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Label for dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Label for font size slider
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// Title for notifications section in settings
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Label for morning reminder toggle
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar Reminder'**
  String get morningReminder;

  /// Description for morning reminder setting
  ///
  /// In en, this message translates to:
  /// **'Daily reminder for morning azkar'**
  String get morningReminderDesc;

  /// Label for evening reminder toggle
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar Reminder'**
  String get eveningReminder;

  /// Description for evening reminder setting
  ///
  /// In en, this message translates to:
  /// **'Daily reminder for evening azkar'**
  String get eveningReminderDesc;

  /// Title for about section in settings
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Label for app version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Label for developer info
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// Title for permission dialog
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionRequired;

  /// Message asking for notification permission
  ///
  /// In en, this message translates to:
  /// **'Please enable notifications in system settings'**
  String get notificationPermission;

  /// Message asking for exact alarm permission
  ///
  /// In en, this message translates to:
  /// **'This app needs permission to schedule exact alarms for Azkar reminders. Please grant this permission in system settings.'**
  String get exactAlarmPermission;

  /// Label for button to open settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Title for tasbih screen
  ///
  /// In en, this message translates to:
  /// **'Digital Tasbih'**
  String get digitalTasbih;

  /// Label showing target count for tasbih
  ///
  /// In en, this message translates to:
  /// **'Target: {count}'**
  String target(int count);

  /// Label for 99 names option
  ///
  /// In en, this message translates to:
  /// **'Names of Allah'**
  String get namesOfAllah;

  /// Label for 100 count option
  ///
  /// In en, this message translates to:
  /// **'Century'**
  String get century;

  /// Title for morning azkar reminder setting
  ///
  /// In en, this message translates to:
  /// **'Morning Azkar Reminder'**
  String get morningAzkarReminder;

  /// Title for evening azkar reminder setting
  ///
  /// In en, this message translates to:
  /// **'Evening Azkar Reminder'**
  String get eveningAzkarReminder;

  /// Description for morning azkar reminder
  ///
  /// In en, this message translates to:
  /// **'Daily reminder for morning azkar'**
  String get dailyReminderForMorningAzkar;

  /// Description for evening azkar reminder
  ///
  /// In en, this message translates to:
  /// **'Daily reminder for evening azkar'**
  String get dailyReminderForEveningAzkar;

  /// Notification message for morning azkar
  ///
  /// In en, this message translates to:
  /// **'Time for your morning remembrance'**
  String get timeForYourMorningRemembrance;

  /// Notification message for evening azkar
  ///
  /// In en, this message translates to:
  /// **'Time for your evening remembrance'**
  String get timeForYourEveningRemembrance;

  /// Text for repeat count label
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// Text for number of times
  ///
  /// In en, this message translates to:
  /// **'times'**
  String get times;

  /// Message shown when no audio is available for an Azkar
  ///
  /// In en, this message translates to:
  /// **'No audio available for this dhikr'**
  String get noAudioAvailable;

  /// Message shown when there's an error playing audio
  ///
  /// In en, this message translates to:
  /// **'Error playing audio: {error}'**
  String errorPlayingAudio(String error);

  /// Message shown when audio feature is not yet available
  ///
  /// In en, this message translates to:
  /// **'Audio feature coming soon!'**
  String get audioComingSoon;

  /// The name of a category
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String categoryName(String name);

  /// Title for the widget info dialog
  ///
  /// In en, this message translates to:
  /// **'Add Widget to Home Screen'**
  String get addWidgetToHomeScreen;

  /// Explanation about widget requirement
  ///
  /// In en, this message translates to:
  /// **'The Azkary widget needs to be added to your home screen before it can be updated.'**
  String get widgetNeededOnHomeScreen;

  /// Header for widget addition instructions
  ///
  /// In en, this message translates to:
  /// **'To add the widget:'**
  String get toAddWidget;

  /// Step 1 for adding widget
  ///
  /// In en, this message translates to:
  /// **'Long press on an empty area of your home screen'**
  String get longPressHomeScreen;

  /// Step 2 for adding widget
  ///
  /// In en, this message translates to:
  /// **'Select \"Widgets\" from the menu that appears'**
  String get selectWidgets;

  /// Step 3 for adding widget
  ///
  /// In en, this message translates to:
  /// **'Find \"Azkary\" in the list of widgets'**
  String get findAzkaryWidget;

  /// Step 4 for adding widget
  ///
  /// In en, this message translates to:
  /// **'Drag the Azkary widget to your home screen'**
  String get dragWidget;

  /// Instructions for updating the widget
  ///
  /// In en, this message translates to:
  /// **'Once added, you can update the widget by pressing the refresh button in this app.'**
  String get widgetUpdateInstructions;

  /// Note about device-specific differences
  ///
  /// In en, this message translates to:
  /// **'Note: Different Android devices may have slightly different steps to add widgets.'**
  String get deviceSpecificNote;

  /// Success message for widget update
  ///
  /// In en, this message translates to:
  /// **'Widget updated successfully'**
  String get widgetUpdatedSuccessfully;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
