import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';

class InstitutionPromoDialog extends StatelessWidget {
  const InstitutionPromoDialog({super.key});

  /// Shows the promo dialog directly.
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
      await Future.delayed(const Duration(milliseconds: 1000));
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
        ? 'دامەزراوەکەت لە EduBook زیاد بکە'
        : (isArabic ? 'أضف مؤسستك في EduBook' : 'Add Your Institution to EduBook');

    final subtitle = isKurdish
        ? 'خوێندنگە، پەیمانگا یان زانکۆکەت تۆمار بکە و بە هەزاران قوتابی بناسێنە.'
        : (isArabic
            ? 'سجّل مدرستك، معهدك أو جامعتك وعرّف بها لآلاف الطلاب.'
            : 'Register your school, institute, or university and connect with thousands of students.');

    final chip1 = isKurdish ? 'نەخشەی زیرەک' : (isArabic ? 'خريطة ذكية' : 'Smart Map');
    final chip2 = isKurdish ? 'پۆست و کار' : (isArabic ? 'فرص وإعلانات' : 'Posts & Jobs');
    final chip3 = isKurdish ? 'چاتی فێرخوازان' : (isArabic ? 'محادثة مباشرة' : 'Direct Chat');

    final ctaText = isKurdish
        ? 'تۆمارکردن لە پۆڕتاڵ'
        : (isArabic ? 'التسجيل في البوابة' : 'Register on Portal');

    final laterText = isKurdish ? 'دواتر' : (isArabic ? 'لاحقاً' : 'Later');

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 325),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.12)
                  : const Color(0xFF2563EB).withValues(alpha: 0.2),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ══════════════════════════════════════════════════════════
              // TOP HEADER ROW (ICON + BADGE + CLOSE)
              // ══════════════════════════════════════════════════════════
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Sleek Brand Icon
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Official Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFFD97706),
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          badgeText,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFD97706),
                            fontFamily: 'Rabar',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Close button (✕)
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 17,
                        color: isDark ? Colors.white70 : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ══════════════════════════════════════════════════════════
              // TITLE & SUBTITLE (CLEAR & NATURAL KURDISH)
              // ══════════════════════════════════════════════════════════
              Text(
                title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontFamily: 'Rabar',
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 5),

              Text(
                subtitle,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                  fontFamily: 'Rabar',
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 12),

              // ══════════════════════════════════════════════════════════
              // SLIM HORIZONTAL CHIPS
              // ══════════════════════════════════════════════════════════
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
                  const SizedBox(width: 5),
                  Expanded(
                    child: _buildSlimChip(
                      icon: Icons.campaign_rounded,
                      iconColor: const Color(0xFFF59E0B),
                      label: chip2,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: _buildSlimChip(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: const Color(0xFF10B981),
                      label: chip3,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ══════════════════════════════════════════════════════════
              // CTA BUTTON (FLAT & SLIM)
              // ══════════════════════════════════════════════════════════
              SizedBox(
                height: 42,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.rocket_launch_rounded,
                          color: Color(0xFFFDE047),
                          size: 15,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          ctaText,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: 'Rabar',
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // "Later" button
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
              ),
            ],
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
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 13),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                fontFamily: 'Rabar',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
