import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get azkar => 'Azkar';

  @override
  String get tasbih => 'Tasbih';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get settings => 'Settings';

  @override
  String get no_internet_connection => 'No internet connection, please check you network and try again';

  @override
  String get no_data => 'No Available Data';

  @override
  String get no_order => 'No Available Orders Now!';

  @override
  String get internal_server_error => 'Internal Server Error';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get login => 'Log in';

  @override
  String get register => 'Register';

  @override
  String get welcomeMessage => 'Welcome to Dawar';

  @override
  String get addAllFieldsFirst => 'Add all the data first';

  @override
  String get phoneInvalid => 'Phone number is incorrect';

  @override
  String get passwordCompleted => 'Password has entered successfully';

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get registerWithOtp => 'Register with OTP';

  @override
  String get otp => 'OTP';

  @override
  String get success => 'Success...';

  @override
  String get alreadyRegistered => 'Already registered';

  @override
  String get weight => 'Weight';

  @override
  String get kg => 'KG';

  @override
  String get receiveLoad => 'Receive load';

  @override
  String get vehicleLoads => 'Vehicle Loads';

  @override
  String get ordersNumber => 'Orders number';

  @override
  String get bagsNumber => 'Bags number';

  @override
  String get ticketNo => 'Ticket No';

  @override
  String get totalWeight => 'Total previous weight from this material  ';

  @override
  String get chooseWasteType => 'Choose Waste Type First';

  @override
  String get language => 'Language';

  @override
  String get logOut => 'Log Out';

  @override
  String get appName => 'Azkary';

  @override
  String get morningAzkar => 'Morning Azkar';

  @override
  String get morningAzkarAr => 'أذكار الصباح';

  @override
  String get morningAzkarDesc => 'Morning remembrance and supplications';

  @override
  String get eveningAzkar => 'Evening Azkar';

  @override
  String get eveningAzkarAr => 'أذكار المساء';

  @override
  String get eveningAzkarDesc => 'Evening remembrance and supplications';

  @override
  String get sleepAzkar => 'Sleep Azkar';

  @override
  String get sleepAzkarAr => 'أذكار النوم';

  @override
  String get sleepAzkarDesc => 'Azkar before sleeping';

  @override
  String get wakeupAzkar => 'Wake Up Azkar';

  @override
  String get wakeupAzkarAr => 'أذكار الاستيقاظ';

  @override
  String get wakeupAzkarDesc => 'Azkar after waking up';

  @override
  String get prayerAzkar => 'After Prayer';

  @override
  String get prayerAzkarAr => 'أذكار بعد الصلاة';

  @override
  String get prayerAzkarDesc => 'Azkar after completing prayer';

  @override
  String get quranicDuas => 'Quranic Duas';

  @override
  String get quranicDuasAr => 'أدعية قرآنية';

  @override
  String get quranicDuasDesc => 'Supplications from the Holy Quran';

  @override
  String get azkarCategories => 'Azkar Categories';

  @override
  String repeatCount(int count) {
    return 'Repeat $count times';
  }

  @override
  String get noBookmarks => 'No bookmarks yet';

  @override
  String get addBookmarksHint => 'Add Azkar to your bookmarks\nto access them quickly';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get fontSize => 'Font Size';

  @override
  String get notifications => 'Notifications';

  @override
  String get morningReminder => 'Morning Azkar Reminder';

  @override
  String get morningReminderDesc => 'Daily reminder for morning azkar';

  @override
  String get eveningReminder => 'Evening Azkar Reminder';

  @override
  String get eveningReminderDesc => 'Daily reminder for evening azkar';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get permissionRequired => 'Permission Required';

  @override
  String get notificationPermission => 'Please enable notifications in system settings';

  @override
  String get exactAlarmPermission => 'This app needs permission to schedule exact alarms for Azkar reminders. Please grant this permission in system settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get digitalTasbih => 'Digital Tasbih';

  @override
  String target(int count) {
    return 'Target: $count';
  }

  @override
  String get namesOfAllah => 'Names of Allah';

  @override
  String get century => 'Century';

  @override
  String get morningAzkarReminder => 'Morning Azkar Reminder';

  @override
  String get eveningAzkarReminder => 'Evening Azkar Reminder';

  @override
  String get dailyReminderForMorningAzkar => 'Daily reminder for morning azkar';

  @override
  String get dailyReminderForEveningAzkar => 'Daily reminder for evening azkar';

  @override
  String get timeForYourMorningRemembrance => 'Time for your morning remembrance';

  @override
  String get timeForYourEveningRemembrance => 'Time for your evening remembrance';

  @override
  String get repeat => 'Repeat';

  @override
  String get times => 'times';

  @override
  String get noAudioAvailable => 'No audio available for this dhikr';

  @override
  String errorPlayingAudio(String error) {
    return 'Error playing audio: $error';
  }

  @override
  String get audioComingSoon => 'Audio feature coming soon!';

  @override
  String categoryName(String name) {
    return '$name';
  }

  @override
  String get addWidgetToHomeScreen => 'Add Widget to Home Screen';

  @override
  String get widgetNeededOnHomeScreen => 'The Azkary widget needs to be added to your home screen before it can be updated.';

  @override
  String get toAddWidget => 'To add the widget:';

  @override
  String get longPressHomeScreen => 'Long press on an empty area of your home screen';

  @override
  String get selectWidgets => 'Select \"Widgets\" from the menu that appears';

  @override
  String get findAzkaryWidget => 'Find \"Azkary\" in the list of widgets';

  @override
  String get dragWidget => 'Drag the Azkary widget to your home screen';

  @override
  String get widgetUpdateInstructions => 'Once added, you can update the widget by pressing the refresh button in this app.';

  @override
  String get deviceSpecificNote => 'Note: Different Android devices may have slightly different steps to add widgets.';

  @override
  String get widgetUpdatedSuccessfully => 'Widget updated successfully';
}
