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
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Icon Badge
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: force
                        ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                        : [AppColors.primary, const Color(0xFF3B82F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (force ? const Color(0xFFEF4444) : AppColors.primary)
                          .withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.system_update_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                force ? l.forceUpdateTitle : l.updateAvailable,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontFamily: 'Rabar',
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),

              // Version Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: (force ? const Color(0xFFEF4444) : AppColors.primary)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'v$latestVersion',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: force ? const Color(0xFFEF4444) : AppColors.primary,
                    fontFamily: 'Rabar',
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Description or Release Note (Concise & Compact)
              Text(
                releaseNotes.isNotEmpty ? releaseNotes : (force ? l.forceUpdateDesc : l.updateDesc),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  fontFamily: 'Rabar',
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _openStore(context, storeUrl),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: force ? const Color(0xFFDC2626) : AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.download_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l.updateNow,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Rabar',
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Optional Dismiss button if not force
              if (!force) ...[
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l.later,
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rabar',
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
