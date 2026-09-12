import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('ku'),
    Locale('kbd'),
    Locale('ar'),
    Locale('en'),
    Locale('tr'),
  ];

  String get languageCode => locale.languageCode;
  bool get isRTL =>
      locale.languageCode == 'ku' ||
      locale.languageCode == 'kbd' ||
      locale.languageCode == 'ar';

  String _t(Map<String, String> map) =>
      map[locale.languageCode] ?? map['ku'] ?? map['en'] ?? '';

  // =====================
  // APP GENERAL
  // =====================
  String get appName => _t({
        'ku': 'EduBook - IQ',
        'kbd': 'EduBook - IQ',
        'ar': 'EduBook - IQ',
        'en': 'EduBook - IQ',
        'tr': 'EduBook - IQ'
      });
  String get appTagline => _t({
        'ku': ' پلاتفۆرمی پەروەردەیی',
        'kbd': 'پلاتفۆرمێ پەروەردەیا ',
        'ar': 'منصة تعليمية',
        'en': 'Educational Platform',
        'tr': 'Eğitim Platformu'
      });
  String get loading => _t({
        'ku': 'چاوەڕوان بە...',
        'kbd': 'ل هیڤیێ بە...',
        'ar': 'جاري التحميل...',
        'en': 'Loading...',
        'tr': 'Yükleniyor...'
      });
  String get error => _t(
      {'ku': 'هەڵە', 'kbd': 'شاشی', 'ar': 'خطأ', 'en': 'Error', 'tr': 'Hata'});
  String get somethingWentWrong => _t({
        'ku': 'هەڵەیەک ڕوویدا، تکایە دووبارە هەوڵ بدەرەوە',
        'kbd': 'شاشیەک رویدا، هیڤیە دووبارە هەول بدە',
        'ar': 'حدث خطأ ما، يرجى المحاولة مرة أخرى',
        'en': 'Something went wrong, please try again',
        'tr': 'Bir hata oluştu, lütfen tekrar deneyin'
      });
  String get retry => _t({
        'ku': 'دووبارە هەوڵ بدەرەوە',
        'kbd': 'دووبارە هەول بدە',
        'ar': 'أعد المحاولة',
        'en': 'Retry',
        'tr': 'Yeniden dene'
      });
  String get cancel => _t({
        'ku': 'هەڵوەشاندنەوە',
        'kbd': 'پاشگەزبوون',
        'ar': 'إلغاء',
        'en': 'Cancel',
        'tr': 'İptal'
      });
  String get save => _t({
        'ku': 'پاشەکەوت بکە',
        'kbd': 'پاراستن',
        'ar': 'حفظ',
        'en': 'Save',
        'tr': 'Kaydet'
      });
  String get done => _t({
        'ku': 'تەواوبوو',
        'kbd': 'ب دوماهی هات',
        'ar': 'تم',
        'en': 'Done',
        'tr': 'Tamamlandı'
      });
  String get next => _t({
        'ku': 'دواتر',
        'kbd': 'پاشان',
        'ar': 'التالي',
        'en': 'Next',
        'tr': 'İleri'
      });
  String get back => _t({
        'ku': 'گەڕانەوە',
        'kbd': 'زڤرین',
        'ar': 'رجوع',
        'en': 'Back',
        'tr': 'Geri'
      });
  String get skip => _t({
        'ku': 'تێپەڕ بکە',
        'kbd': 'تێپەڕاندن',
        'ar': 'تخطي',
        'en': 'Skip',
        'tr': 'Atla'
      });
  String get changeRole => _t({
        'ku': 'گۆڕینی بەش',
        'kbd': 'گوهۆڕینا بەشی',
        'ar': 'تغيير القسم',
        'en': 'Change Section',
        'tr': 'Bölüm Değiştir'
      });
  String get search => _t({
        'ku': 'گەڕان',
        'kbd': 'گەڕیان',
        'ar': 'بحث',
        'en': 'Search',
        'tr': 'Ara'
      });
  String get filter => _t({
        'ku': 'فلتەر',
        'kbd': 'فلتەر',
        'ar': 'تصفية',
        'en': 'Filter',
        'tr': 'Filtre'
      });
  String get seeAll => _t({
        'ku': 'هەموو ببینە',
        'kbd': 'هەمی دیتن',
        'ar': 'مشاهدة الكل',
        'en': 'See All',
        'tr': 'Tümünü Gör'
      });
  String get noData => _t({
        'ku': 'زانیاری نییە',
        'kbd': 'زانیاری نینن',
        'ar': 'لا توجد بيانات',
        'en': 'No data found',
        'tr': 'Veri bulunamadı'
      });
  String get submit => _t({
        'ku': 'ناردن',
        'kbd': 'فرێکرن',
        'ar': 'إرسال',
        'en': 'Submit',
        'tr': 'Gönder'
      });
  String get required => _t({
        'ku': 'پێویستە',
        'kbd': 'یا پێدڤی',
        'ar': 'مطلوب',
        'en': 'Required',
        'tr': 'Gerekli'
      });
  String get invalidEmail => _t({
        'ku': 'ئیمەیڵی نادروستە',
        'kbd': 'ئیمەیڵێ نەدرۆست',
        'ar': 'بريد إلكتروني غير صالح',
        'en': 'Invalid email address',
        'tr': 'Geçersiz e-posta'
      });
  String get passwordMinLength => _t({
        'ku': 'وشەی نهێنی دەبێت لانیکەم ٨ پیت بێت',
        'kbd': 'پەیڤا نهێنی دڤێت کێمترین ٨ پیت بن',
        'ar': 'كلمة المرور يجب أن تكون 8 أحرف على الأقل',
        'en': 'Password must be at least 8 characters',
        'tr': 'Şifre en az 8 karakter olmalı'
      });
  String get passwordsDoNotMatch => _t({
        'ku': 'وشەی نهێنییەکان جیاوازن',
        'kbd': 'پەیڤێن نهێنی وەک ئێک نینن',
        'ar': 'كلمتا المرور غير متطابقتين',
        'en': 'Passwords do not match',
        'tr': 'Şifreler eşleşmiyor'
      });
  String get registerFailed => _t({
        'ku': 'تۆمارکردن سەرکەوتوو نەبوو',
        'kbd': 'تۆمارکرن سەرکەفتی نەبوو',
        'ar': 'فشل التسجيل',
        'en': 'Registration failed',
        'tr': 'Kayıt başarısız'
      });
  String get optional => _t({
        'ku': 'ئارەزووی',
        'kbd': 'ئارەزوومەندانە',
        'ar': 'اختياري',
        'en': 'Optional',
        'tr': 'İsteğe bağlı'
      });
  String get viewDetails => _t({
        'ku': 'وردەکاریەکان ببینە',
        'kbd': 'بینینا هویرکاریان',
        'ar': 'عرض التفاصيل',
        'en': 'View Details',
        'tr': 'Detayları Gör'
      });

  // =====================

  // =====================
  // ONBOARDING
  // =====================
  String get onboardingTitle1 => _t({
        'ku': 'EduBook - IQ بدۆزەرەوە',
        'kbd': 'EduBook - IQ بدۆزەرەوە',
        'ar': 'اكتشف EduBook - IQ',
        'en': 'Discover EduBook - IQ',
        'tr': 'EduBook - IQ\'yu Keşfet'
      });
  String get onboardingDesc1 => _t({
        'ku': 'زانکۆ، قوتابخانە، و سەنتەرە پەروەردەییەکان بە ئاسانی بدۆزەرەوە',
        'kbd': 'زانکۆ، قوتابخانە، و ناوەندێن پەروەردەیێ ب ئاسانی بدۆزەرەوە',
        'ar': 'اكتشف الجامعات والمدارس والمراكز التعليمية بسهولة',
        'en': 'Discover universities, schools & educational centers easily',
        'tr': 'Üniversiteleri, okulları ve eğitim merkezlerini kolayca keşfet'
      });
  String get onboardingTitle2 => _t({
        'ku': 'مامۆستا بدۆزەرەوە',
        'kbd': 'مامۆستە بدۆزەرەوە',
        'ar': 'ابحث عن معلم',
        'en': 'Find Your Teacher',
        'tr': 'Öğretmenini Bul'
      });
  String get onboardingDesc2 => _t({
        'ku':
            'مامۆستای تایبەتی و زانکۆیی بدۆزەرەوە بۆ وردکاری و پێشڕەوی خوێندنەکەت',
        'kbd': 'مامۆستەیێن تایبەت و زانکۆیی بدۆزەرەوە بۆ پێشکەوتنا خوەندنا تە',
        'ar': 'ابحث عن معلمين خاصين وجامعيين لتطوير مهاراتك',
        'en':
            'Find private & university teachers for your educational advancement',
        'tr': 'Öğrenimi için özel ve üniversite öğretmenleri bul'
      });
  String get onboardingTitle3 => _t({
        'ku': 'CV بنێرە',
        'kbd': 'CV بنێرە',
        'ar': 'أرسل سيرتك الذاتية',
        'en': 'Share Your CV',
        'tr': 'CV\'ni Paylaş'
      });
  String get onboardingDesc3 => _t({
        'ku': 'CV خۆت دابنێ و دۆخی کارکردن بدۆزەرەوە',
        'kbd': 'CVیا خوە دابنێ و دەرفەتێن کارکرنێ بدۆزەرەوە',
        'ar': 'أضف سيرتك الذاتية وابحث عن فرص العمل',
        'en': 'Upload your CV and discover job opportunities',
        'tr': 'CV\'ni yükle ve iş fırsatlarını keşfet'
      });
  String get onboardingTitle4 => _t({
        'ku': 'زمان هەڵبژێرە',
        'kbd': 'زمان هەلبژێرە',
        'ar': 'اختر اللغة',
        'en': 'Choose Language',
        'tr': 'Dil Seç'
      });
  String get onboardingDesc4 => _t({
        'ku': 'ئەپەکە بە ٤ زمان بەردەستە: کوردی، عەرەبی، ئینگلیزی، و تورکی',
        'kbd':
            'ئەپ ب ٥ زمانا ئامادەیە: کوردی سۆرانی، کوردی بادینی، عەرەبی، ئینگلیزی، و تورکی',
        'ar': 'التطبيق متاح بـ٤ لغات: كردي، عربي، إنجليزي، وتركي',
        'en': 'The app supports 4 languages: Kurdish, Arabic, English, Turkish',
        'tr': 'Uygulama 4 dili destekler: Kürtçe, Arapça, İngilizce, Türkçe'
      });
  String get getStarted => _t({
        'ku': 'دەستپێ بکە',
        'kbd': 'دەست پێ بکە',
        'ar': 'ابدأ الآن',
        'en': 'Get Started',
        'tr': 'Başla'
      });
  String get selectLanguage => _t({
        'ku': 'زمان هەڵبژێرە',
        'kbd': 'زمان هەلبژێرە',
        'ar': 'اختر اللغة',
        'en': 'Select Language',
        'tr': 'Dil Seç'
      });

  // =====================
  // AUTH
  // =====================
  String get login => _t({
        'ku': 'چوونەژوورەوە',
        'kbd': 'کەتنا ژوورەوە',
        'ar': 'تسجيل الدخول',
        'en': 'Login',
        'tr': 'Giriş'
      });
  String get register => _t({
        'ku': 'تۆمارکردن',
        'kbd': 'تۆمارکرن',
        'ar': 'التسجيل',
        'en': 'Register',
        'tr': 'Kayıt'
      });
  String get createNewAccount => _t({
        'ku': 'هەژمارێکی نوێ دروست بکە',
        'kbd': 'هەژمارەکێ نوی چێ بکە',
        'ar': 'أنشئ حساباً جديداً',
        'en': 'Create a new account',
        'tr': 'Yeni bir hesap oluştur'
      });
  String get logout => _t({
        'ku': 'چوونەدەرەوە',
        'kbd': 'دەرکەتن',
        'ar': 'تسجيل الخروج',
        'en': 'Logout',
        'tr': 'Çıkış'
      });
  String get account => _t({
        'ku': 'هەژمار',
        'kbd': 'هەژمار',
        'ar': 'الحساب',
        'en': 'Account',
        'tr': 'Hesap'
      });
  String get deleteAccount => _t({
        'ku': 'سڕینەوەی هەژمار',
        'kbd': 'سڕینەوەی هەژمار',
        'ar': 'حذف الحساب',
        'en': 'Delete Account',
        'tr': 'Hesabı Sil'
      });
  String get deleteAccountSubtitle => _t({
        'ku': 'سڕینەوەی هەمیشەیی هەژمار و هەموو زانیارییەکانت',
        'kbd': 'سڕینەوەی هەمیشەیی هەژمار و هەموو زانیارییەکانت',
        'ar': 'حذف حسابك وجميع بياناتك نهائيًا',
        'en': 'Permanently delete your account and all your data',
        'tr': 'Hesabınızı ve tüm verilerinizi kalıcı olarak silin'
      });
  String get deleteAccountConfirmTitle => _t({
        'ku': 'دڵنیایت؟',
        'kbd': 'دڵنیایت؟',
        'ar': 'هل أنت متأكد؟',
        'en': 'Are you sure?',
        'tr': 'Emin misiniz?'
      });
  String get deleteAccountConfirmBody => _t({
        'ku': 'ئەم کردارە هەژمارەکەت و هەموو زانیارییەکانت بۆ هەمیشە دەسڕێتەوە. ناگەڕێتەوە.',
        'kbd': 'ئەم کردارە هەژمارەکەت و هەموو زانیارییەکانت بۆ هەمیشە دەسڕێتەوە. ناگەڕێتەوە.',
        'ar': 'سيؤدي هذا الإجراء إلى حذف حسابك وجميع بياناتك نهائيًا. لا يمكن التراجع عنه.',
        'en': 'This will permanently delete your account and all your data. This cannot be undone.',
        'tr': 'Bu işlem hesabınızı ve tüm verilerinizi kalıcı olarak siler. Geri alınamaz.'
      });
  String get deleteAccountSuccess => _t({
        'ku': 'هەژمارەکەت بە سەرکەوتوویی سڕایەوە.',
        'kbd': 'هەژمارەکەت بە سەرکەوتوویی سڕایەوە.',
        'ar': 'تم حذف حسابك بنجاح.',
        'en': 'Your account has been deleted.',
        'tr': 'Hesabınız silindi.'
      });
  String get deleteAccountError => _t({
        'ku': 'سڕینەوەی هەژمار سەرکەوتوو نەبوو. دووبارە هەوڵبدەرەوە.',
        'kbd': 'سڕینەوەی هەژمار سەرکەوتوو نەبوو. دووبارە هەوڵبدەرەوە.',
        'ar': 'فشل حذف الحساب. حاول مرة أخرى.',
        'en': 'Failed to delete account. Please try again.',
        'tr': 'Hesap silinemedi. Lütfen tekrar deneyin.'
      });
  String get email => _t({
        'ku': 'ئیمەیڵ',
        'kbd': 'ئیمەیل',
        'ar': 'البريد الإلكتروني',
        'en': 'Email',
        'tr': 'E-posta'
      });
  String get password => _t({
        'ku': 'وشەی نهێنی',
        'kbd': 'پەیڤا نهێنی',
        'ar': 'كلمة المرور',
        'en': 'Password',
        'tr': 'Şifre'
      });
  String get confirmPassword => _t({
        'ku': 'دووبارەکردنەوەی وشەی نهێنی',
        'kbd': 'دووبارەکرنا پەیڤا نهێنی',
        'ar': 'تأكيد كلمة المرور',
        'en': 'Confirm Password',
        'tr': 'Şifreyi Onayla'
      });
  String get name => _t(
      {'ku': 'ناو', 'kbd': 'ناڤ', 'ar': 'الاسم', 'en': 'Name', 'tr': 'İsim'});
  String get fullName => _t({
        'ku': 'ناوی تەواو',
        'kbd': 'ناڤێ تەواو',
        'ar': 'الاسم الكامل',
        'en': 'Full Name',
        'tr': 'Tam İsim'
      });
  String get phone => _t({
        'ku': 'ژمارەی مۆبایل',
        'kbd': 'ژمارا مۆبایل',
        'ar': 'رقم الهاتف',
        'en': 'Phone Number',
        'tr': 'Telefon Numarası'
      });
  String get forgotPassword => _t({
        'ku': 'وشەی نهێنیت لەبیرچووە؟',
        'kbd': 'پەیڤا نهێنی ژ بیر کریە؟',
        'ar': 'نسيت كلمة المرور؟',
        'en': 'Forgot Password?',
        'tr': 'Şifremi Unuttum?'
      });
  String get noAccount => _t({
        'ku': 'هەژمارت نییە؟',
        'kbd': 'ھەژمارا تە نینە؟',
        'ar': 'ليس لديك حساب؟',
        'en': "Don't have an account?",
        'tr': 'Hesabın yok mu?'
      });
  String get haveAccount => _t({
        'ku': 'هەژمارت هەیە؟',
        'kbd': 'ھەژمارا تە ھەیە؟',
        'ar': 'لديك حساب؟',
        'en': 'Already have an account?',
        'tr': 'Hesabın var mı?'
      });
  String get loginSuccess => _t({
        'ku': 'بەخێربێیت!',
        'kbd': 'بی خێرھاتی!',
        'ar': 'مرحباً!',
        'en': 'Welcome back!',
        'tr': 'Tekrar hoş geldin!'
      });
  String get welcomeBackTitle => _t({
        'ku': 'بەخێربێیتەوە',
        'kbd': 'ب خێر بهێی ڤە',
        'ar': 'مرحباً بعودتك',
        'en': 'Welcome Back',
        'tr': 'Tekrar Hoş Geldiniz'
      });
  String get loginToAccountSubtitle => _t({
        'ku': 'چوونەژوورەوە بۆ هەژمارەکەت',
        'kbd': 'چوونەژوورەوە بۆ هەژمارەکەت',
        'ar': 'تسجيل الدخول إلى حسابك',
        'en': 'Login to your account',
        'tr': 'Hesabınıza giriş yapın'
      });
  String get loginFailed => _t({
        'ku': 'ئیمەیڵ یان وشەی نهێنی هەڵەیە',
        'kbd': 'ئیمەیل یان پەیڤا نهێنی شاشییە',
        'ar': 'البريد أو كلمة المرور غير صحيحة',
        'en': 'Incorrect email or password',
        'tr': 'E-posta veya şifre hatalı'
      });
  String get registerSuccess => _t({
        'ku': 'هەژمارت دروست کرا!',
        'kbd': 'ھەژمارا تە درووست بوو!',
        'ar': 'تم إنشاء حسابك!',
        'en': 'Account created!',
        'tr': 'Hesabın oluşturuldu!'
      });
  String get sendOtp => _t({
        'ku': 'کۆدی پشتڕاستکردنەوە بنێرە',
        'kbd': 'کۆدا پشتراستکرنێ بنێرە',
        'ar': 'إرسال رمز التحقق',
        'en': 'Send OTP Code',
        'tr': 'Doğrulama Kodu Gönder'
      });
  String get enterOtp => _t({
        'ku': 'کۆدی نێردراو بنووسە',
        'kbd': 'کۆدا ھاتیە شاندن بنڤیسە',
        'ar': 'أدخل الرمز المرسل',
        'en': 'Enter the code sent',
        'tr': 'Gönderilen kodu gir'
      });
  String get resendOtp => _t({
        'ku': 'کۆد دووبارە بنێرە',
        'kbd': 'کۆد دووبارە بنێرە',
        'ar': 'إعادة إرسال الرمز',
        'en': 'Resend Code',
        'tr': 'Kodu Yeniden Gönder'
      });
  String get sendResetLink => _t({
        'ku': 'لینکی گۆڕینی وشەی نهێنی بنێرە',
        'kbd': 'لینکا گهۆڕینا نهێنیێ بنێرە',
        'ar': 'إرسال رابط إعادة التعيين',
        'en': 'Send Reset Link',
        'tr': 'Sıfırlama Bağlantısı Gönder'
      });
  String get resetLinkSent => _t({
        'ku':
            'لینکی گۆڕینی وشەی نهێنیمان بۆ ئیمەیڵەکەت نارد. تکایە ئیمەیڵەکەت بپشکنە و کلیک لە لینکەکە بکە.',
        'kbd':
            'لینکا گهۆڕینا نهێنیێ بۆ ئیمەیلا تە هاتە شاندن. تکایە ئیمەیلا خۆ ببینە و کلیک ل لینکێ بکە.',
        'ar':
            'أرسلنا رابط إعادة تعيين كلمة المرور إلى بريدك. يرجى فتح البريد والنقر على الرابط.',
        'en':
            'We sent a password reset link to your email. Please check your inbox and tap the link.',
        'tr':
            'Şifre sıfırlama bağlantısını e-postana gönderdik. Lütfen gelen kutunu kontrol et ve bağlantıya dokun.'
      });
  String get resetPassword => _t({
        'ku': 'وشەی نهێنی نوێ بکەرەوە',
        'kbd': 'پەیڤا نهێنی نوێ بکە',
        'ar': 'إعادة تعيين كلمة المرور',
        'en': 'Reset Password',
        'tr': 'Şifreyi Sıfırla'
      });
  String get orContinueWith => _t({
        'ku': 'یان بەردەوام بکە بە',
        'kbd': 'یان بەردەوام بکە ب',
        'ar': 'أو تابع مع',
        'en': 'Or continue with',
        'tr': 'Ya da şununla devam et'
      });

  // =====================
  // HOME
  // =====================
  String get home => _t({
        'ku': 'سەرەکی',
        'kbd': 'سەرەکی',
        'ar': 'الرئيسية',
        'en': 'Home',
        'tr': 'Ana Sayfa'
      });
  String get welcome => _t({
        'ku': 'بەخێربێی',
        'kbd': 'بخێر هاتی',
        'ar': 'مرحباً',
        'en': 'Welcome',
        'tr': 'Hoş Geldin'
      });
  String get featuredInstitutions => _t({
        'ku': 'خوێندنگاکانی تایبەت',
        'kbd': 'خویندنگەهێن تایبەت',
        'ar': 'المؤسسات المميزة',
        'en': 'Featured Institutions',
        'tr': 'Öne Çıkan Kurumlar'
      });
  String get categories => _t({
        'ku': 'جۆرەکان',
        'kbd': 'جۆر',
        'ar': 'الفئات',
        'en': 'Categories',
        'tr': 'Kategoriler'
      });
  String get statistics => _t({
        'ku': 'ئامارەکان',
        'kbd': 'ئامار',
        'ar': 'الإحصائيات',
        'en': 'Statistics',
        'tr': 'İstatistikler'
      });
  String get recentUpdates => _t({
        'ku': 'نوێترین نوێکردنەوەکان',
        'kbd': 'نوێترین نویکرنەڤە',
        'ar': 'آخر التحديثات',
        'en': 'Recent Updates',
        'tr': 'Son Güncellemeler'
      });
  String get searchHint => _t({
        'ku': 'گەڕان',
        'kbd': 'ل خویندنگەهەکێ بگەرە...',
        'ar': 'ابحث عن مؤسسة...',
        'en': 'Search institutions...',
        'tr': 'Kurum ara...'
      });
  String get goodMorning => _t({
        'ku': 'بەیانیت باش',
        'kbd': 'بەیانی باش',
        'ar': 'صباح الخير',
        'en': 'Good Morning',
        'tr': 'Günaydın'
      });
  String get goodAfternoon => _t({
        'ku': 'نیوەڕۆت باش',
        'kbd': 'نیڤرۆ باش',
        'ar': 'مساء الخير',
        'en': 'Good Afternoon',
        'tr': 'İyi Öğlenler'
      });
  String get goodEvening => _t({
        'ku': 'ئێوارەت باش',
        'kbd': 'ئێڤار باش',
        'ar': 'مساء الخير',
        'en': 'Good Evening',
        'tr': 'İyi Akşamlar'
      });

  // =====================
  // INSTITUTIONS
  // =====================
  String get institutions => _t({
        'ku': 'دامەزراوەکان',
        'kbd': 'دامەزراوەکان',
        'ar': 'المؤسسات',
        'en': 'Institutions',
        'tr': 'Kurumlar'
      });
  String get institutionTypes => _t({
        'ku': 'جۆرەکان',
        'kbd': 'جۆرێن دەزگەهان',
        'ar': 'الأنواع',
        'en': 'Types',
        'tr': 'Türler'
      });
  String get university => _t({
        'ku': 'زانکۆ',
        'kbd': 'زانکۆ',
        'ar': 'جامعة',
        'en': 'University',
        'tr': 'Üniversite'
      });
  String get institute => _t({
        'ku': 'ئینستیتیوت',
        'kbd': 'پەیمانگەهـ',
        'ar': 'معهد',
        'en': 'Institute',
        'tr': 'Enstitü'
      });
  String get school => _t({
        'ku': 'قوتابخانە',
        'kbd': 'قوتابخانە',
        'ar': 'مدرسة',
        'en': 'School',
        'tr': 'Okul'
      });
  String get kindergarten => _t({
        'ku': 'باخچەی منداڵان',
        'kbd': 'باخچێ زارۆکان',
        'ar': 'روضة',
        'en': 'Kindergarten',
        'tr': 'Anaokulu'
      });
  String get languageCenter => _t({
        'ku': 'سەنتەری زمان',
        'kbd': 'سەنتەرێ زمانان',
        'ar': 'مركز لغات',
        'en': 'Language Center',
        'tr': 'Dil Merkezi'
      });
  String get city => _t({
        'ku': 'شار',
        'kbd': 'باژێر',
        'ar': 'المدينة',
        'en': 'City',
        'tr': 'Şehir'
      });
  String get country => _t({
        'ku': 'وڵات',
        'kbd': 'وەڵات',
        'ar': 'البلد',
        'en': 'Country',
        'tr': 'Ülke'
      });
  String get address => _t({
        'ku': 'ناونیشان',
        'kbd': 'ناڤنیشان',
        'ar': 'العنوان',
        'en': 'Address',
        'tr': 'Adres'
      });
  String get website => _t({
        'ku': 'مەلپەر',
        'kbd': 'مالپەر',
        'ar': 'الموقع',
        'en': 'Website',
        'tr': 'Web Sitesi'
      });
  String get gallery => _t({
        'ku': 'گالەری',
        'kbd': 'گالەری',
        'ar': 'معرض الصور',
        'en': 'Gallery',
        'tr': 'Galeri'
      });
  String get location => _t({
        'ku': 'شوێن',
        'kbd': 'جهـ',
        'ar': 'الموقع',
        'en': 'Location',
        'tr': 'Konum'
      });
  String get socialMedia => _t({
        'ku': 'تۆرە کۆمەڵایەتییەکان',
        'kbd': 'تورێن جڤاکی',
        'ar': 'وسائل التواصل',
        'en': 'Social Media',
        'tr': 'Sosyal Medya'
      });
  String get description => _t({
        'ku': 'وەسف',
        'kbd': 'وەسف',
        'ar': 'الوصف',
        'en': 'Description',
        'tr': 'Açıklama'
      });
  String get contact => _t({
        'ku': 'پەیوەندی',
        'kbd': 'پەیوەندی',
        'ar': 'التواصل',
        'en': 'Contact',
        'tr': 'İletişim'
      });
  String get openMap => _t({
        'ku': 'نەخشە بکەرەوە',
        'kbd': 'نەخشەی ڤەکە',
        'ar': 'فتح الخريطة',
        'en': 'Open Map',
        'tr': 'Haritayı Aç'
      });
  String get addToFavorites => _t({
        'ku': 'زیادکردن بۆ دڵخوازەکان',
        'kbd': 'زێدەکرن بۆ دلخوازان',
        'ar': 'إضافة للمفضلة',
        'en': 'Add to Favorites',
        'tr': 'Favorilere Ekle'
      });
  String get removeFromFavorites => _t({
        'ku': 'لەناو دڵخوازەکان بکە',
        'kbd': 'ژ دلخوازان دەرخە',
        'ar': 'إزالة من المفضلة',
        'en': 'Remove from Favorites',
        'tr': 'Favorilerden Kaldır'
      });
  String get favorites => _t({
        'ku': 'دڵخوازەکان',
        'kbd': 'دلخواز',
        'ar': 'المفضلة',
        'en': 'Favorites',
        'tr': 'Favoriler'
      });
  String get colleges => _t({
        'ku': 'کۆلێجەکان',
        'kbd': 'کۆلێژ',
        'ar': 'الكليات',
        'en': 'Colleges',
        'tr': 'Fakülteler'
      });
  String get departments => _t({
        'ku': 'بەشەکان',
        'kbd': 'پشک',
        'ar': 'الأقسام',
        'en': 'Departments',
        'tr': 'Bölümler'
      });
  String get sortBy => _t({
        'ku': 'ریزکردنی بەپێی',
        'kbd': 'رێزکرن ل دویڤ',
        'ar': 'ترتيب حسب',
        'en': 'Sort By',
        'tr': 'Sırala'
      });
  String get newest => _t({
        'ku': 'نوێترین',
        'kbd': 'نوێترین',
        'ar': 'الأحدث',
        'en': 'Newest',
        'tr': 'En Yeni'
      });
  String get filterByCity => _t({
        'ku': 'فلتەر بەپێی شار',
        'kbd': 'فلتەرکرن ل دویڤ باژێری',
        'ar': 'تصفية حسب المدينة',
        'en': 'Filter by City',
        'tr': 'Şehre Göre Filtrele'
      });
  String get filterByType => _t({
        'ku': 'فلتەر بەپێی جۆر',
        'kbd': 'فلتەرکرن ل دویڤ جۆری',
        'ar': 'تصفية حسب النوع',
        'en': 'Filter by Type',
        'tr': 'Türe Göre Filtrele'
      });
  String get allTypes => _t({
        'ku': 'هەموو جۆرەکان',
        'kbd': 'هەمی جۆر',
        'ar': 'جميع الأنواع',
        'en': 'All Types',
        'tr': 'Tüm Türler'
      });
  String get allCities => _t({
        'ku': 'هەموو شارەکان',
        'kbd': 'هەمی باژێر',
        'ar': 'جميع المدن',
        'en': 'All Cities',
        'tr': 'Tüm Şehirler'
      });
  String get report => _t({
        'ku': 'ڕاپۆرت',
        'kbd': 'راپۆرت',
        'ar': 'إبلاغ',
        'en': 'Report',
        'tr': 'Şikayet Et'
      });
  String get addInstitution => _t({
        'ku': 'زیادکردنی دامەزراوە',
        'kbd': 'زیادکردنی دەزگەهـ',
        'ar': 'إضافة مؤسسة',
        'en': 'Add Institution',
        'tr': 'Kurum Ekle'
      });
  String get editInstitution => _t({
        'ku': 'دەستکاریکردنی دامەزراوە',
        'kbd': 'دەستکارکرنا دەزگەهـ',
        'ar': 'تعديل المؤسسة',
        'en': 'Edit Institution',
        'tr': 'Kurumu Düzenle'
      });
  String get myInstitution => _t({
        'ku': 'دامەزراوەکەم',
        'kbd': 'دەزگەها من',
        'ar': 'مؤسستي',
        'en': 'My Institution',
        'tr': 'Kurumum'
      });
  String get pendingApproval => _t({
        'ku': 'چاوەڕوانی پاساوکردن',
        'kbd': 'ل چاڤەڕوانیا پاساودانێ',
        'ar': 'بانتظار الموافقة',
        'en': 'Pending Approval',
        'tr': 'Onay Bekliyor'
      });

  // TEACHERS
  // =====================
  String get teachers => _t({
        'ku': 'مامۆستایان',
        'kbd': 'مامۆستە',
        'ar': 'المعلمون',
        'en': 'Teachers',
        'tr': 'Öğretmenler'
      });
  String get myTeachers => _t({
        'ku': 'مامۆستاکانم',
        'kbd': 'مامۆستەیێن من',
        'ar': 'معلموني',
        'en': 'My Teachers',
        'tr': 'Öğretmenlerim'
      });
  String get privateTeacher => _t({
        'ku': 'مامۆستای تایبەت',
        'kbd': 'مامۆستەیێ تایبەت',
        'ar': 'معلم خاص',
        'en': 'Private Teacher',
        'tr': 'Özel Öğretmen'
      });
  String get universityTeacher => _t({
        'ku': 'مامۆستای زانکۆ',
        'kbd': 'مامۆستەیێ زانکۆیێ',
        'ar': 'معلم جامعي',
        'en': 'University Teacher',
        'tr': 'Üniversite Öğretmeni'
      });
  String get schoolTeacher => _t({
        'ku': 'مامۆستای قوتابخانە',
        'kbd': 'مامۆستەیێ قوتابخانێ',
        'ar': 'معلم مدرسة',
        'en': 'School Teacher',
        'tr': 'Okul Öğretmeni'
      });
  String get experience => _t({
        'ku': 'ئەزموون',
        'kbd': 'ئەزموون',
        'ar': 'الخبرة',
        'en': 'Experience',
        'tr': 'Deneyim'
      });
  String get experienceYears => _t({
        'ku': 'ساڵی ئەزموون',
        'kbd': 'سالێن ئەزموونێ',
        'ar': 'سنوات الخبرة',
        'en': 'Years of Experience',
        'tr': 'Deneyim Yılı'
      });
  String get hourlyRate => _t({
        'ku': 'نرخی وانە',
        'kbd': 'نرخێ وانەکێ',
        'ar': 'سعر الدرس',
        'en': 'Lesson Price',
        'tr': 'Ders Ücreti'
      });
  String get about => _t({
        'ku': 'دەربارەی',
        'kbd': 'دەربارەی',
        'ar': 'عن',
        'en': 'About',
        'tr': 'Hakkında'
      });
  String get subject => _t({
        'ku': 'بابەت',
        'kbd': 'بابەت',
        'ar': 'المادة',
        'en': 'Subject',
        'tr': 'Ders'
      });
  String get rating => _t({
        'ku': 'هەڵسەنگاندن',
        'kbd': 'هەلسەنگاندن',
        'ar': 'التقييم',
        'en': 'Rating',
        'tr': 'Değerlendirme'
      });
  String get review => _t({
        'ku': 'هەڵسەنگاندن',
        'kbd': 'هەلسەنگاندن',
        'ar': 'تقييم',
        'en': 'Review',
        'tr': 'İnceleme'
      });
  String get reviews => _t({
        'ku': 'هەڵسەنگاندنەکان',
        'kbd': 'هەلسەنگاندن',
        'ar': 'التقييمات',
        'en': 'Reviews',
        'tr': 'İncelemeler'
      });
  String get reviewsTab => _t({
        'ku': 'هەڵسەنگاندن',
        'kbd': 'هەلسەنگاندن',
        'ar': 'التقييمات',
        'en': 'Reviews',
        'tr': 'Değerlendirmeler'
      });
  String get writeReview => _t({
        'ku': 'هەڵسەنگاندن بنووسە',
        'kbd': 'هەلسەنگاندنێ بنڤیسە',
        'ar': 'أكتب تقييماً',
        'en': 'Write a Review',
        'tr': 'Değerlendirme Yaz'
      });
  String get editReview => _t({
        'ku': 'دەستکاریکردنی هەڵسەنگاندن',
        'kbd': 'دەستکاریکرنا هەلسەنگاندنێ',
        'ar': 'تعديل التقييم',
        'en': 'Edit Review',
        'tr': 'Değerlendirmeyi Düzenle'
      });
  String get deleteReview => _t({
        'ku': 'سڕینەوەی هەڵسەنگاندن',
        'kbd': 'ژێبرنا هەلسەنگاندنێ',
        'ar': 'حذف التقييم',
        'en': 'Delete Review',
        'tr': 'Değerlendirmeyi Sil'
      });
  String get deleteReviewConfirm => _t({
        'ku': 'دڵنیایت لە سڕینەوەی ئەم هەڵسەنگاندنە؟',
        'kbd': 'تە دڤێت ڤێ هەلسەنگاندنێ بژێبی؟',
        'ar': 'هل أنت متأكد من حذف هذا التقييم؟',
        'en': 'Are you sure you want to delete this review?',
        'tr': 'Bu değerlendirmeyi silmek istediğinizden emin misiniz?'
      });
  String get delete => _t({
        'ku': 'سڕینەوە',
        'kbd': 'ژێبرن',
        'ar': 'حذف',
        'en': 'Delete',
        'tr': 'Sil'
      });
  String get yourRating => _t({
        'ku': 'هەڵسەنگاندنی تۆ',
        'kbd': 'هەلسەنگاندنا تە',
        'ar': 'تقييمك',
        'en': 'Your Rating',
        'tr': 'Puanınız'
      });
  String get shareYourExperience => _t({
        'ku': 'ڕا و سەرنجی خۆت بنووسە لێرە...',
        'kbd': 'ڕا و بۆچوونا خوە بنڤیسە ل ڤێرێ...',
        'ar': 'شارك تجربتك وملاحظاتك هنا...',
        'en': 'Share your experience and thoughts here...',
        'tr': 'Deneyiminizi ve düşüncelerinizi buraya yazın...'
      });
  String get noReviewsYet => _t({
        'ku': 'هیچ هەڵسەنگاندنێک تۆمار نەکراوە',
        'kbd': 'چ هەلسەنگاندن نەهاتینە تۆمارکرن',
        'ar': 'لا توجد تقييمات بعد',
        'en': 'No reviews yet',
        'tr': 'Henüz değerlendirme yok'
      });
  String get beFirstToReview => _t({
        'ku': 'یەکەم کەس بە کە ڕا و بۆچوونی خۆت بنووسیت!',
        'kbd': 'ئێکەمین کەس بە کو بۆچوونا خوە بنڤیسی!',
        'ar': 'كن أول من يشارك تقييمه ورأيه!',
        'en': 'Be the first to share your review!',
        'tr': 'İlk değerlendirmeyi yapan siz olun!'
      });
  String get reviewSubmittedSuccess => _t({
        'ku': 'هەڵسەنگاندنەکەت بە سەرکەوتوویی تۆمارکرا',
        'kbd': 'هەلسەنگاندنا تە ب سەرکەفتی هاتە تۆمارکرن',
        'ar': 'تم تسجيل تقييمك بنجاح',
        'en': 'Your review was submitted successfully',
        'tr': 'Değerlendirmeniz başarıyla kaydedildi'
      });
  String get reviewDeletedSuccess => _t({
        'ku': 'هەڵسەنگاندنەکە سڕایەوە',
        'kbd': 'هەلسەنگاندن هاتە ژێبرن',
        'ar': 'تم حذف التقييم',
        'en': 'Review deleted',
        'tr': 'Değerlendirme silindi'
      });
  String get loginToReview => _t({
        'ku': 'بۆ هەڵسەنگاندن، تکایە سەرەتا بچۆ ژوورەوە',
        'kbd': 'بۆ هەلسەنگاندنێ، هیڤیە پێشتر بچیە ژوورڤە',
        'ar': 'لإضافة تقييم، يرجى تسجيل الدخول أولاً',
        'en': 'Please log in first to submit a review',
        'tr': 'Değerlendirme yapmak için lütfen önce giriş yapın'
      });
  String get bookTeacher => _t({
        'ku': 'مامۆستا بووکبکە',
        'kbd': 'ژڤانەکی ل دەف مامۆستەی بگرە',
        'ar': 'احجز معلم',
        'en': 'Book Teacher',
        'tr': 'Öğretmen Rezerve Et'
      });
  String get contactTeacher => _t({
        'ku': 'پەیوەندی بکە',
        'kbd': 'پەیوەندیێ بکە',
        'ar': 'تواصل معه',
        'en': 'Contact',
        'tr': 'İletişim Kur'
      });
  String get registerAsTeacher => _t({
        'ku': 'وەک مامۆستا تۆمار بکە',
        'kbd': 'وەک مامۆستە تۆمار بکە',
        'ar': 'سجل كمعلم',
        'en': 'Register as Teacher',
        'tr': 'Öğretmen Olarak Kayıt'
      });
  String get biography => _t({
        'ku': 'بیۆگرافی',
        'kbd': 'ژیاننامە',
        'ar': 'السيرة الذاتية المختصرة',
        'en': 'Biography',
        'tr': 'Biyografi'
      });
  String get subjects => _t({
        'ku': 'بابەتەکان',
        'kbd': 'بابەت',
        'ar': 'المواد',
        'en': 'Subjects',
        'tr': 'Dersler'
      });

  // =====================
  // CV
  // =====================
  String get cvBank => _t({
        'ku': 'سیڤیەکان',
        'kbd': 'سیڤی',
        'ar': 'السیرة الذاتیة',
        'en': 'CV Bank',
        'tr': 'CV Bankası'
      });
  String get uploadCv => _t({
        'ku': 'CV بنێرە',
        'kbd': 'CVیا خوە بنێرە',
        'ar': 'رفع السيرة الذاتية',
        'en': 'Upload CV',
        'tr': 'CV Yükle'
      });
  String get createCv => _t({
        'ku': 'CV دروست بکە',
        'kbd': 'CVیەکێ درووست بکە',
        'ar': 'إنشاء سيرة ذاتية',
        'en': 'Create CV',
        'tr': 'CV Oluştur'
      });
  String get jobOpportunities => _t({
        'ku': 'دۆخی کار',
        'kbd': 'دەرفەتێن کاری',
        'ar': 'فرص العمل',
        'en': 'Job Opportunities',
        'tr': 'İş Fırsatları'
      });
  String get applyNow => _t({
        'ku': 'ئێستا داواکاری بکە',
        'kbd': 'نوکە داخوازیێ پێشکێش بکە',
        'ar': 'قدم الآن',
        'en': 'Apply Now',
        'tr': 'Şimdi Başvur'
      });
  String get education => _t({
        'ku': 'خوێندن',
        'kbd': 'خوەندن',
        'ar': 'التعليم',
        'en': 'Education',
        'tr': 'Eğitim'
      });
  String get skills => _t({
        'ku': 'تواناکان',
        'kbd': 'شیان',
        'ar': 'المهارات',
        'en': 'Skills',
        'tr': 'Beceriler'
      });
  String get graduationYear => _t({
        'ku': 'ساڵی دەرچوون',
        'kbd': 'سالا دەرچوونێ',
        'ar': 'سنة التخرج',
        'en': 'Graduation Year',
        'tr': 'Mezuniyet Yılı'
      });
  String get field => _t({
        'ku': 'بوار',
        'kbd': 'بوار',
        'ar': 'التخصص',
        'en': 'Field of Study',
        'tr': 'Çalışma Alanı'
      });
  String get educationLevel => _t({
        'ku': 'ئاستی خوێندن',
        'kbd': 'ئاستێ خوەندنێ',
        'ar': 'المستوى التعليمي',
        'en': 'Education Level',
        'tr': 'Eğitim Seviyesi'
      });
  String get age => _t({
        'ku': 'تەمەن',
        'kbd': 'ژیێ تە',
        'ar': 'العمر',
        'en': 'Age',
        'tr': 'Yaş'
      });
  String get gender => _t({
        'ku': 'رەگەز',
        'kbd': 'رەگەز',
        'ar': 'الجنس',
        'en': 'Gender',
        'tr': 'Cinsiyet'
      });
  String get male =>
      _t({'ku': 'نێر', 'kbd': 'نێر', 'ar': 'ذكر', 'en': 'Male', 'tr': 'Erkek'});
  String get female => _t(
      {'ku': 'مێ', 'kbd': 'مێ', 'ar': 'أنثى', 'en': 'Female', 'tr': 'Kadın'});
  String get notes => _t({
        'ku': 'تێبینی',
        'kbd': 'تێبینی',
        'ar': 'ملاحظات',
        'en': 'Notes',
        'tr': 'Notlar'
      });
  String get saveCv => _t({
        'ku': 'CV پاشەکەوت بکە',
        'kbd': 'CVیا خوە بپارێزە',
        'ar': 'حفظ السيرة الذاتية',
        'en': 'Save CV',
        'tr': 'CV Kaydet'
      });
  // CV FORM — labels, hints, validation, success
  String get personalInfo => _t({
        'ku': 'زانیاری کەسی',
        'kbd': 'زانیارییێن کەسی',
        'ar': 'المعلومات الشخصية',
        'en': 'Personal Info',
        'tr': 'Kişisel Bilgiler'
      });
  String get experienceAndSkills => _t({
        'ku': 'ئەزموون و تواناکان',
        'kbd': 'ئەزموون و توانا',
        'ar': 'الخبرة والمهارات',
        'en': 'Experience & Skills',
        'tr': 'Deneyim ve Beceriler'
      });
  String get phoneNumber => _t({
        'ku': 'ژمارەی مۆبایل',
        'kbd': 'ژمارەی مۆبایل',
        'ar': 'رقم الهاتف',
        'en': 'Phone Number',
        'tr': 'Telefon Numarası'
      });
  String get emailField => _t({
        'ku': 'ئیمەیڵ',
        'kbd': 'ئیمەیڵ',
        'ar': 'البريد الإلكتروني',
        'en': 'Email',
        'tr': 'E-posta'
      });
  String get cityField => _t({
        'ku': 'شار / شوێنی نیشتەجێبوون',
        'kbd': 'شار / شوێنی نیشتەجێبوون',
        'ar': 'المدينة / مكان الإقامة',
        'en': 'City / Residence',
        'tr': 'Şehir / İkametgah'
      });
  String get fieldOfStudy => _t({
        'ku': 'پسپۆڕی / بەشی خوێندن',
        'kbd': 'پسپۆری / بەشی خوەندن',
        'ar': 'التخصص / قسم الدراسة',
        'en': 'Specialization / Field',
        'tr': 'Uzmanlık / Bölüm'
      });
  String get workExperience => _t({
        'ku': 'ئەزموونی کار',
        'kbd': 'ئەزموونی کار',
        'ar': 'الخبرة العملية',
        'en': 'Work Experience',
        'tr': 'İş Deneyimi'
      });
  String get previousWorkplace => _t({
        'ku': 'شوێنی کارکردنی پێشوو (ئارەزوومەندانە)',
        'kbd': 'شوێنی کارکردنی پێشوو (ئارەزوومەندانە)',
        'ar': 'مكان العمل السابق (اختياري)',
        'en': 'Previous Workplace (Optional)',
        'tr': 'Önceki İşyeri (İsteğe Bağlı)'
      });
  String get skillsAndExpertise => _t({
        'ku': 'تواناکان / شارەزاییەکان',
        'kbd': 'توانا / شارەزایی',
        'ar': 'المهارات / الخبرات',
        'en': 'Skills / Expertise',
        'tr': 'Beceriler / Uzmanlıklar'
      });
  String get add => _t({
        'ku': 'زیادکردن',
        'kbd': 'زیادکردن',
        'ar': 'إضافة',
        'en': 'Add',
        'tr': 'Ekle'
      });
  String get noSkillsAdded => _t({
        'ku': 'هیچ توانایەک زیاد نەکراوە',
        'kbd': 'هیچ توانایەک زیاد نەکراوە',
        'ar': 'لم تتم إضافة مهارات',
        'en': 'No skills added',
        'tr': 'Beceri eklenmedi'
      });
  String get noLanguagesAdded => _t({
        'ku': 'هیچ زمانێک زیاد نەکراوە',
        'kbd': 'هیچ زمانێک زیاد نەکراوە',
        'ar': 'لم تتم إضافة لغات',
        'en': 'No languages added',
        'tr': 'Dil eklenmedi'
      });
  String get languageName => _t({
        'ku': 'ناوی زمان',
        'kbd': 'ناوی زمان',
        'ar': 'اسم اللغة',
        'en': 'Language Name',
        'tr': 'Dil Adı'
      });
  String get socialLink => _t({
        'ku': 'LinkedIn / Facebook (ئارەزوومەندانە)',
        'kbd': 'LinkedIn / Facebook (ئارەزوومەندانە)',
        'ar': 'LinkedIn / Facebook (اختياري)',
        'en': 'LinkedIn / Facebook (Optional)',
        'tr': 'LinkedIn / Facebook (İsteğe Bağlı)'
      });
  String get additionalNotes => _t({
        'ku': 'تێبینی زیاتر',
        'kbd': 'تێبینیێن زیاتر',
        'ar': 'ملاحظات إضافية',
        'en': 'Additional Notes',
        'tr': 'Ek Notlar'
      });
  String get profilePhoto => _t({
        'ku': 'وێنەی کەسی',
        'kbd': 'وێنەی کەسی',
        'ar': 'الصورة الشخصية',
        'en': 'Profile Photo',
        'tr': 'Profil Fotoğrafı'
      });
  String get hintFullName => _t({
        'ku': 'وەک: ئیبراهیم ئیسماعیل محەمەد',
        'kbd': 'وەک: ئیبراهیم ئیسماعیل محەمەد',
        'ar': 'مثال: أحمد محمد علي',
        'en': 'e.g. John Michael Smith',
        'tr': 'ör: Ahmet Mehmet Yılmaz'
      });
  String get hintPhone => _t({
        'ku': 'وەک: 0750xxxxxxx',
        'kbd': 'وەک: 0750xxxxxxx',
        'ar': 'مثال: 0750xxxxxxx',
        'en': 'e.g. 0750xxxxxxx',
        'tr': 'ör: 0750xxxxxxx'
      });
  String get hintAge => _t({
        'ku': 'وەک: 25',
        'kbd': 'وەک: 25',
        'ar': 'مثال: 25',
        'en': 'e.g. 25',
        'tr': 'ör: 25'
      });
  String get hintFieldOfStudy => _t({
        'ku': 'وەک: زانستی کۆمپیوتەر',
        'kbd': 'وەک: زانستی کۆمپیوتەر',
        'ar': 'مثال: علوم الحاسوب',
        'en': 'e.g. Computer Science',
        'tr': 'ör: Bilgisayar Bilimi'
      });
  String get hintGradYear => _t({
        'ku': 'وەک: 2024',
        'kbd': 'وەک: 2024',
        'ar': 'مثال: 2024',
        'en': 'e.g. 2024',
        'tr': 'ör: 2024'
      });
  String get hintWorkExp => _t({
        'ku': 'کورتەیەک لە ئەزموونی کار',
        'kbd': 'کورتەیەک لە ئەزموونی کار',
        'ar': 'نبذة عن خبرتك العملية',
        'en': 'Brief summary of work experience',
        'tr': 'İş deneyiminizin kısa özeti'
      });
  String get hintPrevWork => _t({
        'ku': 'وەک: کۆمپانیای ئاسیاسێڵ، نەخۆشخانەی...',
        'kbd': 'وەک: کۆمپانیای ئاسیاسێڵ، نەخۆشخانەی...',
        'ar': 'مثال: شركة آسياسيل، مستشفى...',
        'en': 'e.g. Asiacell, Hospital...',
        'tr': 'ör: Asiacell, Hastane...'
      });
  String get hintSkill => _t({
        'ku': 'وەک: گرافیک دیزاین، مایکرۆسۆفت وۆرد...',
        'kbd': 'وەک: گرافیک دیزاین، مایکرۆسۆفت وۆرد...',
        'ar': 'مثال: تصميم جرافيك، مايكروسوفت وورد...',
        'en': 'e.g. Graphic Design, MS Word...',
        'tr': 'ör: Grafik Tasarım, MS Word...'
      });
  String get hintSocialLink => _t({
        'ku': 'لینکی هەژمارەکەت لێرە دابنێ',
        'kbd': 'لینکی هەژمارەکەت لێرە دابنێ',
        'ar': 'ضع رابط حسابك هنا',
        'en': 'Paste your profile link here',
        'tr': 'Profil bağlantınızı buraya yapıştırın'
      });
  String get hintNotes => _t({
        'ku': 'هەر زانیارییەکی تر کە بە پێویستی دەزانیت...',
        'kbd': 'هەر زانیارییەکی تر کە بە پێویستی دەزانیت...',
        'ar': 'أي معلومات إضافية تراها مهمة...',
        'en': 'Any additional information you find relevant...',
        'tr': 'Uygun bulduğunuz herhangi bir ek bilgi...'
      });
  String get hintCity => _t({
        'ku': 'وەک: هەولێر، سلێمانی...',
        'kbd': 'وەک: هەولێر، سلێمانی...',
        'ar': 'مثال: أربيل، السليمانية...',
        'en': 'e.g. Erbil, Sulaymaniyah...',
        'tr': 'ör: Erbil, Süleymaniye...'
      });
  String get requiredField => _t({
        'ku': 'تکایە ئەم خانەیە پڕبکەرەوە',
        'kbd': 'تکایە ئەم خانەیە پڕبکەرەوە',
        'ar': 'هذا الحقل مطلوب',
        'en': 'This field is required',
        'tr': 'Bu alan gereklidir'
      });
  String get requiredCity => _t({
        'ku': 'تکایە شار دیاری بکە',
        'kbd': 'تکایە شار دیاری بکە',
        'ar': 'يرجى تحديد المدينة',
        'en': 'Please select a city',
        'tr': 'Lütfen bir şehir seçin'
      });
  String get requiredGender => _t({
        'ku': 'تکایە ڕەگەز دیاری بکە',
        'kbd': 'تکایە ڕەگەز دیاری بکە',
        'ar': 'يرجى تحديد الجنس',
        'en': 'Please select gender',
        'tr': 'Lütfen cinsiyet seçin'
      });
  String get requiredEducation => _t({
        'ku': 'تکایە ئاستی خوێندن دیاری بکە',
        'kbd': 'تکایە ئاستی خوێندن دیاری بکە',
        'ar': 'يرجى تحديد المستوى التعليمي',
        'en': 'Please select education level',
        'tr': 'Lütfen eğitim seviyesi seçin'
      });
  String get invalidPhone => _t({
        'ku': 'ژمارەی مۆبایل دروست نییە',
        'kbd': 'ژمارەی مۆبایل دروست نییە',
        'ar': 'رقم الهاتف غير صحيح',
        'en': 'Invalid phone number',
        'tr': 'Geçersiz telefon numarası'
      });
  String get invalidIraqiPhone => _t({
        'ku': 'تەنها ژمارەی کورەک، ئاسیاسێل و زەین (964+) وەردەگیرێت',
        'kbd': 'تنێ ژمارا کۆرەک، ئاسیاسێل و زەین (964+) تێتە وەرگرتن',
        'ar': 'يُقبل فقط رقم كورك أو آسياسيل أو زين (964+)',
        'en': 'Only Korek, Asiacell or Zain numbers (+964) are accepted',
        'tr': 'Yalnızca Korek, Asiacell veya Zain numaraları (+964) kabul edilir'
      });
  String get requiredAge => _t({
        'ku': 'تکایە تەمەن بنووسە',
        'kbd': 'تکایە تەمەن بنووسە',
        'ar': 'يرجى إدخال العمر',
        'en': 'Please enter age',
        'tr': 'Lütfen yaş girin'
      });
  String get invalidAge => _t({
        'ku': 'تەمەن دروست نییە',
        'kbd': 'تەمەن دروست نییە',
        'ar': 'العمر غير صحيح',
        'en': 'Invalid age',
        'tr': 'Geçersiz yaş'
      });
  String get requiredEmail => _t({
        'ku': 'تکایە ئیمەیڵ بنووسە',
        'kbd': 'تکایە ئیمەیڵ بنووسە',
        'ar': 'يرجى إدخال البريد الإلكتروني',
        'en': 'Please enter email',
        'tr': 'Lütfen e-posta girin'
      });
  String get requiredPassword => _t({
        'ku': 'تکایە وشەی نهێنی بنووسە',
        'kbd': 'تکایە پەیڤا نهێنی بنڤیسە',
        'ar': 'يرجى إدخال كلمة المرور',
        'en': 'Please enter password',
        'tr': 'Lütfen şifre girin'
      });
  String get requiredName => _t({
        'ku': 'تکایە ناو بنووسە',
        'kbd': 'تکایە ناڤ بنڤیسە',
        'ar': 'يرجى إدخال الاسم',
        'en': 'Please enter name',
        'tr': 'Lütfen isim girin'
      });
  String get requiredPhone => _t({
        'ku': 'تکایە ژمارەی مۆبایل بنووسە',
        'kbd': 'تکایە ژمارا مۆبایلی بنڤیسە',
        'ar': 'يرجى إدخال رقم الهاتف',
        'en': 'Please enter phone number',
        'tr': 'Lütfen telefon numarası girin'
      });
  String get requiredConfirmPassword => _t({
        'ku': 'تکایە وشەی نهێنی دووبارە بکەرەوە',
        'kbd': 'تکایە پەیڤا نهێنی دووبارە بکە',
        'ar': 'يرجى تأكيد كلمة المرور',
        'en': 'Please confirm password',
        'tr': 'Lütfen şifreyi onaylayın'
      });
  String get passwordResetSuccess => _t({
        'ku': 'تۆمارکردنی وشەی نهێنی نوێ سەرکەوتوو بوو',
        'kbd': 'تۆمارکرنا پەیڤا نهێنی یا نوێ سەرکەفتی بوو',
        'ar': 'تم تعيين كلمة المرور الجديدة بنجاح',
        'en': 'New password set successfully',
        'tr': 'Yeni şifre başarıyla ayarlandı'
      });
  String get privacyPolicyTitle => _t({
        'ku': 'سیاسەتی بەکارهێنان',
        'kbd': 'سیاسەتا بکارئینانێ',
        'ar': 'سياسة الخصوصية',
        'en': 'Terms of Use',
        'tr': 'Gizlilik Politikası'
      });
  String get privacySec1Title => _t({
        'ku': '١. کۆکردنەوەی زانیاری',
        'kbd': '١. کۆمکرنا پێزانینان',
        'ar': '١. جمع المعلومات',
        'en': '1. Information Collection',
        'tr': '1. Bilgi Toplama'
      });
  String get privacySec1Body => _t({
        'ku':
            'ئێمە هەندێک زانیاری کەسی کۆدەکەینەوە وەک ناو، ئیمەیڵ، و ژمارەی مۆبایل کاتێک هەژمار دروست دەکەیت بۆ ئەوەی خزمەتگوزارییەکانمان پێشکەش بکەین.',
        'kbd':
            'ئەم هندەک پێزانینێن کەسی کۆمدکەین وەک ناڤ، ئیمەیڵ، و ژمارەیا مۆبایلێ دەمێ هەژمارێ دروست دکەی بۆ پێشکێشکرنا خزمەتگوزارییان.',
        'ar':
            'نقوم بجمع بعض المعلومات الشخصية مثل الاسم والبريد الإلكتروني ورقم الهاتف عند إنشاء حساب لتقديم خدماتنا.',
        'en':
            'We collect some personal information such as name, email, and phone number when you create an account to provide our services.',
        'tr':
            'Hizmetlerimizi sunmak için hesap oluşturduğunuzda isim, e-posta ve telefon numarası gibi bazı kişisel bilgileri toplarız.'
      });
  String get privacySec2Title => _t({
        'ku': '٢. چۆنیەتی بەکارهێنانی زانیاری',
        'kbd': '٢. چەوانیا بکارئینانا پێزانینان',
        'ar': '٢. كيفية استخدام المعلومات',
        'en': '2. How We Use Information',
        'tr': '2. Bilgileri Nasıl Kullanıyoruz'
      });
  String get privacySec2Body => _t({
        'ku':
            'زانیارییەکانت بەکاردێن بۆ باشترکردنی خزمەتگوزارییەکان، ناردنی ئاگادارکردنەوەی گرنگ، و دڵنیابوونەوە لە ناسنامەی بەکارهێنەر.',
        'kbd':
            'پێزانینێن تە بکاردئین بۆ باشترکرنا خزمەتگوزارییان، هنارتنا ئاگەهدارکرنێن گرنگ، و پشتڕاستبوون ژ ناسنامەیا بکارئینەری.',
        'ar':
            'تُستخدم معلوماتك لتحسين الخدمات وإرسال الإشعارات الهامة والتحقق من هوية المستخدم.',
        'en':
            'Your information is used to improve services, send important notifications, and verify user identity.',
        'tr':
            'Bilgileriniz hizmetleri iyileştirmek, önemli bildirimler göndermek ve kullanıcı kimliğini doğrulamak için kullanılır.'
      });
  String get privacySec3Title => _t({
        'ku': '٣. پاراستنی زانیاری',
        'kbd': '٣. پاراستنا پێزانینان',
        'ar': '٣. حماية المعلومات',
        'en': '3. Information Protection',
        'tr': '3. Bilgi Koruma'
      });
  String get privacySec3Body => _t({
        'ku':
            'ئێمە ڕێکاری توندی تەکنیکی دەگرینەبەر بۆ پاراستنی زانیارییەکانت لە هەر دەستوەردانێکی دەرەکی یان دزەپێکردن.',
        'kbd':
            'ئەم ڕێکارێن توند یێن تەکنیکی دگرینەبەر بۆ پاراستنا پێزانینێن تە ژ هەر دەستوەردانەکا دەرەکی یان دزەپێکرنێ.',
        'ar':
            'نتخذ تدابير فنية صارمة لحماية معلوماتك من أي تدخل خارجي أو تسريب.',
        'en':
            'We take strict technical measures to protect your information from any external interference or leakage.',
        'tr':
            'Bilgilerinizi herhangi bir dış müdahale veya sızıntıdan korumak için sıkı teknik önlemler alıyoruz.'
      });
  String get privacySec4Title => _t({
        'ku': '٤. مافەکانی بەکارهێنەر',
        'kbd': '٤. مافێن بکارئینەری',
        'ar': '٤. حقوق المستخدم',
        'en': '4. User Rights',
        'tr': '4. Kullanıcı Hakları'
      });
  String get privacySec4Body => _t({
        'ku':
            'تۆ مافی ئەوەت هەیە داوای سڕینەوەی هەژمارەکەت و هەموو زانیارییەکانت بکەیت لە هەر کاتێکدا بێت لە ڕێگەی ڕێکخستنەکانەوە.',
        'kbd':
            'تە ماف هەیە داخوازا ژێبرنا هەژمارا خۆ و هەموو پێزانینێن خۆ بکەی د هەر دەمەکێ دا بیت ب ڕێکا ڕێکخستنان.',
        'ar':
            'لديك الحق في طلب حذف حسابك وجميع معلوماتك في أي وقت من خلال الإعدادات.',
        'en':
            'You have the right to request the deletion of your account and all your information at any time through the settings.',
        'tr':
            'Ayarlar aracılığıyla hesabınızın ve tüm bilgilerinizin silinmesini istediğiniz zaman talep etme hakkına sahipsiniz.'
      });
  String get privacyLastUpdate => _t({
        'ku': 'دواهەمین نوێکردنەوە: ٩/٥/٢٠٢٤',
        'kbd': 'دوماهیک نویکرن: ٩/٥/٢٠٢٤',
        'ar': 'آخر تحديث: ٩/٥/٢٠٢٤',
        'en': 'Last update: 5/9/2024',
        'tr': 'Son güncelleme: 09/05/2024'
      });

  String get certificateOf => _t({
        'ku': 'بڕوانامەی',
        'kbd': 'باوەرنامەیا',
        'ar': 'شهادة',
        'en': 'Certificate of',
        'tr': 'Sertifikası'
      });
  String get cityResidence => _t({
        'ku': 'شار / شوێنی نیشتەجێبوون',
        'kbd': 'باژێر / جهێ ئاکنجیبوونێ',
        'ar': 'المدينة / مكان الإقامة',
        'en': 'City / Residence',
        'tr': 'Şehir / İkametgah'
      });
  String get educationLevelTitle => _t({
        'ku': 'ئاستی خوێندن',
        'kbd': 'ئاستێ خواندنێ',
        'ar': 'المستوى التعليمي',
        'en': 'Education Level',
        'tr': 'Eğitim Seviyesi'
      });
  List<String> get educationLevels => [
        _t({
          'ku': 'خوێندنی ناوەندی',
          'kbd': 'خواندنا ناڤنجی',
          'ar': 'المدرسة المتوسطة',
          'en': 'Middle School',
          'tr': 'Ortaokul'
        }),
        _t({
          'ku': 'ئامادەیی',
          'kbd': 'ئامادەیی',
          'ar': 'المدرسة الإعدادية',
          'en': 'High School',
          'tr': 'Lise'
        }),
        _t({
          'ku': 'دیپلۆم',
          'kbd': 'دبلۆم',
          'ar': 'دبلوم',
          'en': 'Diploma',
          'tr': 'Diploma'
        }),
        _t({
          'ku': 'بکالۆریۆس',
          'kbd': 'بکالۆریۆس',
          'ar': 'بكالوريوس',
          'en': 'Bachelor\'s',
          'tr': 'Lisans'
        }),
        _t({
          'ku': 'ماستەر',
          'kbd': 'ماستەر',
          'ar': 'ماجستير',
          'en': 'Master\'s',
          'tr': 'Yüksek Lisans'
        }),
        _t({
          'ku': 'دکتۆرا',
          'kbd': 'دکتۆرا',
          'ar': 'دكتوراه',
          'en': 'PhD',
          'tr': 'Doktora'
        })
      ];
  List<String> get languageLevels => [
        _t({
          'ku': 'سەرەتایی',
          'kbd': 'سەرەتایی',
          'ar': 'مبتدئ',
          'en': 'Beginner',
          'tr': 'Başlangıç'
        }),
        _t({
          'ku': 'مامناوەند',
          'kbd': 'مامناڤەند',
          'ar': 'متوسط',
          'en': 'Intermediate',
          'tr': 'Orta'
        }),
        _t({'ku': 'باش', 'kbd': 'باش', 'ar': 'جيد', 'en': 'Good', 'tr': 'İyi'}),
        _t({
          'ku': 'زۆرباش',
          'kbd': 'گەلەک باش',
          'ar': 'جيد جداً',
          'en': 'Very Good',
          'tr': 'Çok İyi'
        })
      ];
  String get invalidYear => _t({
        'ku': 'تکایە ساڵێکی دروست بنووسە',
        'kbd': 'تکایە ساڵێکی دروست بنووسە',
        'ar': 'يرجى إدخال سنة صحيحة',
        'en': 'Please enter a valid year',
        'tr': 'Lütfen geçerli bir yıl girin'
      });
  String get submitCv => _t({
        'ku': 'CV ـەکەت بنێرە',
        'kbd': 'CVیا خوە بنێرە',
        'ar': 'أرسل سيرتك الذاتية',
        'en': 'Submit Your CV',
        'tr': 'CV\'nizi Gönderin'
      });
  String get cvSubmitTitle => _t({
        'ku': 'CV ـەکەت بە سەرکەوتوویی تۆمارکرا',
        'kbd': 'CVیا تە bi serketî tomar bû',
        'ar': 'تم تسجيل سيرتك الذاتية بنجاح',
        'en': 'Your CV was submitted successfully',
        'tr': 'CV\'niz başarıyla kaydedildi'
      });
  String get cvSubmitDesc => _t({
        'ku':
            'زانیارییەکانت بە سەرکەوتوویی نێردران. چاوەروان بە تا بڵاو دەکرێتەوە',
        'kbd': 'زانیارییەکانت نێردران، چاوەروان بە',
        'ar': 'تم إرسال معلوماتك بنجاح. انتظر حتى يتم نشرها',
        'en':
            'Your information was sent successfully. Wait until it is published.',
        'tr': 'Bilgileriniz başarıyla gönderildi. Yayınlanana kadar bekleyin.'
      });
  String get ok => _t(
      {'ku': 'باشە', 'kbd': 'باشە', 'ar': 'حسناً', 'en': 'OK', 'tr': 'Tamam'});
  // TEACHER PROFILE
  String get introVideo => _t({
        'ku': 'ڤیدیۆی پێناسەکردن',
        'kbd': 'ڤیدیۆی پێناسەکردن',
        'ar': 'فيديو تعريفي',
        'en': 'Intro Video',
        'tr': 'Tanıtım Videosu'
      });
  String get facebook => _t({
        'ku': 'فەیسبوک',
        'kbd': 'فەیسبوک',
        'ar': 'فيسبوك',
        'en': 'Facebook',
        'tr': 'Facebook'
      });
  String get facebookProfile => _t({
        'ku': 'پرۆفایلی فەیسبوک',
        'kbd': 'پرۆفایلی فەیسبوک',
        'ar': 'الملف الشخصي على فيسبوك',
        'en': 'Facebook Profile',
        'tr': 'Facebook Profili'
      });

  // =====================
  // NOTIFICATIONS
  // =====================
  String get notifications => _t({
        'ku': 'ئاگادارکردنەوەکان',
        'kbd': 'ئاگەداری',
        'ar': 'الإشعارات',
        'en': 'Notifications',
        'tr': 'Bildirimler'
      });
  String get noNotifications => _t({
        'ku': 'ئاگادارکردنەوە نییە',
        'kbd': 'چ ئاگەداری نینن',
        'ar': 'لا توجد إشعارات',
        'en': 'No notifications',
        'tr': 'Bildirim yok'
      });
  String get markAllRead => _t({
        'ku': 'هەموو وەک خوێندراو دیاریبکە',
        'kbd': 'هەمییان وەک خواندی نیشان بدە',
        'ar': 'تحديد الكل كمقروء',
        'en': 'Mark All Read',
        'tr': 'Tümünü Okundu İşaretle'
      });
  String get newInstitution => _t({
        'ku': 'خوێندنگای نوێ',
        'kbd': 'خویندنگەها نوێ',
        'ar': 'مؤسسة جديدة',
        'en': 'New Institution',
        'tr': 'Yeni Kurum'
      });

  // =====================
  // PROFILE & SETTINGS
  // =====================
  String get profile => _t({
        'ku': 'پرۆفایل',
        'kbd': 'پرۆفایل',
        'ar': 'الملف الشخصي',
        'en': 'Profile',
        'tr': 'Profil'
      });
  String get settings => _t({
        'ku': 'ڕێکخستنەکان',
        'kbd': 'ڕێکخستن',
        'ar': 'الإعدادات',
        'en': 'Settings',
        'tr': 'Ayarlar'
      });
  String get editProfile => _t({
        'ku': 'پرۆفایل دەستکاری بکە',
        'kbd': 'دەستکاریا پرۆفایلی بکە',
        'ar': 'تعديل الملف',
        'en': 'Edit Profile',
        'tr': 'Profili Düzenle'
      });
  String get language => _t({
        'ku': 'زمان',
        'kbd': 'زمان',
        'ar': 'اللغة',
        'en': 'Language',
        'tr': 'Dil'
      });
  // Language names — localized by current UI language
  String get langNameKu => _t({
        'ku': 'کوردی (سۆرانی)',
        'kbd': 'کوردی (سۆرانی)',
        'ar': 'الكردية (السورانية)',
        'en': 'Kurdish (Sorani)',
        'tr': 'Kürtçe (Sorani)'
      });
  String get langNameKbd => _t({
        'ku': 'کوردی (بادینی)',
        'kbd': 'کوردی (بادینی)',
        'ar': 'الكردية (البادينية)',
        'en': 'Kurdish (Badini)',
        'tr': 'Kürtçe (Badini)'
      });
  String get langNameAr => _t({
        'ku': 'عەرەبی',
        'kbd': 'عەرەبی',
        'ar': 'العربية',
        'en': 'Arabic',
        'tr': 'Arapça'
      });
  String get langNameEn => _t({
        'ku': 'ئینگلیزی',
        'kbd': 'ئینگلیزی',
        'ar': 'الإنجليزية',
        'en': 'English',
        'tr': 'İngilizce'
      });
  String localizedLangName(String code) {
    switch (code) {
      case 'ku':
        return langNameKu;
      case 'kbd':
        return langNameKbd;
      case 'ar':
        return langNameAr;
      case 'en':
        return langNameEn;
      default:
        return code;
    }
  }

  String get darkMode => _t({
        'ku': 'دۆخی تاریک',
        'kbd': 'مۆدێ تاریک',
        'ar': 'الوضع الداكن',
        'en': 'Dark Mode',
        'tr': 'Karanlık Mod'
      });
  String get lightMode => _t({
        'ku': 'دۆخی ڕووناک',
        'kbd': 'مۆدێ رووناک',
        'ar': 'الوضع الفاتح',
        'en': 'Light Mode',
        'tr': 'Aydınlık Mod'
      });
  String get appearance => _t({
        'ku': 'دیمەن',
        'kbd': 'دیمەن',
        'ar': 'المظهر',
        'en': 'Appearance',
        'tr': 'Görünüm'
      });
  String get privacy => _t({
        'ku': 'پاراستنی نهێنی',
        'kbd': 'پاراستنا نهێنییان',
        'ar': 'الخصوصية',
        'en': 'Privacy',
        'tr': 'Gizlilik'
      });
  String get security => _t({
        'ku': 'ئەمنیەت',
        'kbd': 'ئەمنیەت',
        'ar': 'الأمان',
        'en': 'Security',
        'tr': 'Güvenlik'
      });
  String get help => _t({
        'ku': 'یارمەتی',
        'kbd': 'هاریکاری',
        'ar': 'المساعدة',
        'en': 'Help',
        'tr': 'Yardım'
      });
  String get about2 => _t({
        'ku': 'دەربارەی ئەپ',
        'kbd': 'دەربارەی ئەپی',
        'ar': 'حول التطبيق',
        'en': 'About App',
        'tr': 'Uygulama Hakkında'
      });
  String get savedItems => _t({
        'ku': 'دڵخوازەکان',
        'kbd': 'پاراستی',
        'ar': 'المفضلة',
        'en': 'Favorites',
        'tr': 'Favoriler'
      });
  String get version => _t({
        'ku': 'وەشان',
        'kbd': 'وەشان',
        'ar': 'الإصدار',
        'en': 'Version',
        'tr': 'Sürüm'
      });
  String get logoutConfirm => _t({
        'ku': 'دڵنیایت لە چوونەدەرەوە؟',
        'kbd': 'تۆ یێ پشت راستی دڤێی دەرکەڤی؟',
        'ar': 'هل أنت متأكد من تسجيل الخروج؟',
        'en': 'Are you sure you want to logout?',
        'tr': 'Çıkış yapmak istediğinden emin misin?'
      });
  String get notificationSettings => _t({
        'ku': 'ڕێکخستنی ئاگادارکردنەوەکان',
        'kbd': 'رێکخستنا ئاگەدارییان',
        'ar': 'إعدادات الإشعارات',
        'en': 'Notification Settings',
        'tr': 'Bildirim Ayarları'
      });
  String get enableNotifications => _t({
        'ku': 'ئاگادارکردنەوەکان چالاک بکە',
        'kbd': 'ئاگەدارییان چالاک بکە',
        'ar': 'تفعيل الإشعارات',
        'en': 'Enable Notifications',
        'tr': 'Bildirimleri Etkinleştir'
      });
  // EXTRA STRINGS
  // =====================
  String get featured => _t({
        'ku': 'تایبەت',
        'kbd': 'تایبەت',
        'ar': 'مميز',
        'en': 'Featured',
        'tr': 'Öne Çıkan'
      });
  String get recent => _t({
        'ku': 'نوێترین',
        'kbd': 'نوێترین',
        'ar': 'الأحدث',
        'en': 'Recent',
        'tr': 'Son'
      });
  String get noResults => _t({
        'ku': 'ئەنجام نییە',
        'kbd': 'چ ئەنجام نینن',
        'ar': 'لا توجد نتائج',
        'en': 'No results found',
        'tr': 'Sonuç bulunamadı'
      });
  String get years =>
      _t({'ku': 'ساڵ', 'kbd': 'ساڵ', 'ar': 'سنة', 'en': 'Years', 'tr': 'Yıl'});
  String get loginToSeeNotifications => _t({
        'ku': 'داخڵ بوو بۆ بینینی ئاگادارکردنەوەکان',
        'kbd': 'ژ بۆ دیتنا ئاگەدارییان بچووە ژوور',
        'ar': 'سجل دخول لرؤية الإشعارات',
        'en': 'Login to see notifications',
        'tr': 'Bildirimleri görmek için giriş yap'
      });
  String get savedInstitutions => _t({
        'ku': 'خوێندنگاکانی دڵخواز',
        'kbd': 'خویندنگەهێن پاراستی',
        'ar': 'المؤسسات المفضلة',
        'en': 'Favorite Institutions',
        'tr': 'Favori Kurumlar'
      });
  String get noFavorites => _t({
        'ku': 'هیچ خوێندنگێکت گیراو نییە',
        'kbd': 'تە چ خویندنگەهـ نەپاراستینە',
        'ar': 'لم تحفظ أي مؤسسة بعد',
        'en': 'No saved institutions yet',
        'tr': 'Henüz kaydedilen kurum yok'
      });
  String get browseInstitutions => _t({
        'ku': 'خوێندنگاکان ببینە',
        'kbd': 'ل خویندنگەهان بگەرە',
        'ar': 'تصفح المؤسسات',
        'en': 'Browse Institutions',
        'tr': 'Kurumları Gezin'
      });
  String get saved => _t({
        'ku': 'دڵخوازەکان',
        'kbd': 'پاراستی',
        'ar': 'المفضلة',
        'en': 'Favorites',
        'tr': 'Favoriler'
      });
  String get guest => _t({
        'ku': 'میوان',
        'kbd': 'مێڤان',
        'ar': 'ضيف',
        'en': 'Guest',
        'tr': 'Misafir'
      });
  String get loginToAccessAccount => _t({
        'ku': 'بۆ بەکارهێنانی هەژمارەکەت سەرەتا بچۆ ژوورەوە',
        'kbd': 'بۆ بکارئینانا هەژمارا خۆ، سەرەتا بچووە ژوور',
        'ar': 'سجّل الدخول أولاً للوصول إلى حسابك',
        'en': 'Log in first to access your account',
        'tr': 'Hesabınıza erişmek için önce giriş yapın'
      });
  String get teacherRegisterSuccess => _t({
        'ku': 'داواکاریت بە سەرکەوتوویی نێردرا، بچاوە ڕاگەیەنراوەکانت',
        'kbd': 'داخوازییا تە ب سەرکەفتی هاتە شاندن، ل هیڤییا بەرسڤێ بە',
        'ar': 'تم إرسال طلبك بنجاح، انتظر الموافقة',
        'en': 'Your request was submitted. Await approval.',
        'tr': 'Talebiniz gönderildi. Onay bekleyin.'
      });
  String get cvSubmitSuccess => _t({
        'ku': 'CV ت بە سەرکەوتوویی نێردرا',
        'kbd': 'CVیا تە ب سەرکەفتی هاتە شاندن',
        'ar': 'تم رفع سيرتك الذاتية بنجاح',
        'en': 'Your CV was submitted successfully',
        'tr': 'CV\'niz başarıyla gönderildi'
      });
  String get successTitle => _t({
        'ku': 'سەرکەوتوو بوو! ✅',
        'kbd': 'ب سەرکەفتی! ✅',
        'ar': 'تم بنجاح! ✅',
        'en': 'Success! ✅',
        'tr': 'Başarılı! ✅'
      });
  String get subjectPhoto => _t({
        'ku': 'وێنەی بابەت',
        'kbd': 'وێنێ بابەتی',
        'ar': 'صورة المادة',
        'en': 'Subject Photo',
        'tr': 'Ders Fotoğrafı'
      });
  String get teacherType => _t({
        'ku': 'جۆری مامۆستا',
        'kbd': 'جۆرێ مامۆستەی',
        'ar': 'نوع المعلم',
        'en': 'Teacher Type',
        'tr': 'Öğretmen Türü'
      });
  String get privacyPolicy => _t({
        'ku': 'سیاسەتی بەکارهێنان',
        'kbd': 'سیاسەتا بکارئینانێ',
        'ar': 'سياسة الخصوصية',
        'en': 'Terms of Use',
        'tr': 'Gizlilik Politikası'
      });
  String get helpCenter => _t({
        'ku': 'ناوەندی یارمەتی',
        'kbd': 'سەنتەرێ هاریکاریێ',
        'ar': 'مركز المساعدة',
        'en': 'Help Center',
        'tr': 'Yardım Merkezi'
      });
  String get helpDialogDesc => _t({
        'ku':
            'ئێمە لێرەین بۆ یارمەتیدانت! هەر پرسیارێکت هەیە یان کێشەیەکت بۆ دروست بووە، دەتوانیت لە ڕێگەی یەکێک لەم ڕێگایانەی خوارەوە پەیوەندیمان پێوە بکەیت.',
        'kbd':
            'ئەم لێرەین بۆ هاریکاریکرنا تە! هەر پرسیارەک یان کێشەیەک تە هەبیت، دکەری ب ڕێیا ئێک ژ ڤان ڕێیێن ل خوارێ پەیوەندیێ ب مە بکەی.',
        'ar':
            'نحن هنا لمساعدتك! إذا كان لديك أي أسئلة أو واجهت مشكلة، يمكنك التواصل معنا عبر إحدى الطرق التالية.',
        'en':
            'We are here to help! If you have any questions or faced an issue, you can contact us via one of the options below.',
        'tr':
            'Yardımcı olmak için buradayız! Herhangi bir sorunuz varsa veya bir sorunla karşılaştıysanız, aşağıdaki yollardan biriyle bizimle iletişime geçebilirsiniz.'
      });
  String get fastestResponse => _t({
        'ku': ' رێگە بۆ وەلام دانەوە',
        'kbd': 'ڕێیەک بۆ بەرسڤدانێ',
        'ar': 'طريقة للتواصل والرد',
        'en': 'Way to get a response',
        'tr': 'Yanıt almanın bir yolu'
      });
  String get directContact => _t({
        'ku': 'پەیوەندی ڕاستەوخۆ',
        'kbd': 'پەیوەندیا ڕاستەوخۆ',
        'ar': 'اتصال مباشر',
        'en': 'Direct contact',
        'tr': 'Doğrudan iletişim'
      });
  String get contactInfo => _t({
        'ku': 'زانیاری پەیوەندی',
        'kbd': 'پێزانیێن پەیوەندیێ',
        'ar': 'معلومات الاتصال',
        'en': 'Contact Info',
        'tr': 'İletişim Bilgileri'
      });
  String get social => _t({
        'ku': 'تۆرە کۆمەڵایەتییەکان',
        'kbd': 'تورێن جڤاکی',
        'ar': 'التواصل الاجتماعي',
        'en': 'Social Media',
        'tr': 'Sosyal Medya'
      });
  String get all => _t(
      {'ku': 'هەموو', 'kbd': 'هەمی', 'ar': 'الكل', 'en': 'All', 'tr': 'Tümü'});
  String get stats => _t({
        'ku': 'ئامارەکان',
        'kbd': 'ئامار',
        'ar': 'الإحصائيات',
        'en': 'Statistics',
        'tr': 'İstatistikler'
      });

  String get totalInstitutions => _t({
        'ku': 'کۆی خوێندنگاکان',
        'kbd': 'کۆما خویندنگەهان',
        'ar': 'إجمالي المؤسسات',
        'en': 'Total Institutions',
        'tr': 'Toplam Kurum'
      });
  String get totalTeachers => _t({
        'ku': 'کۆی مامۆستایان',
        'kbd': 'کۆما مامۆستەیان',
        'ar': 'إجمالي المعلمين',
        'en': 'Total Teachers',
        'tr': 'Toplam Öğretmen'
      });
  String get totalCvs => _t({
        'ku': 'کۆی CVکان',
        'kbd': 'کۆما CVیان',
        'ar': 'إجمالي السير الذاتية',
        'en': 'Total CVs',
        'tr': 'Toplam CV'
      });
  String get cities => _t({
        'ku': 'شارەکان',
        'kbd': 'باژێر',
        'ar': 'المدن',
        'en': 'Cities',
        'tr': 'Şehirler'
      });
  String get foundedYearLabel => _t({
        'ku': 'ساڵی دامەزران',
        'kbd': 'ساڵا دامەزرانێ',
        'ar': 'سنة التأسيس',
        'en': 'Founded Year',
        'tr': 'Kuruluş Yılı'
      });
  String get studentsLabel => _t({
        'ku': 'قوتابی',
        'kbd': 'قوتابی',
        'ar': 'طلاب',
        'en': 'Students',
        'tr': 'Öğrenciler'
      });

  String get visitorsLabel => _t({
        'ku': 'سەردانی',
        'kbd': 'سەردانی',
        'ar': 'الزيارات',
        'en': 'Visits',
        'tr': 'Ziyaret'
      });

  // =====================
  // MISSING COMMON STRINGS
  // =====================
  String get institutionMap => _t({
        'ku': 'نەخشەی دامەزراوەکان',
        'kbd': 'نەخشەیا دەزگەهان',
        'ar': 'خريطة المؤسسات',
        'en': 'Institutions Map',
        'tr': 'Kurum Haritası'
      });
  String get noInformation => _t({
        'ku': 'هیچ زانیارییەک نییە',
        'kbd': 'چ پێزانیین نینن',
        'ar': 'لا توجد معلومات',
        'en': 'No information available',
        'tr': 'Bilgi yok'
      });
  String get noPosts => _t({
        'ku': 'هیچ پۆستێک نییە',
        'kbd': 'چ پۆست نینن',
        'ar': 'لا توجد منشورات',
        'en': 'No posts yet',
        'tr': 'Henüz gönderi yok'
      });
  String get viewVideo => _t({
        'ku': 'ڤیدیۆی دامەزراوەکە ببینە',
        'kbd': 'ڤیدیۆیا دەزگەهی ببینە',
        'ar': 'شاهد فيديو المؤسسة',
        'en': 'Watch Institution Video',
        'tr': 'Kurum Videosunu İzle'
      });
  String get map => _t({
        'ku': 'نەخشە',
        'kbd': 'نەخشە',
        'ar': 'الخريطة',
        'en': 'Map',
        'tr': 'Harita'
      });
  String get clear => _t({
        'ku': 'پاکردنەوە',
        'kbd': 'پاقژکرن',
        'ar': 'مسح',
        'en': 'Clear',
        'tr': 'Temizle'
      });
  String get institutionType => _t({
        'ku': 'جۆری دامەزراوە',
        'kbd': 'جۆرێ دەزگەهی',
        'ar': 'نوع المؤسسة',
        'en': 'Institution Type',
        'tr': 'Kurum Türü'
      });
  String get scanQr => _t({
        'ku': 'سکانی کۆدی QR',
        'kbd': 'سکانا کۆدا QR',
        'ar': 'مسح رمز QR',
        'en': 'Scan QR Code',
        'tr': 'QR Kodunu Tara'
      });
  String get qrCode => _t({
        'ku': 'کۆدی QR',
        'kbd': 'کۆدا QR',
        'ar': 'رمز QR',
        'en': 'QR Code',
        'tr': 'QR Kodu'
      });
  String get watchVideo => _t({
        'ku': 'بینینی ڤیدیۆ',
        'kbd': 'دیتنا ڤیدیۆیێ',
        'ar': 'مشاهدة الفيديو',
        'en': 'Watch Video',
        'tr': 'Videoyu İzle'
      });
  String get update => _t({
        'ku': 'نوێکردنەوە',
        'kbd': 'نویکرنەڤە',
        'ar': 'تحديث',
        'en': 'Update',
        'tr': 'Güncelle'
      });
  String get updateAvailable => _t({
        'ku': 'وەشانێکی نوێ بەردەستە',
        'kbd': 'وەشانێکی نوێ بەردەستە',
        'ar': 'يوجد إصدار جديد',
        'en': 'New Version Available',
        'tr': 'Yeni Sürüm Mevcut'
      });
  String get forceUpdateTitle => _t({
        'ku': 'پێویستە ئەپەکە نوێ بکەیتەوە',
        'kbd': 'پێویستە ئەپ نوێ بکەیتەوە',
        'ar': 'يجب تحديث التطبيق',
        'en': 'Update Required',
        'tr': 'Güncelleme Gerekiyor'
      });
  String get updateDesc => _t({
        'ku': 'تکایە دوایین وەشانی ئەپەکە دابەزێنە بۆ بەردەوامبوون.',
        'kbd': 'تکایە دوایین وەشانی ئەپ دابەزێنە.',
        'ar': 'يرجى تنزيل أحدث إصدار للمتابعة.',
        'en': 'Please download the latest version to continue.',
        'tr': 'Devam etmek için lütfen son sürümü indirin.'
      });
  String get later => _t({
        'ku': 'پاشان',
        'kbd': 'پاشان',
        'ar': 'لاحقاً',
        'en': 'Later',
        'tr': 'Sonra'
      });
  String get publishNew => _t({
        'ku': 'بڵاوکردنەوەی نوێ',
        'kbd': 'بەلاڤکرنا نوێ',
        'ar': 'نشر جديد',
        'en': 'Publish New',
        'tr': 'Yeni Yayınla'
      });
  String get addPhoto => _t({
        'ku': 'وێنەیەک بۆ شتەکە دابنێ',
        'kbd': 'وێنەیەکێ بۆ تشتێ خوە دابنێ',
        'ar': 'أضف صورة للشيء',
        'en': 'Add photo for item',
        'tr': 'Öğe için fotoğraf ekle'
      });
  String get itemName => _t({
        'ku': 'ناوی شتەکە',
        'kbd': 'ناڤێ تشتێ تە',
        'ar': 'اسم الشيء',
        'en': 'Item Name',
        'tr': 'Öğe Adı'
      });
  String get where => _t({
        'ku': 'لە کوێ؟',
        'kbd': 'ل کیرێ؟',
        'ar': 'أين؟',
        'en': 'Where?',
        'tr': 'Nerede?'
      });
  String get moreInfo => _t({
        'ku': 'زانیاری زیاتر',
        'kbd': 'پێزانیێن زێدەتر',
        'ar': 'معلومات أكثر',
        'en': 'More Info',
        'tr': 'Daha Fazla Bilgi'
      });
  String get fillAllInfo => _t({
        'ku': 'تکایە هەموو زانیارییەکان پڕبکەرەوە',
        'kbd': 'تکایە هەمی پێزانییان تژی بکە',
        'ar': 'يرجى ملء جميع المعلومات',
        'en': 'Please fill all information',
        'tr': 'Lütfen tüm bilgileri doldurun'
      });
  String get share => _t({
        'ku': 'ناردن',
        'kbd': 'شاندن',
        'ar': 'مشاركة',
        'en': 'Share',
        'tr': 'Paylaş'
      });
  String get close => _t({
        'ku': 'داخستن',
        'kbd': 'داخستن',
        'ar': 'إغلاق',
        'en': 'Close',
        'tr': 'Kapat'
      });
  String get apply => _t({
        'ku': 'جێبەجێکردن',
        'kbd': 'بجهئینان',
        'ar': 'تطبيق',
        'en': 'Apply',
        'tr': 'Uygula'
      });
  String get advancedFilter => _t({
        'ku': 'فلتەری پێشکەوتوو',
        'kbd': 'فلتەرێن هویر',
        'ar': 'تصفية متقدمة',
        'en': 'Advanced Filter',
        'tr': 'Gelişmiş Filtre'
      });
  String get scanQrInstructions => _t({
        'ku': 'کۆدی QR ی دامەزراوەکە بخەرە بەر کامێرا',
        'kbd': 'کۆدا QR یا دەزگەهی بێخە بەر کامیرێ',
        'ar': 'وجه الكاميرا نحو رمز QR للمؤسسة',
        'en': 'Point camera at institution QR code',
        'tr': 'Kamerayı kurumun QR koduna doğrultun'
      });
  String get viewInstitutionInfo => _t({
        'ku': 'بۆ بینینی زانیاری خوێندنگا',
        'kbd': 'بۆ بینینا پێزانیێن خویندنگەهێ',
        'ar': 'لرؤية معلومات المؤسسة',
        'en': 'To view institution information',
        'tr': 'Kurum bilgilerini görüntülemek için'
      });
  String get lost => _t({
        'ku': 'ونبووە',
        'kbd': 'بەرزەبووی',
        'ar': 'مفقود',
        'en': 'Lost',
        'tr': 'Kayıp'
      });
  String get found => _t({
        'ku': 'دۆزراوەتەوە',
        'kbd': 'هاتیە دیتن',
        'ar': 'موجود',
        'en': 'Found',
        'tr': 'Bulundu'
      });
  String get publish => _t({
        'ku': 'بڵاوکردنەوە',
        'kbd': 'بەلاڤکرن',
        'ar': 'نشر',
        'en': 'Publish',
        'tr': 'Yayınla'
      });
  String get publishedSuccess => _t({
        'ku': 'بە سەرکەوتوویی بڵاوکرایەوە!',
        'kbd': 'ب سەرکەفتی هاتە بەلاڤکرن!',
        'ar': 'تم النشر بنجاح!',
        'en': 'Published successfully!',
        'tr': 'Başarıyla yayınlandı!'
      });
  String get myAccount => _t({
        'ku': 'هەژماری من',
        'kbd': 'هەژمارا من',
        'ar': 'حسابي',
        'en': 'My Account',
        'tr': 'Hesabım'
      });
  String get lostAndFound => _t({
        'ku': 'ونبوو و دۆزراوە',
        'kbd': 'بەرزەبووی و دیتنی',
        'ar': 'المفقودات',
        'en': 'Lost & Found',
        'tr': 'Kayıp ve Buluntu'
      });
  String get messageSent => _t({
        'ku': 'نامە نێردرا بە سەرکەوتوویی!',
        'kbd': 'نامە ب سەرکەفتی هاتە فرێکرن!',
        'ar': 'تم إرسال الرسالة بنجاح!',
        'en': 'Message sent successfully!',
        'tr': 'Mesaj başarıyla gönderildi!'
      });
  String get publisher => _t({
        'ku': 'بڵاوکەرەوە',
        'kbd': 'بەلاڤکەر',
        'ar': 'الناشر',
        'en': 'Publisher',
        'tr': 'Yayıncı'
      });
  String get pathFinder => _t({
        'ku': 'ڕێبەرە زیرەکەکەت',
        'kbd': 'رێبەرێ زیرەک',
        'ar': 'دليلك الذكي',
        'en': 'Path Finder',
        'tr': 'Akıllı Rehber'
      });
  String get previous => _t({
        'ku': 'پێشتر',
        'kbd': 'بەری نوکە',
        'ar': 'السابق',
        'en': 'Previous',
        'tr': 'Önceki'
      });
  String get losts => _t({
        'ku': 'ونبووەکان',
        'kbd': 'بەرزەبوویی',
        'ar': 'المفقودات',
        'en': 'Lost Items',
        'tr': 'Kayıp Eşyalar'
      });
  String get founds => _t({
        'ku': 'دۆزراوەکان',
        'kbd': 'دیتنی',
        'ar': 'الموجودات',
        'en': 'Found Items',
        'tr': 'Bulunan Eşyalar'
      });
  String get itIsMine => _t({
        'ku': 'ئەوە هی منە!',
        'kbd': 'ئەڤە یا منە!',
        'ar': 'هذا لي!',
        'en': 'It is mine!',
        'tr': 'Bu benim!'
      });
  String get iFoundIt => _t({
        'ku': 'من دۆزیومەتەوە!',
        'kbd': 'من دیتووە!',
        'ar': 'لقد وجدته!',
        'en': 'I found it!',
        'tr': 'Buldum!'
      });
  String get searchHintLostFound => _t({
        'ku': 'گەڕان بەدوای کلیل، باج، مۆبایل...',
        'kbd': 'گەریان ل سویچ، باج، مۆبایل...',
        'ar': 'بحث عن مفتاح، بطاقة، هاتف...',
        'en': 'Search for key, ID, phone...',
        'tr': 'Anahtar, kimlik, telefon ara...'
      });
  String get noItemsFound => _t({
        'ku': 'هیچ شتێک نەدۆزرایەوە',
        'kbd': 'چ تشت نەهاتنە دیتن',
        'ar': 'لم يتم العثور على أي شيء',
        'en': 'No items found',
        'tr': 'Hiçbir şey bulunamadı'
      });
  String get nextStep => _t({
        'ku': 'دواتر',
        'kbd': 'پاشان',
        'ar': 'التالي',
        'en': 'Next',
        'tr': 'Sonraki'
      });
  String get findResults => _t({
        'ku': 'دۆزینەوەی ئەنجام',
        'kbd': 'دیتنا ئەنجامان',
        'ar': 'البحث عن النتائج',
        'en': 'Find Results',
        'tr': 'Sonuçları Bul'
      });
  String get whatIsYourGrade => _t({
        'ku': 'نمرەی پۆلی ١٢ت چەندە؟',
        'kbd': 'نمرەیا تە یا پۆلا ١٢ چەندە؟',
        'ar': 'ما هو معدلك في الصف ١٢؟',
        'en': 'What is your grade 12 average?',
        'tr': '12. sınıf ortalamanız kaç?'
      });
  String get whichFieldDoYouLike => _t({
        'ku': 'حەزت لە کام بووارەیە؟',
        'kbd': 'تە حەز ل کیژ بوارەیە؟',
        'ar': 'ما هو المجال الذي تفضله؟',
        'en': 'Which field do you like?',
        'tr': 'Hangi alanı seviyorsunuz?'
      });
  String get whichCity => _t({
        'ku': 'لە کام شار بێت؟',
        'kbd': 'ل کیژ باژێری بیت؟',
        'ar': 'في أي مدينة؟',
        'en': 'In which city?',
        'tr': 'Hangi şehirde?'
      });
  String get institutionTypeQuestion => _t({
        'ku': 'جۆری دامەزراوەکە؟',
        'kbd': 'جۆرێ دەزگەهی؟',
        'ar': 'نوع المؤسسة؟',
        'en': 'Institution type?',
        'tr': 'Kurum türü?'
      });
  String get both => _t({
        'ku': 'هەردووکی',
        'kbd': 'هەردوو',
        'ar': 'كلاهما',
        'en': 'Both',
        'tr': 'Her ikisi de'
      });
  String get public => _t({
        'ku': 'حکومی',
        'kbd': 'حکومی',
        'ar': 'حكومي',
        'en': 'Public',
        'tr': 'Devlet'
      });
  String get private => _t({
        'ku': 'ئەهلی',
        'kbd': 'ئەهلی',
        'ar': 'أهلي',
        'en': 'Private',
        'tr': 'Özel'
      });
  String get medical => _t({
        'ku': 'پزیشکی',
        'kbd': 'پزیشکی',
        'ar': 'طب',
        'en': 'Medical',
        'tr': 'Tıp'
      });
  String get engineering => _t({
        'ku': 'ئەندازیاری',
        'kbd': 'ئەندازیاری',
        'ar': 'هندسة',
        'en': 'Engineering',
        'tr': 'Mühendislik'
      });
  String get it => _t({
        'ku': 'تەکنەلۆژیا',
        'kbd': 'تەکنەلۆژیا',
        'ar': 'تكنولوجيا',
        'en': 'Technology',
        'tr': 'Teknoloji'
      });
  String get law => _t(
      {'ku': 'یاسا', 'kbd': 'یاسا', 'ar': 'قانون', 'en': 'Law', 'tr': 'Hukuk'});
  String get business => _t({
        'ku': 'کارگێڕی',
        'kbd': 'کارگێری',
        'ar': 'إدارة أعمال',
        'en': 'Business',
        'tr': 'İşletme'
      });
  String get arts => _t({
        'ku': 'هونەر',
        'kbd': 'هونەر',
        'ar': 'فنون',
        'en': 'Arts',
        'tr': 'Sanat'
      });

  // =====================
  // NEWS
  // =====================
  String get news => _t({
        'ku': 'هەواڵەکان',
        'kbd': 'هەواڵ',
        'ar': 'الأخبار',
        'en': 'News',
        'tr': 'Haberler'
      });
  String get newsSubtitle => _t({
        'ku': 'تازەترین بڵاوکراوە و چالاکییەکان',
        'kbd': 'نوێترین بەلاڤکراو و چالاکی',
        'ar': 'أحدث المنشورات والفعاليات',
        'en': 'Latest posts and activities',
        'tr': 'Son yayınlar ve etkinlikler'
      });
  String get noContent => _t({
        'ku': 'هیچ ناوەرۆکێک نەدۆزرایەوە',
        'kbd': 'چ ناوەرۆک نەهاتە دیتن',
        'ar': 'لم يتم العثور على أي محتوى',
        'en': 'No content found',
        'tr': 'İçerik bulunamadı'
      });
  String get officialNews => _t({
        'ku': 'هەواڵی فەرمی',
        'kbd': 'هەواڵێ فەرمی',
        'ar': 'خبر رسمي',
        'en': 'Official News',
        'tr': 'Resmi Haber'
      });
  String get newsTag => _t({
        'ku': 'هەواڵ',
        'kbd': 'هەواڵ',
        'ar': 'خبر',
        'en': 'News',
        'tr': 'Haber'
      });
  String get viewInstitutionProfile => _t({
        'ku': 'بینینی پرۆفایلی دامەزراوە',
        'kbd': 'دیتنا پرۆفایلا دامەزراوەیێ',
        'ar': 'عرض ملف المؤسسة',
        'en': 'View institution profile',
        'tr': 'Kurum profilini gör'
      });

  // =====================
  // TIME AGO
  // =====================
  String get timeNow => _t({
        'ku': 'ئێستا',
        'kbd': 'ئێستا',
        'ar': 'الآن',
        'en': 'Just now',
        'tr': 'Şimdi'
      });
  String timeMinutesAgo(int m) => _t({
        'ku': '$m خولەک پێش',
        'kbd': '$m خولەک پێش',
        'ar': 'منذ $m دقيقة',
        'en': '${m}m ago',
        'tr': '$m dk önce'
      });
  String timeHoursAgo(int h) => _t({
        'ku': '$h کاتژمێر پێش',
        'kbd': '$h کاتژمێر پێش',
        'ar': 'منذ $h ساعة',
        'en': '${h}h ago',
        'tr': '$h sa önce'
      });
  String timeDaysAgo(int d) => _t({
        'ku': '$d ڕۆژ پێش',
        'kbd': '$d رۆژ پێش',
        'ar': 'منذ $d يوم',
        'en': '${d}d ago',
        'tr': '$d gün önce'
      });
  String timeMinutesAgoBefore(int m) => _t({
        'ku': '$m خولەک لەمەوبەر',
        'kbd': '$m خولەک پێش',
        'ar': 'منذ $m دقيقة',
        'en': '${m}m ago',
        'tr': '$m dk önce'
      });
  String timeHoursAgoBefore(int h) => _t({
        'ku': '$h کاتژمێر لەمەوبەر',
        'kbd': '$h کاتژمێر پێش',
        'ar': 'منذ $h ساعة',
        'en': '${h}h ago',
        'tr': '$h sa önce'
      });
  String timeDaysAgoBefore(int d) => _t({
        'ku': '$d ڕۆژ لەمەوبەر',
        'kbd': '$d رۆژ پێش',
        'ar': 'منذ $d يوم',
        'en': '${d}d ago',
        'tr': '$d gün önce'
      });

  // =====================
  // INSTITUTION TYPE LABELS
  // =====================
  String get typeUniversity => _t({
        'ku': 'زانکۆ',
        'kbd': 'زانکۆ',
        'ar': 'جامعة',
        'en': 'University',
        'tr': 'Üniversite'
      });
  String get typeSchool => _t({
        'ku': 'قوتابخانە',
        'kbd': 'قوتابخانە',
        'ar': 'مدرسة',
        'en': 'School',
        'tr': 'Okul'
      });
  String get typeLanguageCenter => _t({
        'ku': 'سەنتەری زمان',
        'kbd': 'سەنتەرێ زمانان',
        'ar': 'مركز لغات',
        'en': 'Language Center',
        'tr': 'Dil Merkezi'
      });
  String get typeKindergarten => _t({
        'ku': 'باخچەی ساوایان',
        'kbd': 'باخچێ زارۆکان',
        'ar': 'روضة',
        'en': 'Kindergarten',
        'tr': 'Anaokulu'
      });
  String get typeInstitute => _t({
        'ku': 'پەیمانگا',
        'kbd': 'پەیمانگەهـ',
        'ar': 'معهد',
        'en': 'Institute',
        'tr': 'Enstitü'
      });

  // =====================
  // HOME SCREEN
  // =====================
  String get ministryOfEducation => _t({
        'ku': 'وەزارەتی پەروەردە',
        'kbd': 'وەزارەتا پەروەردێ',
        'ar': 'وزارة التربية',
        'en': 'Ministry of Education',
        'tr': 'Milli Eğitim Bakanlığı'
      });
  String get higherEducation => _t({
        'ku': 'خوێندنی باڵا',
        'kbd': 'خوەندنا باڵا',
        'ar': 'التعليم العالي',
        'en': 'Higher Education',
        'tr': 'Yükseköğretim'
      });
  String get otherInstitutions => _t({
        'ku': 'دامەزراوەکانی تر',
        'kbd': 'دەزگەهێن دی',
        'ar': 'مؤسسات أخرى',
        'en': 'Other Institutions',
        'tr': 'Diğer Kurumlar'
      });
  String get educationTypes => _t({
        'ku': 'جۆرەکانی خوێندن',
        'kbd': 'جۆرێن خوەندنێ',
        'ar': 'أنواع التعليم',
        'en': 'Education Types',
        'tr': 'Eğitim Türleri'
      });
  String get seeAllShort => _t({
        'ku': 'هەمووی',
        'kbd': 'هەمی',
        'ar': 'الكل',
        'en': 'See All',
        'tr': 'Tümü'
      });
  String get allFilter => _t(
      {'ku': 'هەموو', 'kbd': 'هەمی', 'ar': 'الكل', 'en': 'All', 'tr': 'Tümü'});
  String get topRatedInstitutions => _t({
        'ku': 'بەرزترین هەڵسەنگاندنەکان',
        'kbd': 'بلندترین هەلسەنگاندن',
        'ar': 'الأعلى تقييماً',
        'en': 'Top Rated',
        'tr': 'En Yüksek Puanlılar'
      });
  String get bestInstitutions => _t({
        'ku': 'دامەزراوەکان',
        'kbd': 'دەزگەهـ',
        'ar': 'المؤسسات',
        'en': 'Institutions',
        'tr': 'Kurumlar'
      });
  String get noInstitutionsFound => _t({
        'ku': 'هیچ دامەزراوەیەک نەدۆزرایەوە',
        'kbd': 'چ دەزگەهـ نەهاتە دیتن',
        'ar': 'لا توجد مؤسسات',
        'en': 'No institutions found',
        'tr': 'Kurum bulunamadı'
      });
  String get applyFilter => _t({
        'ku': 'جێبەجێکردنی فلتەر',
        'kbd': 'بجهئینانا فلتەری',
        'ar': 'تطبيق الفلتر',
        'en': 'Apply Filter',
        'tr': 'Filtreyi Uygula'
      });
  String get ratingLevel => _t({
        'ku': 'ئاستی هەڵسەنگاندن',
        'kbd': 'ئاستێ هەلسەنگاندنێ',
        'ar': 'مستوى التقييم',
        'en': 'Rating Level',
        'tr': 'Derecelendirme Seviyesi'
      });

  // Cities (filter chips)
  String get cityErbil => _t({
        'ku': 'هەولێر',
        'kbd': 'هەولێر',
        'ar': 'أربيل',
        'en': 'Erbil',
        'tr': 'Erbil'
      });
  String get citySulaymaniyah => _t({
        'ku': 'سلێمانی',
        'kbd': 'سلێمانی',
        'ar': 'السليمانية',
        'en': 'Sulaymaniyah',
        'tr': 'Süleymaniye'
      });
  String get cityDuhok => _t({
        'ku': 'دهۆک',
        'kbd': 'دهۆک',
        'ar': 'دهوك',
        'en': 'Duhok',
        'tr': 'Duhok'
      });
  String get cityHalabja => _t({
        'ku': 'هەڵەبجە',
        'kbd': 'هەڵەبجە',
        'ar': 'حلبجة',
        'en': 'Halabja',
        'tr': 'Halabja'
      });
  String get cityKirkuk => _t({
        'ku': 'کەرکوک',
        'kbd': 'کەرکوک',
        'ar': 'كركوك',
        'en': 'Kirkuk',
        'tr': 'Kerkük'
      });
  List<String> get filterCities =>
      [cityErbil, citySulaymaniyah, cityDuhok, cityHalabja, cityKirkuk];


  // =====================
  // HOME DRAWER
  // =====================
  String get drawerStudent => _t({
        'ku': 'خوێندکار',
        'kbd': 'قوتابی',
        'ar': 'طالب',
        'en': 'Student',
        'tr': 'Öğrenci'
      });
  String get drawerSectionTools => _t({
        'ku': 'ئامرازەکان',
        'kbd': 'ئامراز',
        'ar': 'الأدوات',
        'en': 'Tools',
        'tr': 'Araçlar'
      });
  String get drawerPathFinder => _t({
        'ku': 'ڕێبەرە زیرەکەکەت',
        'kbd': 'رێبەرێ زیرەک',
        'ar': 'دليلك الذكي',
        'en': 'Smart Guide',
        'tr': 'Akıllı Rehber'
      });
  String get drawerPathFinderSub => _t({
        'ku': 'یارمەتیت دەدات بۆ هەڵبژاردنی بەش',
        'kbd': 'یاریکارێ تە دکە ژ بۆ هەلبژاردنا پشکێ',
        'ar': 'يساعدك في اختيار التخصص',
        'en': 'Helps you choose your major',
        'tr': 'Bölüm seçmende yardımcı olur'
      });
  String get drawerLostFound => _t({
        'ku': 'ونبوو و دۆزراوە',
        'kbd': 'بەرزەبووی و دیتنی',
        'ar': 'المفقودات',
        'en': 'Lost & Found',
        'tr': 'Kayıp & Bulunan'
      });
  String get drawerLostFoundSub => _t({
        'ku': 'شتێکت لێ ون بووە؟ لێرە بڵاوی بکەرەوە',
        'kbd': 'تشتێک بەرزبوویە؟ لێرە بەلاڤی بکە',
        'ar': 'فقدت شيئاً؟ انشر هنا',
        'en': 'Lost something? Post it here',
        'tr': 'Bir şey mi kaybettin? Burada paylaş'
      });
  String get drawerCv => _t({
        'ku': 'کۆچنووس (CV)',
        'kbd': 'CVیا تە',
        'ar': 'السيرة الذاتية',
        'en': 'CV',
        'tr': 'CV'
      });
  String get drawerCvSub => _t({
        'ku': 'دروستکردنی سیڤی تایبەت بە خۆت',
        'kbd': 'درووستکرنا CVیەکێ تایبەت بۆ تە',
        'ar': 'إنشاء سيرة ذاتية خاصة بك',
        'en': 'Create your personal CV',
        'tr': 'Kişisel CV oluştur'
      });
  String get drawerSectionSettings => _t({
        'ku': 'ڕێکخستنەکان',
        'kbd': 'ڕێکخستن',
        'ar': 'الإعدادات',
        'en': 'Settings',
        'tr': 'Ayarlar'
      });
  String get drawerTheme => _t({
        'ku': 'دۆخی تاریک و ڕووناک',
        'kbd': 'مۆدێ تاریک و رووناک',
        'ar': 'الوضع الداكن والفاتح',
        'en': 'Dark & Light Mode',
        'tr': 'Karanlık & Aydınlık Mod'
      });
  String get drawerChangeLanguage => _t({
        'ku': 'گۆڕینی زمان',
        'kbd': 'گوهەرینا زمانی',
        'ar': 'تغيير اللغة',
        'en': 'Change Language',
        'tr': 'Dil Değiştir'
      });
  String get drawerSectionInfo => _t({
        'ku': 'زانیاری',
        'kbd': 'زانیاری',
        'ar': 'معلومات',
        'en': 'Info',
        'tr': 'Bilgi'
      });
  String get drawerPrivacyPolicy => _t({
        'ku': 'سیاسەتی تایبەتمەندی',
        'kbd': 'سیاسەتا تایبەتمەندیێ',
        'ar': 'سياسة الخصوصية',
        'en': 'Privacy Policy',
        'tr': 'Gizlilik Politikası'
      });
  String get drawerAboutApp => _t({
        'ku': 'دەربارەی ئەپەکە',
        'kbd': 'دەربارەی ئەپی',
        'ar': 'حول التطبيق',
        'en': 'About App',
        'tr': 'Uygulama Hakkında'
      });
  String get drawerLogout => _t({
        'ku': 'چوونە دەرەوە',
        'kbd': 'دەرکەتن',
        'ar': 'تسجيل الخروج',
        'en': 'Logout',
        'tr': 'Çıkış'
      });

  // =====================
  // TEACHERS SCREEN
  // =====================
  String get teachersSubtitle => _t({
        'ku': 'مامۆستا پەسەندکراوەکان',
        'kbd': 'مامۆستەیێن پەسەندکری',
        'ar': 'المعلمون المعتمدون',
        'en': 'Approved teachers',
        'tr': 'Onaylı öğretmenler'
      });
  String get searchTeacherHint => _t({
        'ku': 'گەڕان بەدوای مامۆستا...',
        'kbd': 'گەریان ب دواری مامۆستەیێ...',
        'ar': 'ابحث عن معلم...',
        'en': 'Search for a teacher...',
        'tr': 'Öğretmen ara...'
      });
  String get filterByCity2 => _t({
        'ku': 'فلتەرکردن بەپێی شار',
        'kbd': 'فلتەرکرن ل دویڤ باژێری',
        'ar': 'تصفية حسب المدينة',
        'en': 'Filter by City',
        'tr': 'Şehre Göre Filtrele'
      });

  // =====================
  // TEACHER PROFILE SCREEN
  // =====================
  String teacherOf(String subject) => _t({
        'ku': 'مامۆستای $subject',
        'kbd': 'مامۆستەیێ $subject',
        'ar': 'أستاذ $subject',
        'en': 'Teacher of $subject',
        'tr': '$subject Öğretmeni'
      });
  String get educationSpecialization => _t({
        'ku': 'پسپۆڕی پەروەردە',
        'kbd': 'پسپۆریا پەروەردەیێ',
        'ar': 'متخصص في التعليم',
        'en': 'Education Specialist',
        'tr': 'Eğitim Uzmanı'
      });
  String get tileExperience => _t({
        'ku': 'ئەزموون',
        'kbd': 'ئەزموون',
        'ar': 'الخبرة',
        'en': 'Experience',
        'tr': 'Deneyim'
      });
  String get tileProvince => _t({
        'ku': 'پارێزگا',
        'kbd': 'پارێزگا',
        'ar': 'المحافظة',
        'en': 'Province',
        'tr': 'İl'
      });
  String get tileCurriculum => _t({
        'ku': 'مەنهەج',
        'kbd': 'مەنهەج',
        'ar': 'المنهج',
        'en': 'Curriculum',
        'tr': 'Müfredat'
      });
  String get yearsUnit =>
      _t({'ku': 'ساڵ', 'kbd': 'سال', 'ar': 'سنة', 'en': 'yr', 'tr': 'yıl'});
  String get specializationFallback => _t({
        'ku': 'پسپۆڕی',
        'kbd': 'پسپۆری',
        'ar': 'تخصص',
        'en': 'Specialty',
        'tr': 'Uzmanlık'
      });
  String get curriculumSection => _t({
        'ku': 'کتێب و مەنهەج',
        'kbd': 'کتێب و مەنهەج',
        'ar': 'الكتاب والمنهج',
        'en': 'Book & Curriculum',
        'tr': 'Kitap & Müfredat'
      });
  String get curriculumCaption => _t({
        'ku':
            'پوختەی مەنهەجی خوێندن بە شێوازێکی مۆدێرن لایەن مامۆستاوە ئامادەکراوە.',
        'kbd':
            'پوختەیا مەنهەجێ خوەندنێ بە شێوازێ مۆدێرن لا مامۆستایێ ئامادەکراوە.',
        'ar': 'ملخص المنهج الدراسي أعده المعلم بأسلوب عصري.',
        'en': 'Curriculum summary prepared by the teacher in a modern style.',
        'tr': 'Öğretmen tarafından modern bir tarzda hazırlanan müfredat özeti.'
      });
  String get contactPhone => _t({
        'ku': 'پەیوەندی تەلەفۆنی',
        'kbd': 'پەیوەندیا تەلەفۆنی',
        'ar': 'اتصال هاتفي',
        'en': 'Phone Call',
        'tr': 'Telefon Ara'
      });
  String get contactWhatsapp => _t({
        'ku': 'واتسئەپ',
        'kbd': 'وەتسئەپ',
        'ar': 'واتساب',
        'en': 'WhatsApp',
        'tr': 'WhatsApp'
      });
  String get whatsApp => _t({
        'ku': 'واتسئەپ',
        'kbd': 'وەتسئەپ',
        'ar': 'واتساب',
        'en': 'WhatsApp',
        'tr': 'WhatsApp'
      });
  String get languages => _t({
        'ku': 'زمانەکان',
        'kbd': 'زمان',
        'ar': 'اللغات',
        'en': 'Languages',
        'tr': 'Diller'
      });
  String get specializationLabel => _t({
        'ku': 'پسپۆڕی',
        'kbd': 'پسپۆری',
        'ar': 'التخصص',
        'en': 'Specialization',
        'tr': 'Uzmanlık'
      });
  String get currencyIqd => _t(
      {'ku': 'دینار', 'kbd': 'دینار', 'ar': 'د.ع', 'en': 'IQD', 'tr': 'IQD'});
  String get perHour =>
      _t({'ku': '', 'kbd': '', 'ar': 'ساعة', 'en': 'hr', 'tr': 'sa'});

  // =====================
  // CV SCREEN & DETAIL
  // =====================
  String get cvBankSubtitle => _t({
        'ku': 'بانکی سیڤی فەرمی خوێندکاران',
        'kbd': 'بانکی سیڤیێن فەرمی قوتابیان',
        'ar': 'بنك السيرة الذاتية الرسمي للطلاب',
        'en': 'Official student CV bank',
        'tr': 'Öğrencilerin resmi CV bankası'
      });
  String get searchCvHint => _t({
        'ku': 'گەڕان لە بانکی سیڤیەکان...',
        'kbd': 'گەریان ل بانکی سیڤیان...',
        'ar': 'ابحث في بنك السير الذاتية...',
        'en': 'Search CV bank...',
        'tr': 'CV bankasında ara...'
      });
  String get cvVerified => _t({
        'ku': 'پشکنراوە',
        'kbd': 'پشکنراوە',
        'ar': 'تم التحقق',
        'en': 'Verified',
        'tr': 'Doğrulandı'
      });

  // =====================
  // CHAT & MESSAGING
  // =====================
  String get chat => _t({
        'ku': 'چات',
        'kbd': 'چات',
        'ar': 'محادثة',
        'en': 'Chat',
        'tr': 'Sohbet'
      });
  String get chatWithInstitution => _t({
        'ku': 'چات لەگەڵ دامەزراوە',
        'kbd': 'چات ل گەل دەزگەهـ',
        'ar': 'محادثة مع المؤسسة',
        'en': 'Chat with Institution',
        'tr': 'Kurum ile Sohbet'
      });
  String get writeMessageHint => _t({
        'ku': 'نامەکەت لێرە بنووسە...',
        'kbd': 'ناما خوە بنڤیسە...',
        'ar': 'اكتب رسالتك هنا...',
        'en': 'Type a message...',
        'tr': 'Mesajınızı buraya yazın...'
      });
  String get startConversationTitle => _t({
        'ku': 'دەستپێکردنی گفتوگۆ',
        'kbd': 'دەستپێکرنا دانوستاندنێ',
        'ar': 'بدء المحادثة',
        'en': 'Start Conversation',
        'tr': 'Sohbet Başlat'
      });
  String get startConversationDesc => _t({
        'ku': 'پرسیارەکەت یان داواکارییەکەت بنووسە، دامەزراوەکە لە کاتێکی گونجاودا وەڵامت دەدەنەوە.',
        'kbd': 'پرسیارا خوە بنڤیسە، دەزگەهـ د دەمەکێ گونجای دا دێ بەرسڤێ دەت.',
        'ar': 'اطرح استفسارك أو طلبك، سترد عليك إدارة المؤسسة في أقرب وقت ممكن.',
        'en': 'Send your question or inquiry, the institution will reply as soon as possible.',
        'tr': 'Sorunuzu veya talebinizi yazın, kurum en kısa sürede size geri dönüş yapacaktır.'
      });
  String get loginToChat => _t({
        'ku': 'بۆ ناردنی نامە، تکایە سەرەتا بچۆ ژوورەوە',
        'kbd': 'بۆ فرێکرنا نامێ، هیڤیە پێشتر بچیە ژوورڤە',
        'ar': 'لإرسال رسالة، يرجى تسجيل الدخول أولاً',
        'en': 'Please log in first to send a message',
        'tr': 'Mesaj göndermek için lütfen önce giriş yapın'
      });
  String get failedToSendMessage => _t({
        'ku': 'ناردنی نامەکە سەرکەوتوو نەبوو',
        'kbd': 'فرێکرنا نامێ سەرنەکەفت',
        'ar': 'فشل إرسال الرسالة',
        'en': 'Failed to send message',
        'tr': 'Mesaj gönderilemedi'
      });
  String get sendPhoto => _t({
        'ku': 'ناردنی وێنە',
        'kbd': 'فرێکرنا وێنەی',
        'ar': 'إرسال صورة',
        'en': 'Send Photo',
        'tr': 'Fotoğraf Gönder'
      });
  String get camera => _t({
        'ku': 'کامێرا',
        'kbd': 'کامێرا',
        'ar': 'الكاميرا',
        'en': 'Camera',
        'tr': 'Kamera'
      });
  String get choosePhotoSource => _t({
        'ku': 'هەڵبژاردنی وێنە لە',
        'kbd': 'هەلبژارتنا وێنەی ژ',
        'ar': 'اختيار الصورة من',
        'en': 'Choose photo from',
        'tr': 'Fotoğraf kaynağı seç'
      });
  String get photo => _t({
        'ku': 'وێنە',
        'kbd': 'وێنە',
        'ar': 'صورة',
        'en': 'Photo',
        'tr': 'Fotoğraf'
      });
  String get sending => _t({
        'ku': 'دەنێردرێت...',
        'kbd': 'دهێتە فرێکرن...',
        'ar': 'جاري الإرسال...',
        'en': 'Sending...',
        'tr': 'Gönderiliyor...'
      });
  String get institutionStatus => _t({
        'ku': 'دۆخی دامەزراوە',
        'kbd': 'ڕەوشا دەزگەهـ',
        'ar': 'حالة المؤسسة',
        'en': 'Institution Status',
        'tr': 'Kurum Durumu'
      });
  String get averageRating => _t({
        'ku': 'تێکڕای هەڵسەنگاندن',
        'kbd': 'تێکڕایا هەلسەنگاندنێ',
        'ar': 'متوسط التقييم',
        'en': 'Average Rating',
        'tr': 'Ortalama Değerlendirme'
      });

  // =====================
  // CAREER & MAJOR QUIZ
  // =====================
  String get careerQuizTitle => _t({
        'ku': 'چ بەشێک بۆ من گونجاوە؟',
        'kbd': 'کیژ پشک بۆ من گونجایە؟',
        'ar': 'ما التخصص الأنسب لي؟',
        'en': 'Which Major Fits Me?',
        'tr': 'Hangi Bölüm Bana Uygun?'
      });
  String get careerQuizSub => _t({
        'ku': 'لە ٢ خولەکدا بەشی شیاوی زانکۆ و پەیمانگا بەپێی حەز و کەسایەتیت بدۆزەرەوە!',
        'kbd': 'د ٢ خۆلەکان دا پشکا گونجای یا زانکۆ و پەیمانگەهێ دویڤ حەزا خوە ببینە!',
        'ar': 'اكتشف التخصص الأنسب لك في الجامعات والمعاهد وفقاً لاهتماماتك وشخصيتك في دقيقتين!',
        'en': 'Discover your ideal university or institute major based on your personality in 2 minutes!',
        'tr': '2 dakikada ilgi ve kişiliğinize en uygun üniversite veya enstitü bölümünü keşfedin!'
      });
  String get startQuiz => _t({
        'ku': 'دەستپێکردنی تاقیکردنەوە',
        'kbd': 'دەستپێکرنا تاقیکرنێ',
        'ar': 'ابدأ الاختبار',
        'en': 'Start Quiz',
        'tr': 'Teste Başla'
      });
  String get questionLabel => _t({
        'ku': 'پرسیار',
        'kbd': 'پرسیار',
        'ar': 'سؤال',
        'en': 'Question',
        'tr': 'Soru'
      });
  String get quizResult => _t({
        'ku': 'ئەنجامی شیکاری کەسایەتیت',
        'kbd': 'ئەنجامێ کەسایەتیا تە',
        'ar': 'نتيجة تحليل شخصيتك',
        'en': 'Your Personality & Major Result',
        'tr': 'Kişilik ve Bölüm Sonucunuz'
      });
  String get recommendedMajors => _t({
        'ku': 'باشترین بەشە پێشنیارکراوەکان بۆ تۆ',
        'kbd': 'باشترین پشکێن پێشنیارکری بۆ تە',
        'ar': 'أفضل التخصصات المقترحة لك',
        'en': 'Top Recommended Majors for You',
        'tr': 'Sizin İçin En Çok Önerilen Bölümler'
      });
  String get shareMyResult => _t({
        'ku': 'شەیرکردنی ئەنجامەکەم لە ستۆری',
        'kbd': 'بەلاڤکرنا ئەنجامی د ستۆری دا',
        'ar': 'مشاركة نتيجتي في الستوري',
        'en': 'Share My Result to Story',
        'tr': 'Sonucumu Hikayede Paylaş'
      });
  String get retakeQuiz => _t({
        'ku': 'دووبارەکردنەوەی تاقیکردنەوە',
        'kbd': 'دووبارەکرنا تاقیکرنێ',
        'ar': 'إعادة الاختبار',
        'en': 'Retake Quiz',
        'tr': 'Testi Tekrarla'
      });
  String get exploreInstitutions => _t({
        'ku': 'دۆزینەوەی زانکۆ و پەیمانگاکان',
        'kbd': 'دیتنا زانکۆ و پەیمانگەهان',
        'ar': 'استكشاف الجامعات والمعاهد',
        'en': 'Explore Institutions',
        'tr': 'Kurumları Keşfet'
      });
  String get jobs => _t({
        'ku': 'هەلی کار',
        'kbd': 'دەلیڤێن کاری',
        'ar': 'الوظائف',
        'en': 'Jobs',
        'tr': 'İş İlanları'
      });
  String get jobsAndCvs => _t({
        'ku': 'هەلی کار و سیڤی',
        'kbd': 'دەلیڤێن کاری و سیڤی',
        'ar': 'الوظائف والسير الذاتية',
        'en': 'Jobs & CVs',
        'tr': 'İşler ve CV\'ler'
      });
  String get jobVacancies => _t({
        'ku': 'هەلی کارەکان',
        'kbd': 'دەلیڤێن کاری',
        'ar': 'فرص العمل',
        'en': 'Job Vacancies',
        'tr': 'Açık Pozisyonlar'
      });
  String get postJob => _t({
        'ku': 'بڵاوکردنەوەی هەلی کار',
        'kbd': 'بەلاڤکرنا دەلیڤا کاری',
        'ar': 'نشر فرصة عمل',
        'en': 'Post a Job',
        'tr': 'İş İlanı Ver'
      });
  String get jobDetails => _t({
        'ku': 'وردەکاری هەلی کار',
        'kbd': 'هویرکاتیێن دەلیڤا کاری',
        'ar': 'تفاصيل الوظيفة',
        'en': 'Job Details',
        'tr': 'İş Detayları'
      });
  String get requirements => _t({
        'ku': 'مەرجەکان',
        'kbd': 'مەرج',
        'ar': 'المتطلبات والشروط',
        'en': 'Requirements',
        'tr': 'Gereksinimler'
      });
  String get jobDescription => _t({
        'ku': 'وەسفی کار',
        'kbd': 'وەسفێ کاری',
        'ar': 'الوصف الوظيفي',
        'en': 'Job Description',
        'tr': 'İş Tanımı'
      });
  String get salary => _t({
        'ku': 'مووچە',
        'kbd': 'مووچە',
        'ar': 'الراتب',
        'en': 'Salary',
        'tr': 'Maaş'
      });
  String get employmentType => _t({
        'ku': 'جۆری دەوام',
        'kbd': 'جۆرێ دەوامی',
        'ar': 'نوع الدوام',
        'en': 'Employment Type',
        'tr': 'Çalışma Türü'
      });
  String get fullTime => _t({
        'ku': 'تەواوکات',
        'kbd': 'تەمام وەخت',
        'ar': 'دوام كامل',
        'en': 'Full-time',
        'tr': 'Tam Zamanlı'
      });
  String get partTime => _t({
        'ku': 'نیوەکات',
        'kbd': 'نیڤ وەخت',
        'ar': 'دوام جزئي',
        'en': 'Part-time',
        'tr': 'Yarı Zamanlı'
      });
  String get temporary => _t({
        'ku': 'کاتی / وانەبێژ',
        'kbd': 'دەمی / وانەبێژ',
        'ar': 'مؤقت / محاضر',
        'en': 'Temporary / Lecturer',
        'tr': 'Geçici / Ücretli'
      });
  String get teacherJob => _t({
        'ku': 'مامۆستا',
        'kbd': 'مامۆستا',
        'ar': 'معلم / مدرس',
        'en': 'Teacher',
        'tr': 'Öğretmen'
      });
  String get adminJob => _t({
        'ku': 'کارگێڕی و ژمێریاری',
        'kbd': 'کارگێڕی و ژمێریاری',
        'ar': 'إدارة ومحاسبة',
        'en': 'Administration & Accounting',
        'tr': 'Yönetim ve Muhasebe'
      });
  String get supportJob => _t({
        'ku': 'چاودێری و خزمەتگوزاری',
        'kbd': 'چاڤدێری و خزمەتگوزاری',
        'ar': 'إشراف وخدمات',
        'en': 'Support & Supervision',
        'tr': 'Destek ve Hizmet'
      });
  String get callNow => _t({
        'ku': 'پەیوەندیکردن',
        'kbd': 'پەیوەندی کرن',
        'ar': 'اتصال هاتفياً',
        'en': 'Call Now',
        'tr': 'Şimdi Ara'
      });
  String get sendWhatsapp => _t({
        'ku': 'نامە لە واتسئەپ',
        'kbd': 'نامە ل سەر واتسئەپێ',
        'ar': 'مراسلة عبر واتساب',
        'en': 'Message on WhatsApp',
        'tr': 'WhatsApp ile Yaz'
      });
  String get noJobsFound => _t({
        'ku': 'هیچ هەلی کارێک نەدۆزرایەوە',
        'kbd': 'چ دەلیڤێن کاری نەهاتنە دیتن',
        'ar': 'لم يتم العثور على فرص عمل',
        'en': 'No job vacancies found',
        'tr': 'İş ilanı bulunamadı'
      });
  String get jobPostedSuccess => _t({
        'ku': 'هەلی کارەکە بە سەرکەوتوویی بڵاوکرایەوە',
        'kbd': 'دەلیڤا کاری ب سەرکەفتیانە هاتە بەلاڤکرن',
        'ar': 'تم نشر فرصة العمل بنجاح',
        'en': 'Job vacancy posted successfully',
        'tr': 'İş ilanı başarıyla yayınlandı'
      });
  String get genderPreference => _t({
        'ku': 'ڕەگەز',
        'kbd': 'رەگەز',
        'ar': 'الجنس المطلوب',
        'en': 'Gender',
        'tr': 'Cinsiyet'
      });
  String get anyGender => _t({
        'ku': 'نێر یان مێ (گرنگ نییە)',
        'kbd': 'نێر یان مێ (نە یا گرنگە)',
        'ar': 'ذكور أو إناث',
        'en': 'Any Gender',
        'tr': 'Fark Etmez'
      });
  String get femaleOnly => _t({
        'ku': 'تەنها مێ',
        'kbd': 'ب تنێ مێ',
        'ar': 'إناث فقط',
        'en': 'Female Only',
        'tr': 'Sadece Kadın'
      });
  String get maleOnly => _t({
        'ku': 'تەنها نێر',
        'kbd': 'ب تنێ نێر',
        'ar': 'ذكور فقط',
        'en': 'Male Only',
        'tr': 'Sadece Erkek'
      });
  String get subjectOrSpecialty => _t({
        'ku': 'وانە / پسپۆڕی',
        'kbd': 'وانە / تایبەتمەندی',
        'ar': 'المادة / التخصص',
        'en': 'Subject / Specialty',
        'tr': 'Ders / Uzmanlık'
      });
  String get educationStage => _t({
        'ku': 'قۆناغی خوێندن',
        'kbd': 'قۆناغا خاندنێ',
        'ar': 'المرحلة الدراسية',
        'en': 'Education Stage',
        'tr': 'Eğitim Kademesi'
      });
  String get institutionNameLabel => _t({
        'ku': 'ناوی قوتابخانە / دامەزراوە',
        'kbd': 'ناڤێ قوتابخانێ / دەزگەهی',
        'ar': 'اسم المدرسة / المؤسسة',
        'en': 'School / Institution Name',
        'tr': 'Okul / Kurum Adı'
      });
  String get jobTitleLabel => _t({
        'ku': 'ناونیشانی کار (بۆ نموونە: مامۆستای ئینگلیزی)',
        'kbd': 'ناڤونیشانێ کاری (بۆ نموونە: مامۆستایێ ئینگلیزی)',
        'ar': 'المسمى الوظيفي (مثال: مدرس لغة إنجليزية)',
        'en': 'Job Title (e.g. English Teacher)',
        'tr': 'İş Başlığı (Örn: İngilizce Öğretmeni)'
      });
  String get clearFilters => _t({
        'ku': 'پاککردنەوەی فلتەر',
        'kbd': 'پاقژکرنا فلتەران',
        'ar': 'مسح التصفية',
        'en': 'Clear Filters',
        'tr': 'Filtreleri Temizle'
      });
  String get searchJobHint => _t({
        'ku': 'گەڕان لە هەلی کارەکان (مامۆستا، باخچە، زانکۆ)...',
        'kbd': 'لێگەڕیان ل دەلیڤێن کاری (مامۆستا، باخچە، زانکۆ)...',
        'ar': 'بحث في فرص العمل (معلم، روضة، جامعة)...',
        'en': 'Search job vacancies (teacher, kindergarten, university)...',
        'tr': 'İş ilanlarında ara (öğretmen, anaokulu, üniversite)...'
      });
  String get jobVacanciesSubtitle => _t({
        'ku': 'هەلی کاری مامۆستایان و ستافی دامەزراوەکان',
        'kbd': 'دەلیڤێن کاری یێن مامۆستایان و ستافێ دەزگەهان',
        'ar': 'فرص عمل المعلمين والكوادر التعليمية',
        'en': 'Job opportunities for teachers and educational staff',
        'tr': 'Öğretmenler ve eğitim personeli için iş fırsatları'
      });
  String get noJobsSubtitle => _t({
        'ku': 'لەم کاتەدا هیچ هەلی کارێکی نوێ لەلایەن دامەزراوەکانەوە ڕانەگەیەندراوە',
        'kbd': 'د ڤی دەمی دا چ دەلیڤێن کاری یێن نوی ژ لایێ دەزگەهان ڤە نەهاتینە راگەهاندن',
        'ar': 'لا توجد فرص عمل جديدة معلنة من قبل المؤسسات في الوقت الحالي',
        'en': 'No new job vacancies have been announced by institutions at this time',
        'tr': 'Şu anda kurumlar tarafından yayınlanmış yeni iş ilanı bulunmamaktadır'
      });
  String get salaryNegotiable => _t({
        'ku': 'دوای چاوپێکەوتن دیاری دەکرێت',
        'kbd': 'پشتی چاڤپێکەفتنێ دێ هێتە دیارکرن',
        'ar': 'يحدد بعد المقابلة',
        'en': 'Negotiable after interview',
        'tr': 'Mülakattan sonra belirlenecektir'
      });
  String get shareJobTitle => _t({
        'ku': 'هەلی کاری نوێ',
        'kbd': 'دەلیڤا کاری یا نوی',
        'ar': 'فرصة عمل جديدة',
        'en': 'New Job Vacancy',
        'tr': 'Yeni İş İlanı'
      });
  String get cityZakho => _t({
        'ku': 'زاخۆ',
        'kbd': 'زاخۆ',
        'ar': 'زاخو',
        'en': 'Zakho',
        'tr': 'Zaho'
      });
  String get citySoran => _t({
        'ku': 'سۆران',
        'kbd': 'سۆران',
        'ar': 'سوران',
        'en': 'Soran',
        'tr': 'Soran'
      });
  String get cityKoya => _t({
        'ku': 'کۆیە',
        'kbd': 'کۆیە',
        'ar': 'كويسنجق',
        'en': 'Koya',
        'tr': 'Koya'
      });
  String get basicJobInfo => _t({
        'ku': 'زانیاری سەرەکی کار و دامەزراوە',
        'kbd': 'پێزانینێن سەرەکی یێن کاری و دەزگەهی',
        'ar': 'المعلومات الأساسية للوظيفة والمؤسسة',
        'en': 'Basic Job & Institution Information',
        'tr': 'Temel İş ve Kurum Bilgileri'
      });
  String get jobDetailsAndRequirements => _t({
        'ku': 'وردەکاری و مەرجەکان',
        'kbd': 'هویرکاتی و مەرج',
        'ar': 'التفاصيل والمتطلبات',
        'en': 'Details & Requirements',
        'tr': 'Detaylar ve Gereksinimler'
      });
  String get categoryLabel => _t({
        'ku': 'پۆلێن',
        'kbd': 'پۆلێن',
        'ar': 'التصنيف',
        'en': 'Category',
        'tr': 'Kategori'
      });
  String get otherCategory => _t({
        'ku': 'تر',
        'kbd': 'دیتر',
        'ar': 'أخرى',
        'en': 'Other',
        'tr': 'Diğer'
      });
  String whatsappJobMessage(String jobTitle, String institutionName) {
    switch (locale.languageCode) {
      case 'kbd':
        return 'سلاڤ، دەربارەی دەلیڤا کاری ($jobTitle) ل ($institutionName) ب رێکا ئەپا Edubook پەیوەندیێ ب هەوە دکەم.';
      case 'ar':
        return 'مرحباً، أتواصل معكم بخصوص فرصة عمل ($jobTitle) في ($institutionName) عبر تطبيق Edubook.';
      case 'en':
        return 'Hello, I am contacting you regarding the job vacancy ($jobTitle) at ($institutionName) via Edubook app.';
      case 'tr':
        return 'Merhaba, Edubook uygulaması üzerinden ($institutionName) bünyesindeki ($jobTitle) açık iş pozisyonu hakkında iletişime geçiyorum.';
      case 'ku':
      default:
        return 'سڵاو، دەربارەی هەلی کاری ($jobTitle) لە ($institutionName) لە ڕێگەی ئەپی Edubook پەیوەندیتان پێوە دەکەم.';
    }
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['ku', 'kbd', 'ar', 'en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
