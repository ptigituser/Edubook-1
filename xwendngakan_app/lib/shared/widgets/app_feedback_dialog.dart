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

  static Future<void> show(BuildContext context, {int initialRating = 5}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AppFeedbackDialog(initialRating: initialRating),
    );
  }

  @override
  State<AppFeedbackDialog> createState() => _AppFeedbackDialogState();
}

class _AppFeedbackDialogState extends State<AppFeedbackDialog> {
  late int _rating;
  String _selectedCategory = 'general';
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
      final url = Platform.isIOS
          ? 'https://apps.apple.com'
          : 'https://play.google.com/store/apps/details?id=com.khwenden.ibrahim';
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (Platform.isAndroid) {
        final marketUri = Uri.parse('market://details?id=com.khwenden.ibrahim');
        if (await canLaunchUrl(marketUri)) {
          await launchUrl(marketUri, mode: LaunchMode.externalApplication);
        }
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
        feedbackType: _selectedCategory,
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
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.feedbackSentSuccess,
                    style: const TextStyle(fontFamily: 'Rabar', fontWeight: FontWeight.bold),
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
            content: Text(res.error ?? l.somethingWentWrong, style: const TextStyle(fontFamily: 'Rabar')),
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 25,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Top Title & Icon
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.star_rounded, color: Colors.white, size: 28),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.howDoYouLikeApp,
                        style: TextStyle(
                          fontSize: 18,
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
                  icon: Icon(Icons.close_rounded, color: isDark ? Colors.white54 : Colors.black45),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Star Rating Section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
                        onTap: () {
                          setState(() => _rating = starNum);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: isSelected ? const Color(0xFFF59E0B) : Colors.grey.shade400,
                            size: 42,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      _getRatingTitle(l, _rating),
                      key: ValueKey<int>(_rating),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFF59E0B),
                        fontFamily: 'Rabar',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // High rating: Store Redirect Option
            if (_rating >= 4) ...[
              const SizedBox(height: 14),
              InkWell(
                onTap: _openStore,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.12),
                        const Color(0xFF3B82F6).withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.open_in_new_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l.rateStoreBtn,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontFamily: 'Rabar',
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Feedback prompt header: "چ سەرنج و تێبینیت هەیە بۆمان بنوسە"
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.feedbackPrompt,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontFamily: 'Rabar',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Category Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CategoryChip(
                    label: l.feedbackSuggestion,
                    value: 'suggestion',
                    selectedValue: _selectedCategory,
                    onSelected: (val) => setState(() => _selectedCategory = val),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: l.feedbackGeneral,
                    value: 'general',
                    selectedValue: _selectedCategory,
                    onSelected: (val) => setState(() => _selectedCategory = val),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: l.feedbackBug,
                    value: 'bug',
                    selectedValue: _selectedCategory,
                    onSelected: (val) => setState(() => _selectedCategory = val),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _CategoryChip(
                    label: l.feedbackPraise,
                    value: 'praise',
                    selectedValue: _selectedCategory,
                    onSelected: (val) => setState(() => _selectedCategory = val),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Text Field
            TextField(
              controller: _commentCtrl,
              maxLines: 4,
              maxLength: 1000,
              style: TextStyle(
                fontFamily: 'Rabar',
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: l.feedbackPlaceholder,
                hintStyle: TextStyle(
                  fontFamily: 'Rabar',
                  fontSize: 13,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 14),

            // Submit Button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l.sendFeedback,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Rabar',
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onSelected;
  final bool isDark;

  const _CategoryChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;

    return GestureDetector(
      onTap: () => onSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
            fontFamily: 'Rabar',
          ),
        ),
      ),
    );
  }
}
