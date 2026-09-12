import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';

class AppUpdateDialog extends StatelessWidget {
  final Map<String, dynamic> updateData;
  final bool force;

  const AppUpdateDialog({
    super.key,
    required this.updateData,
    this.force = false,
  });

  /// Static helper to display the update dialog conveniently
  static Future<void> show(
    BuildContext context, {
    required Map<String, dynamic> updateData,
    required bool force,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: !force,
      builder: (ctx) => AppUpdateDialog(
        updateData: updateData,
        force: force,
      ),
    );
  }

  Future<void> _openStore(BuildContext context, String? customUrl) async {
    final l = AppLocalizations.of(context);
    String targetUrl = customUrl?.trim() ?? '';

    if (targetUrl.isEmpty) {
      if (Platform.isAndroid) {
        targetUrl = 'https://play.google.com/store/apps/details?id=com.khwenden.ibrahim';
      } else if (Platform.isIOS) {
        targetUrl = 'https://apps.apple.com';
      }
    }

    try {
      final uri = Uri.parse(targetUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback for Android market intent
        if (Platform.isAndroid) {
          final marketUri = Uri.parse('market://details?id=com.khwenden.ibrahim');
          if (await canLaunchUrl(marketUri)) {
            await launchUrl(marketUri, mode: LaunchMode.externalApplication);
            return;
          }
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.updateOpenStoreFailed, style: const TextStyle(fontFamily: 'Rabar')),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching store URL: $e');
    }
  }

  String _getReleaseNotes(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = l.languageCode;

    if (lang == 'ar' && (updateData['release_notes_ar']?.toString().trim().isNotEmpty ?? false)) {
      return updateData['release_notes_ar'];
    }
    if (lang == 'en' && (updateData['release_notes_en']?.toString().trim().isNotEmpty ?? false)) {
      return updateData['release_notes_en'];
    }

    final soraniNotes = updateData['release_notes']?.toString().trim();
    if (soraniNotes != null && soraniNotes.isNotEmpty) {
      return soraniNotes;
    }

    return l.forceUpdateDesc;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final latestVersion = updateData['latest_version']?.toString() ?? '1.1.0';
    final storeUrl = updateData['store_url']?.toString();
    final releaseNotes = _getReleaseNotes(context);

    return PopScope(
      canPop: !force,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(28),
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
              // Header with gradient banner
              Container(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                decoration: BoxDecoration(
                  gradient: force
                      ? const LinearGradient(
                          colors: [Color(0xFFDC2626), Color(0xFFEF4444), Color(0xFFF97316)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : const LinearGradient(
                          colors: [AppColors.primary, Color(0xFF3B82F6), Color(0xFF6366F1)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                      ),
                      child: Center(
                        child: Icon(
                          force ? Icons.system_update_rounded : Icons.rocket_launch_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      force ? l.forceUpdateTitle : l.updateAvailable,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'Rabar',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'v$latestVersion • ${force ? l.forceUpdateTitle : l.updateAvailable}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Rabar',
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content Area
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        force ? l.forceUpdateDesc : l.updateDesc,
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                          fontFamily: 'Rabar',
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Release Notes Container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 16,
                                  color: force ? const Color(0xFFEF4444) : AppColors.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l.whatsNew,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    fontFamily: 'Rabar',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              releaseNotes,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontFamily: 'Rabar',
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _openStore(context, storeUrl),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: force ? const Color(0xFFDC2626) : AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.download_rounded, color: Colors.white, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              l.updateNow,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'Rabar',
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!force) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            l.later,
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Rabar',
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
