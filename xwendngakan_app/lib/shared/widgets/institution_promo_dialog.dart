import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import 'app_3d_icons.dart';

class InstitutionPromoDialog extends StatelessWidget {
  const InstitutionPromoDialog({super.key});

  /// Shows the promo dialog unconditionally (e.g. for preview or direct click).
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

      // 2. Minimum app open threshold (e.g., don't overwhelm on the very 1st launch)
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
      await Future.delayed(const Duration(milliseconds: 2500));
      if (!context.mounted) return false;

      // Double-check condition in case context changed
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
      
      // Also remember that user engaged with it
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

    // Localized texts
    final isKurdish = lang == 'ku' || lang == 'kbd';
    final isArabic = lang == 'ar';

    final badgeText = isKurdish
        ? '📢 پۆڕتاڵی فەرمی دامەزراوەکان'
        : (isArabic ? '📢 البوابة الرسمية للمؤسسات' : '📢 Official Institutions Portal');

    final title = isKurdish
        ? 'خاوەنی قوتابخانە، پەیمانگا یان زانکۆیت؟'
        : (isArabic ? 'هل تمتلك مدرسة، معهداً أو جامعة؟' : 'Own a School, Institute, or University?');

    final subtitle = isKurdish
        ? 'دامەزراوەکەت لە EduBook تۆمار بکە و بە هەزاران قوتابی و فێرخواز لە سەرانسەری کوردستان بناسێنە!'
        : (isArabic
            ? 'سجّل مؤسستك في EduBook وعرّف بها لآلاف الطلاب والباحثين في جميع أنحاء كردستان!'
            : 'Register your institution on EduBook and reach thousands of students across the region!');

    final feature1 = isKurdish
        ? 'دیاریکردنی ناوەندەکەت لەسەر نەخشەی زیرەک'
        : (isArabic ? 'تحديد موقع مؤسستك على الخريطة التفاعلية' : 'Interactive Map placement');

    final feature2 = isKurdish
        ? 'بڵاوکردنەوەی هەواڵ، ڕاگەیەندراو و هەلی کار'
        : (isArabic ? 'نشر الأخبار والإعلانات وفرص العمل' : 'Publish news, updates & job vacancies');

    final feature3 = isKurdish
        ? 'پەیوەندی و چاتی ڕاستەوخۆ لەگەڵ فێرخوازان'
        : (isArabic ? 'تواصل ومحادثة مباشرة مع الطلاب' : 'Direct live chat with students');

    final ctaText = isKurdish
        ? 'تۆمارکردنی دامەزراوەکەت ئێستا'
        : (isArabic ? 'سجّل مؤسستك الآن' : 'Register Your Institution Now');

    final laterText = isKurdish
        ? 'دواتر'
        : (isArabic ? 'لاحقاً' : 'Later');

    final neverShowText = isKurdish
        ? 'ئیتر پیشانم مەدە'
        : (isArabic ? 'عدم الإظهار مجدداً' : "Don't show again");

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 360),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131D31) : Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : const Color(0xFF2563EB).withValues(alpha: 0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 36,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // Decorative top gradient glow
                  Positioned(
                    top: -60,
                    right: -60,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF2563EB).withValues(alpha: isDark ? 0.25 : 0.15),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: -40,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.12),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Top bar with close button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Promo Pill Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                badgeText,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF92400E),
                                  fontFamily: 'Rabar',
                                ),
                              ),
                            ),
                            // Close Button (✕)
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.08)
                                      : Colors.black.withValues(alpha: 0.05),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Center 3D Icon Banner
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Radial pulse ring
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFF2563EB).withValues(alpha: 0.25),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              const App3DIcon(
                                icon: Icons.domain_add_rounded,
                                gradientColors: [
                                  Color(0xFF3B82F6),
                                  Color(0xFF1D4ED8),
                                ],
                                size: 66,
                                iconSize: 34,
                                borderRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Catchy Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                            fontFamily: 'Rabar',
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle / Pitch
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            fontFamily: 'Rabar',
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Highlight Points
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B).withValues(alpha: 0.6)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildFeatureRow(
                                icon: Icons.location_on_rounded,
                                iconColor: const Color(0xFFEF4444),
                                text: feature1,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 8),
                              _buildFeatureRow(
                                icon: Icons.campaign_rounded,
                                iconColor: const Color(0xFFF59E0B),
                                text: feature2,
                                isDark: isDark,
                              ),
                              const SizedBox(height: 8),
                              _buildFeatureRow(
                                icon: Icons.mark_chat_unread_rounded,
                                iconColor: const Color(0xFF10B981),
                                text: feature3,
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Primary Action Button (Open Portal Website)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () => _openPortalRegister(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    ctaText,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      fontFamily: 'Rabar',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.open_in_new_rounded,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Bottom Actions: "Later" & "Don't show again"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => _neverShowAgain(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                neverShowText,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                                  fontFamily: 'Rabar',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                laterText,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white70 : const Color(0xFF64748B),
                                  fontFamily: 'Rabar',
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildFeatureRow({
    required IconData icon,
    required Color iconColor,
    required String text,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 15),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
              fontFamily: 'Rabar',
            ),
          ),
        ),
      ],
    );
  }
}
