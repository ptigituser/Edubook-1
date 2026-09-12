import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/services/api_service.dart';
import '../../providers/auth_provider.dart';

class AppFeedbackDialog extends StatefulWidget {
  final int initialRating;

  const AppFeedbackDialog({
    super.key,
    this.initialRating = 5,
  });

  /// Displays the feedback dialog directly in the CENTER of the screen
  static Future<bool?> show(BuildContext context, {int initialRating = 5}) async {
    final result = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: true,
      builder: (ctx) => AppFeedbackDialog(initialRating: initialRating),
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final submitted = prefs.getBool('app_feedback_submitted') ?? false;
      if (!submitted) {
        // User closed or dismissed without submitting, don't nag them again immediately
        await prefs.setInt(
          'app_feedback_last_dismissed_time',
          DateTime.now().millisecondsSinceEpoch,
        );
      }
    } catch (_) {}

    return result;
  }

  @override
  State<AppFeedbackDialog> createState() => _AppFeedbackDialogState();
}

class _AppFeedbackDialogState extends State<AppFeedbackDialog> {
  late int _rating;
  final TextEditingController _commentCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  String _getRatingTitle(AppLocalizations l, int rating) {
    switch (rating) {
      case 5:
        return l.rate5Star;
      case 4:
        return l.rate4Star;
      case 3:
        return l.rate3Star;
      case 2:
        return l.rate2Star;
      case 1:
        return l.rate1Star;
      default:
        return l.howDoYouLikeApp;
    }
  }

  Future<void> _openStore() async {
    try {
      if (Platform.isAndroid) {
        final marketUri = Uri.parse('market://details?id=com.khwenden.ibrahim');
        if (await canLaunchUrl(marketUri)) {
          await launchUrl(marketUri, mode: LaunchMode.externalApplication);
          return;
        }
        final webUri = Uri.parse('https://play.google.com/store/apps/details?id=com.khwenden.ibrahim');
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
        return;
      } else if (Platform.isIOS) {
        // Direct App Store intent or web URL
        final appStoreUri = Uri.parse('itms-apps://itunes.apple.com/app/id6783074135');
        if (await canLaunchUrl(appStoreUri)) {
          await launchUrl(appStoreUri, mode: LaunchMode.externalApplication);
          return;
        }
        final webUri = Uri.parse('https://apps.apple.com/iq/app/edubook-iq/id6783074135');
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching store: $e');
    }
  }

  Future<void> _submitFeedback() async {
    final l = AppLocalizations.of(context);
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final comment = _commentCtrl.text.trim();

    setState(() => _isLoading = true);

    try {
      final info = await PackageInfo.fromPlatform();

      final res = await ApiService().submitAppFeedback(
        rating: _rating,
        feedbackType: 'general',
        comment: comment.isNotEmpty ? comment : null,
        platform: Platform.isIOS ? 'ios' : 'android',
        appVersion: '${info.version} (${info.buildNumber})',
        userName: user?.name,
        userPhone: user?.phone,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (res.success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('app_feedback_submitted', true);
        if (!mounted) return;
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.feedbackSentSuccess,
                    style: const TextStyle(
                      fontFamily: 'Rabar',
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res.error ?? l.somethingWentWrong,
              style: const TextStyle(fontFamily: 'Rabar'),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e', style: const TextStyle(fontFamily: 'Rabar')),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 390),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header Row
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                        child: Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 28),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.howDoYouLikeApp,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              fontFamily: 'Rabar',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l.rateAppSubtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              fontFamily: 'Rabar',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded,
                          size: 22, color: isDark ? Colors.white54 : Colors.grey.shade600),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Star Rating Container
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final starNum = index + 1;
                          final isSelected = starNum <= _rating;
                          return GestureDetector(
                            onTap: () => setState(() => _rating = starNum),
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                                color: isSelected ? const Color(0xFFF59E0B) : Colors.grey.shade400,
                                size: 36,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getRatingTitle(l, _rating),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF59E0B),
                          fontFamily: 'Rabar',
                        ),
                      ),
                    ],
                  ),
                ),

                // 4 or 5 stars Store redirect button
                if (_rating >= 4) ...[
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: _openStore,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.open_in_new_rounded, color: AppColors.primary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              l.rateStoreBtn,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                fontFamily: 'Rabar',
                              ),
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Feedback prompt label
                Text(
                  l.feedbackPrompt,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    fontFamily: 'Rabar',
                  ),
                ),
                const SizedBox(height: 8),

                // Text Input
                TextField(
                  controller: _commentCtrl,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 13.5,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                  decoration: InputDecoration(
                    hintText: l.feedbackPlaceholder,
                    hintStyle: TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 12,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFF59E0B), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),

                const SizedBox(height: 18),

                // Submit Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF59E0B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: const Size.fromHeight(50),
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              l.sendFeedback,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Rabar',
                                height: 1.2,
                              ),
                            ),
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
}
