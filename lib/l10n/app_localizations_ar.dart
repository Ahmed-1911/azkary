import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get azkar => 'أذكار';

  @override
  String get tasbih => 'تسبيح';

  @override
  String get bookmarks => 'المفضلة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get no_internet_connection => 'لا يوجد اتصال بالإنترنت ، يرجى التحقق من الإتصال والمحاولة مرة أخرى';

  @override
  String get no_data => 'لا يوجد بيانات متاحة';

  @override
  String get no_order => 'لا يوجد طلبات متاحة الان';

  @override
  String get internal_server_error => 'يوجد خطأ داخلي حاول مرة اخرى';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get password => 'الرقم السرى';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get login => 'تسجيل';

  @override
  String get register => 'تسجيل جديد';

  @override
  String get welcomeMessage => 'مرحبا بك في دور ';

  @override
  String get addAllFieldsFirst => 'قم باضافه جميع البيانات اولا ';

  @override
  String get phoneInvalid => 'رقم الهاتف غير صحيح';

  @override
  String get passwordCompleted => 'تم تعين كلمه السر بنجاخ';

  @override
  String get ok => 'موافق';

  @override
  String get cancel => 'الغاء';

  @override
  String get registerWithOtp => 'تسجيل باستخدام رمز التأكيد';

  @override
  String get otp => ' رمز التأكيد';

  @override
  String get success => 'تم بنجاح...';

  @override
  String get alreadyRegistered => 'لدى حساب ';

  @override
  String get weight => 'الوزن';

  @override
  String get kg => 'كجم';

  @override
  String get receiveLoad => 'استلام حمولة';

  @override
  String get vehicleLoads => 'الحمولات';

  @override
  String get ordersNumber => 'عدد الطلبات';

  @override
  String get bagsNumber => 'عدد الاكياس';

  @override
  String get ticketNo => 'رقم الطلب';

  @override
  String get totalWeight => 'اجمالى الوزن السابق من هذه الخامة ';

  @override
  String get chooseWasteType => 'اختر الخامة اولا';

  @override
  String get language => 'اللغة';

  @override
  String get logOut => 'تسجيل حروج';

  @override
  String get appName => 'أذكاري';

  @override
  String get morningAzkar => 'أذكار الصباح';

  @override
  String get morningAzkarAr => 'أذكار الصباح';

  @override
  String get morningAzkarDesc => 'أذكار وأدعية الصباح';

  @override
  String get eveningAzkar => 'أذكار المساء';

  @override
  String get eveningAzkarAr => 'أذكار المساء';

  @override
  String get eveningAzkarDesc => 'أذكار وأدعية المساء';

  @override
  String get sleepAzkar => 'أذكار النوم';

  @override
  String get sleepAzkarAr => 'أذكار النوم';

  @override
  String get sleepAzkarDesc => 'أذكار قبل النوم';

  @override
  String get wakeupAzkar => 'أذكار الاستيقاظ';

  @override
  String get wakeupAzkarAr => 'أذكار الاستيقاظ';

  @override
  String get wakeupAzkarDesc => 'أذكار بعد الاستيقاظ من النوم';

  @override
  String get prayerAzkar => 'أذكار بعد الصلاة';

  @override
  String get prayerAzkarAr => 'أذكار بعد الصلاة';

  @override
  String get prayerAzkarDesc => 'أذكار ما بعد الصلاة';

  @override
  String get quranicDuas => 'أدعية قرآنية';

  @override
  String get quranicDuasAr => 'أدعية قرآنية';

  @override
  String get quranicDuasDesc => 'أدعية من القرآن الكريم';

  @override
  String get azkarCategories => 'أقسام الأذكار';

  @override
  String repeatCount(int count) {
    return 'التكرار $count مرات';
  }

  @override
  String get noBookmarks => 'لا توجد أذكار في المفضلة';

  @override
  String get addBookmarksHint => 'أضف الأذكار إلى المفضلة\nللوصول إليها بسرعة';

  @override
  String get appearance => 'المظهر';

  @override
  String get darkMode => 'الوضع الليلي';

  @override
  String get fontSize => 'حجم الخط';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get morningReminder => 'تذكير أذكار الصباح';

  @override
  String get morningReminderDesc => 'تذكير يومي لأذكار الصباح';

  @override
  String get eveningReminder => 'تذكير أذكار المساء';

  @override
  String get eveningReminderDesc => 'تذكير يومي لأذكار المساء';

  @override
  String get about => 'حول التطبيق';

  @override
  String get version => 'الإصدار';

  @override
  String get developer => 'المطور';

  @override
  String get permissionRequired => 'الإذن مطلوب';

  @override
  String get notificationPermission => 'يرجى تفعيل الإشعارات في إعدادات النظام';

  @override
  String get exactAlarmPermission => 'يحتاج التطبيق إلى إذن لجدولة التنبيهات الدقيقة لتذكير الأذكار. يرجى منح هذا الإذن في إعدادات النظام.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get digitalTasbih => 'السبحة الإلكترونية';

  @override
  String target(int count) {
    return 'الهدف: $count';
  }

  @override
  String get namesOfAllah => 'أسماء الله الحسنى';

  @override
  String get century => 'المئة';

  @override
  String get morningAzkarReminder => 'تذكير أذكار الصباح';

  @override
  String get eveningAzkarReminder => 'تذكير أذكار المساء';

  @override
  String get dailyReminderForMorningAzkar => 'تذكير يومي لأذكار الصباح';

  @override
  String get dailyReminderForEveningAzkar => 'تذكير يومي لأذكار المساء';

  @override
  String get timeForYourMorningRemembrance => 'حان وقت أذكار الصباح';

  @override
  String get timeForYourEveningRemembrance => 'حان وقت أذكار المساء';

  @override
  String get repeat => 'كرر';

  @override
  String get times => 'مرات';

  @override
  String get noAudioAvailable => 'لا يوجد صوت متاح لهذا الذكر';

  @override
  String errorPlayingAudio(String error) {
    return 'خطأ في تشغيل الصوت: $error';
  }

  @override
  String get audioComingSoon => 'ميزة الصوت قريباً!';

  @override
  String categoryName(String name) {
    return '$name';
  }
}
