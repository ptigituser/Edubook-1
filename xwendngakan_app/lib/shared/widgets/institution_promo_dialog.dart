import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';

class InstitutionPromoDialog extends StatelessWidget {
  const InstitutionPromoDialog({super.key});

  /// Shows the promo dialog unconditionally.
  static Future<void> show(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const InstitutionPromoDialog(),
    );
  }

  /// Automatically checks interval and frequency rules, then shows if conditions match.
  static Future<bool> checkAndShow(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Check if user explicitly dismissed permanently
      final neverShow = prefs.getBool('institution_promo_never_show') ?? false;
      if (neverShow) return false;

      // 2. Minimum app open threshold (don't overwhelm on the very 1st launch)
      final launchCount = prefs.getInt('app_launch_count') ?? 0;
      if (launchCount < 2) return false;

      // 3. Frequency check: show at most once every 3 days (72 hours)
      final lastShown = prefs.getInt('institution_promo_last_shown');
      if (lastShown != null) {
        final hoursSince = DateTime.now()
            .difference(DateTime.fromMillisecondsSinceEpoch(lastShown))
            .inHours;
        if (hoursSince < 72) return false;
      }

      // 4. Delay so the user comfortably sees the home screen first
      await Future.delayed(const Duration(milliseconds: 2200));
      if (!context.mounted) return false;

      // Double-check condition
      final recheckNever = prefs.getBool('institution_promo_never_show') ?? false;
      if (recheckNever) return false;

      // Record this display
      await prefs.setInt(
        'institution_promo_last_shown',
        DateTime.now().millisecondsSinceEpoch,
      );

      if (context.mounted) {
        show(context);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Institution promo check error: $e');
      return false;
    }
  }

  Future<void> _openPortalRegister(BuildContext context) async {
    try {
      final uri = Uri.parse(AppConstants.portalRegisterUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        'institution_promo_last_shown',
        DateTime.now().millisecondsSinceEpoch + const Duration(days: 7).inMilliseconds,
      );
    } catch (e) {
      debugPrint('Error opening portal URL: $e');
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _neverShowAgain(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('institution_promo_never_show', true);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final lang = l.languageCode;

    final isKurdish = lang == 'ku' || lang == 'kbd';
    final isArabic = lang == 'ar';

    final badgeText = isKurdish
        ? 'پۆڕتاڵی فەرمی دامەزراوەکان'
        : (isArabic ? 'البوابة الرسمية للمؤسسات' : 'Official Portal');

    final title = isKurdish
        ? 'خاوەنی ناوەندی پەروەردەییت؟'
        : (isArabic ? 'هل تمتلك مؤسسة تعليمية؟' : 'Own an Educational Institution?');

    final subtitle = isKurdish
        ? 'قوتابخانە، پەیمانگا یان زانکۆکەت لە EduBook زیاد بکە و بە هەزاران قوتابی و فێرخوازی بناسێنە!'
        : (isArabic
            ? 'سجّل مدرستك، معهدك أو جامعتك في EduBook وعرّف بها لآلاف الطلاب والباحثين!'
            : 'Register your school, institute, or university on EduBook and connect with thousands of students!');

    final feat1Title = isKurdish ? 'نەخشەی زیرەکی خوێندنگەکان' : (isArabic ? 'خريطة تفاعلية ذكية' : 'Smart Interactive Map');
    final feat1Desc = isKurdish ? 'دەرکەوتن لەسەر نەخشەی گەڕان بۆ قوتابیان' : (isArabic ? 'ظهور موقعك بدقة للباحثين والطلاب' : 'Show your location directly to seekers');

    final feat2Title = isKurdish ? 'بڵاوکردنەوەی پۆست و هەلی کار' : (isArabic ? 'نشر المنشورات وفرص العمل' : 'Publish Posts & Vacancies');
    final feat2Desc = isKurdish ? 'ڕاگەیاندنی هەواڵ، چالاکی و داواکاری مامۆستایان' : (isArabic ? 'مشاركة الإعلانات والأنشطة والوظائف' : 'Share announcements, events & hiring');

    final feat3Title = isKurdish ? 'پەیوەندی و چاتی ڕاستەوخۆ' : (isArabic ? 'محادثة وتواصل مباشر' : 'Direct Live Chat');
    final feat3Desc = isKurdish ? 'وەڵامدانەوەی خێرای پرسیاری فێرخوازان' : (isArabic ? 'الإجابة الفورية على استفسارات الطلاب' : 'Fast direct responses to student inquiries');

    final ctaText = isKurdish
        ? 'تۆمارکردن لە پۆڕتاڵ'
        : (isArabic ? 'التسجيل في البوابة' : 'Register on Portal');

    final laterText = isKurdish ? 'دواتر' : (isArabic ? 'لاحقاً' : 'Later');
    final neverShowText = isKurdish ? 'ئیتر پیشانم مەدە' : (isArabic ? 'عدم الإظهار مجدداً' : "Don't show again");

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 375),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : const Color(0xFF3B82F6).withValues(alpha: 0.18),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3A8A).withValues(alpha: isDark ? 0.45 : 0.22),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ══════════════════════════════════════════════════════════
                  // 1. HERO BANNER WITH VIBRANT ART & FLOATING BADGES
                  // ══════════════════════════════════════════════════════════
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Gradient Header Box
                      Container(
                        width: double.infinity,
                        height: 155,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [const Color(0xFF0A0F1D), const Color(0xFF1E293B), const Color(0xFF1D4ED8)]
                                : [const Color(0xFF0F172A), const Color(0xFF1E3A8A), const Color(0xFF2563EB)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Ambient glowing light orbs
                            Positioned(
                              top: -40,
                              right: -20,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF60A5FA).withValues(alpha: 0.28),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -20,
                              left: -20,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.22),
                                ),
                              ),
                            ),

                            // Subtle sparkle decorations
                            Positioned(
                              top: 28,
                              left: 36,
                              child: Icon(
                                Icons.auto_awesome,
                                color: const Color(0xFFFDE047).withValues(alpha: 0.75),
                                size: 16,
                              ),
                            ),
                            Positioned(
                              bottom: 45,
                              right: 40,
                              child: Icon(
                                Icons.auto_awesome,
                                color: Colors.white.withValues(alpha: 0.6),
                                size: 13,
                              ),
                            ),

                            // Top Bar inside header (Close button & Badge)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Official Portal Pill Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFF59E0B),
                                          Color(0xFFD97706),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.4),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.verified_rounded,
                                          color: Colors.white,
                                          size: 13,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          badgeText,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            fontFamily: 'Rabar',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Glassmorphic Close Button (✕)
                                  ClipOval(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                      child: Material(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        child: InkWell(
                                          onTap: () => Navigator.of(context).pop(),
                                          child: const SizedBox(
                                            width: 32,
                                            height: 32,
                                            child: Icon(
                                              Icons.close_rounded,
                                              size: 19,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Overlapping Center 3D Institution Crest
                      Positioned(
                        bottom: -36,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer ambient glow ring
                              Container(
                                width: 88,
                                height: 88,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFF60A5FA).withValues(alpha: 0.45),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              // Card Icon Container
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1D4ED8).withValues(alpha: 0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.account_balance_rounded,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                              ),
                              // Gold sparkle badge attached to icon
                              Positioned(
                                top: 2,
                                right: 2,
                                child: Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                                    ),
                                    border: Border.all(color: Colors.white, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF59E0B).withValues(alpha: 0.6),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 44),

                  // ══════════════════════════════════════════════════════════
                  // 2. MAIN BODY CONTENT
                  // ══════════════════════════════════════════════════════════
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        // Headline
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.5,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontFamily: 'Rabar',
                            height: 1.25,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            fontFamily: 'Rabar',
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),

                        // ══════════════════════════════════════════════════════
                        // 3. THREE SLEEK MICRO FEATURE CARDS
                        // ══════════════════════════════════════════════════════
                        _buildFeatureCard(
                          icon: Icons.location_on_rounded,
                          iconGradient: const [Color(0xFFEF4444), Color(0xFFDC2626)],
                          title: feat1Title,
                          desc: feat1Desc,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 8),

                        _buildFeatureCard(
                          icon: Icons.campaign_rounded,
                          iconGradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                          title: feat2Title,
                          desc: feat2Desc,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 8),

                        _buildFeatureCard(
                          icon: Icons.chat_bubble_outline_rounded,
                          iconGradient: const [Color(0xFF10B981), Color(0xFF059669)],
                          title: feat3Title,
                          desc: feat3Desc,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 20),

                        // ══════════════════════════════════════════════════════
                        // 4. CALL TO ACTION BUTTON (CTA)
                        // ══════════════════════════════════════════════════════
                        Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2563EB),
                                Color(0xFF1D4ED8),
                                Color(0xFF1E3A8A),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.42),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () => _openPortalRegister(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.rocket_launch_rounded,
                                  color: Color(0xFFFDE047),
                                  size: 19,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  ctaText,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontFamily: 'Rabar',
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ══════════════════════════════════════════════════════
                        // 5. FOOTER (Later & Never Show Again)
                        // ══════════════════════════════════════════════════════
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => _neverShowAgain(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                neverShowText,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                  fontFamily: 'Rabar',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                laterText,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                                  fontFamily: 'Rabar',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required List<Color> iconGradient,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B).withValues(alpha: 0.65) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Gradient Icon Circle
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: iconGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: iconGradient.first.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          // Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontFamily: 'Rabar',
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontFamily: 'Rabar',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
