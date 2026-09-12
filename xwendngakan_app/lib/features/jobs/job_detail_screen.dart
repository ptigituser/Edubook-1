import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/job_vacancy_model.dart';
import '../../data/services/api_service.dart';

class JobDetailScreen extends StatefulWidget {
  final int jobId;
  final JobVacancyModel? initialJob;

  const JobDetailScreen({
    super.key,
    required this.jobId,
    this.initialJob,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final ApiService _api = ApiService();
  JobVacancyModel? _job;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _job = widget.initialJob;
    if (_job == null) {
      _fetchDetail();
    }
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final res = await _api.getJobVacancyDetail(widget.jobId);
    if (mounted) {
      setState(() {
        _loading = false;
        if (res.success && res.data != null) {
          _job = res.data;
        } else {
          _error = res.error ?? 'هەڵە لە هێنانی زانیاری';
        }
      });
    }
  }

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phone, String jobTitle, String institutionName) async {
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanPhone.startsWith('07')) {
      cleanPhone = '+964${cleanPhone.substring(1)}';
    } else if (!cleanPhone.startsWith('+') && !cleanPhone.startsWith('964')) {
      cleanPhone = '+964$cleanPhone';
    }

    final message = Uri.encodeComponent(
      'سڵاو، پەیوەندیدار بە هەلی کاری ($jobTitle) لە ($institutionName) لە ڕێگەی ئەپی خوێندنگاکان پەیوەندیتان پێوە دەکەم.',
    );
    final uri = Uri.parse('https://wa.me/$cleanPhone?text=$message');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _shareJob(JobVacancyModel job) {
    final text = '''
📢 هەلی کاری نوێ: ${job.title}
🏛️ دامەزراوە: ${job.institutionName}
📍 شار: ${job.city}
💼 جۆری دەوام: ${job.employmentType}
📞 پەیوەندی: ${job.contactPhone}

بینینی تەواوی وردەکاری لە ڕێگەی ئەپی Edubook خوێندنگاکان:
https://edubook-iq.com
''';
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    if (_loading && _job == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_error != null && _job == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkCard : Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                style: const TextStyle(fontFamily: 'Rabar'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(l.retry, style: const TextStyle(fontFamily: 'Rabar')),
              )
            ],
          ),
        ),
      );
    }

    final job = _job!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.jobDetails,
          style: const TextStyle(
            fontFamily: 'Rabar',
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, size: 22),
            onPressed: () => _shareJob(job),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Card (Institution & Title) ──
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Institution Logo
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: job.institutionLogo != null && job.institutionLogo!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: job.institutionLogo!,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => const Center(
                                        child: Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(Icons.school_rounded, color: AppColors.primary, size: 28),
                                  ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.institutionName,
                                  style: TextStyle(
                                    fontFamily: 'Rabar',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white70 : AppColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 3),
                                    Text(
                                      job.city,
                                      style: const TextStyle(
                                        fontFamily: 'Rabar',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    if (job.viewsCount > 0) ...[
                                      const SizedBox(width: 12),
                                      Icon(Icons.remove_red_eye_rounded, size: 14, color: Colors.grey.shade500),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${job.viewsCount}',
                                        style: TextStyle(
                                          fontFamily: 'Rabar',
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      Text(
                        job.title,
                        style: const TextStyle(
                          fontFamily: 'Rabar',
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildBadge(
                            icon: Icons.work_rounded,
                            label: job.getEmploymentTypeLabel(l),
                            color: const Color(0xFF0284C7),
                            isDark: isDark,
                          ),
                          _buildBadge(
                            icon: Icons.category_rounded,
                            label: job.getCategoryLabel(l),
                            color: const Color(0xFF8B5CF6),
                            isDark: isDark,
                          ),
                          if (job.subject != null && job.subject!.isNotEmpty)
                            _buildBadge(
                              icon: Icons.book_rounded,
                              label: job.subject!,
                              color: const Color(0xFF10B981),
                              isDark: isDark,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Overview Details Grid ──
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        icon: Icons.payments_rounded,
                        title: l.salary,
                        value: (job.salaryRange != null && job.salaryRange!.isNotEmpty)
                            ? job.salaryRange!
                            : l.salaryNegotiable,
                        iconColor: const Color(0xFF10B981),
                        isDark: isDark,
                      ),
                      const Divider(height: 20),
                      _buildInfoRow(
                        icon: Icons.person_rounded,
                        title: l.genderPreference,
                        value: job.getGenderLabel(l),
                        iconColor: const Color(0xFFEC4899),
                        isDark: isDark,
                      ),
                      if (job.experienceYears != null && job.experienceYears!.isNotEmpty) ...[
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.history_edu_rounded,
                          title: l.experienceYears,
                          value: job.experienceYears!,
                          iconColor: const Color(0xFFF59E0B),
                          isDark: isDark,
                        ),
                      ],
                      if (job.educationLevel != null && job.educationLevel!.isNotEmpty) ...[
                        const Divider(height: 20),
                        _buildInfoRow(
                          icon: Icons.school_rounded,
                          title: l.educationStage,
                          value: job.educationLevel!,
                          iconColor: const Color(0xFF6366F1),
                          isDark: isDark,
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ── Job Description ──
                Text(
                  l.jobDescription,
                  style: const TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Text(
                    job.description,
                    style: TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                ),

                // ── Requirements ──
                if (job.requirements != null && job.requirements!.trim().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    l.requirements,
                    style: const TextStyle(
                      fontFamily: 'Rabar',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Text(
                      job.requirements!,
                      style: TextStyle(
                        fontFamily: 'Rabar',
                        fontSize: 14,
                        height: 1.6,
                        color: isDark ? Colors.white70 : const Color(0xFF334155),
                      ),
                    ),
                  ),
                ],

                // ── Institution profile link button if exists ──
                if (job.institutionId != null) ...[
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => context.push('/institutions/${job.institutionId}'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: AppColors.primary, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${l.viewInstitutionProfile} (${job.institutionName})',
                          style: const TextStyle(
                            fontFamily: 'Rabar',
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Sticky Bottom Action Bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Call Now Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () => _makeCall(job.contactPhone),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.call_rounded, size: 20, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            l.callNow,
                            style: const TextStyle(
                              fontFamily: 'Rabar',
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // WhatsApp Button (if phone/whatsapp provided)
                  if (job.contactWhatsapp != null && job.contactWhatsapp!.isNotEmpty ||
                      job.contactPhone.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () => _openWhatsApp(
                          (job.contactWhatsapp != null && job.contactWhatsapp!.isNotEmpty)
                              ? job.contactWhatsapp!
                              : job.contactPhone,
                          job.title,
                          job.institutionName,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.chat_bubble_rounded, size: 18, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              l.sendWhatsapp,
                              style: const TextStyle(
                                fontFamily: 'Rabar',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Rabar',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Rabar',
                fontSize: 12,
                color: isDark ? Colors.white54 : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Rabar',
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
