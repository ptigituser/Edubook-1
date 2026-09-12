import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';

class InstitutionPromoDialog extends StatelessWidget {
  const InstitutionPromoDialog({super.key});

  /// Shows the promo dialog directly (used for testing or direct clicks).
  static Future<void> show(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => const InstitutionPromoDialog(),
    );
  }

  /// Checks the weekly interval (once every 7 days) and displays if eligible.
  static Future<bool> checkAndShow(BuildContext context, {bool forceNow = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!forceNow) {
        // 1. Permanent dismissal check
        final neverShow = prefs.getBool('institution_promo_never_show') ?? false;
        if (neverShow) return false;

        // 2. Weekly frequency check: once every 7 days
        final lastShown = prefs.getInt('institution_promo_last_shown');
        if (lastShown != null) {
          final daysSince = DateTime.now()
              .difference(DateTime.fromMillisecondsSinceEpoch(lastShown))
              .inDays;
          if (daysSince < 7) return false;
        }
      }

      // Smooth brief delay after home loads
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!context.mounted) return false;

      // Update last shown timestamp
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
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      debugPrint('Error opening portal URL: $e');
    }
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
        ? 'پۆڕتاڵی فەرمی'
        : (isArabic ? 'البوابة الرسمية' : 'Official Portal');

    final title = isKurdish
        ? 'خاوەنی ناوەندی پەروەردەییت؟'
        : (isArabic ? 'هل تمتلك مؤسسة تعليمية؟' : 'Own an Educational Institution?');

    final subtitle = isKurdish
        ? 'دامەزراوەکەت لە پۆڕتاڵی EduBook تۆمار بکە و بە هەزاران قوتابی بناسێنە!'
        : (isArabic
            ? 'سجّل مؤسستك في EduBook وعرّف بها لآلاف الطلاب!'
            : 'Register your institution on EduBook and connect with thousands of students!');

    final chip1 = isKurdish ? 'نەخشەی زیرەک' : (isArabic ? 'خريطة ذكية' : 'Smart Map');
    final chip2 = isKurdish ? 'پۆست و هەلی کار' : (isArabic ? 'فرص وإعلانات' : 'Posts & Jobs');
    final chip3 = isKurdish ? 'چاتی ڕاستەوخۆ' : (isArabic ? 'محادثة مباشرة' : 'Direct Chat');

    final ctaText = isKurdish
        ? 'تۆمارکردن لە پۆڕتاڵ'
        : (isArabic ? 'التسجيل في البوابة' : 'Register on Portal');

    final laterText = isKurdish ? 'دواتر' : (isArabic ? 'لاحقاً' : 'Later');

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 330),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : const Color(0xFF2563EB).withValues(alpha: 0.18),
              width: 1.2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ══════════════════════════════════════════════════════════
                // SLIM HERO BANNER WITH COMPACT OVERLAPPING BADGE
                // ══════════════════════════════════════════════════════════
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Gradient Background
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? const [Color(0xFF0B132B), Color(0xFF1C2541), Color(0xFF1D4ED8)]
                              : const [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF2563EB)],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Glowing ambient light
                          Positioned(
                            top: -25,
                            right: -15,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF60A5FA).withValues(alpha: 0.3),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -15,
                            left: -15,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                              ),
                            ),
                          ),
                          // Top bar: Badge & Close
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Slim Gold Pill Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified_rounded, color: Colors.white, size: 11),
                                      const SizedBox(width: 4),
                                      Text(
                                        badgeText,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontFamily: 'Rabar',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Slim Close Button
                                ClipOval(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                    child: Material(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      child: InkWell(
                                        onTap: () => Navigator.of(context).pop(),
                                        child: const SizedBox(
                                          width: 26,
                                          height: 26,
                                          child: Icon(Icons.close_rounded, size: 16, color: Colors.white),
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

                    // Overlapping Slim 3D Crest
                    Positioned(
                      bottom: -26,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.account_balance_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // ══════════════════════════════════════════════════════════
                // BODY CONTENT (SLIM & CLEAN)
                // ══════════════════════════════════════════════════════════
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      // Title
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                          fontFamily: 'Rabar',
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontFamily: 'Rabar',
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ══════════════════════════════════════════════════════
                      // SLIM HORIZONTAL FEATURE CHIPS
                      // ══════════════════════════════════════════════════════
                      Row(
                        children: [
                          Expanded(
                            child: _buildSlimChip(
                              icon: Icons.location_on_rounded,
                              iconColor: const Color(0xFFEF4444),
                              label: chip1,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildSlimChip(
                              icon: Icons.campaign_rounded,
                              iconColor: const Color(0xFFF59E0B),
                              label: chip2,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildSlimChip(
                              icon: Icons.chat_rounded,
                              iconColor: const Color(0xFF10B981),
                              label: chip3,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ══════════════════════════════════════════════════════
                      // SLIM CTA BUTTON
                      // ══════════════════════════════════════════════════════
                      Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () => _openPortalRegister(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.rocket_launch_rounded,
                                color: Color(0xFFFDE047),
                                size: 16,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                ctaText,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily: 'Rabar',
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // "Later" dismiss text button
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
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            fontFamily: 'Rabar',
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlimChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
              fontFamily: 'Rabar',
            ),
          ),
        ],
      ),
    );
  }
}
