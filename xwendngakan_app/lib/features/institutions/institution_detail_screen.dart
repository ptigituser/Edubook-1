import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/html_utils.dart';
import '../../core/utils/tuition_utils.dart';
import '../../data/models/institution_model.dart';
import '../../data/models/post_model.dart';
import '../../data/models/review_model.dart';
import '../../data/models/job_vacancy_model.dart';
import '../../data/services/api_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/institutions_provider.dart';
import '../../providers/locale_provider.dart';
import '../../shared/widgets/common_widgets.dart';
import 'institution_chat_screen.dart';

class InstitutionDetailScreen extends StatefulWidget {
  final String id;
  const InstitutionDetailScreen({super.key, required this.id});

  @override
  State<InstitutionDetailScreen> createState() =>
      _InstitutionDetailScreenState();
}

enum _DetailTab { about, departments, news, reviews }

class _InstitutionDetailScreenState extends State<InstitutionDetailScreen> {
  final _api = ApiService();
  InstitutionModel? _institution;
  bool _loading = true;
  String? _error;
  _DetailTab _activeTab = _DetailTab.about;
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  ReviewsData? _reviewsData;
  bool _loadingReviews = false;
  String? _reviewsError;

  List<JobVacancyModel> _institutionJobs = [];

  @override
  void initState() {
    super.initState();
    _load();
    _loadReviews();
    _loadJobs();
    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showTitle) {
        setState(() => _showTitle = true);
      } else if (_scrollController.offset <= 200 && _showTitle) {
        setState(() => _showTitle = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    final instId = int.tryParse(widget.id) ?? 0;
    if (instId == 0) return;
    final r = await _api.getJobVacancies(institutionId: widget.id);
    if (!mounted) return;
    if (r.success && r.data != null) {
      setState(() {
        _institutionJobs = r.data!;
      });
    }
  }

  Future<void> _load() async {
    final r = await _api.getInstitution(int.tryParse(widget.id) ?? 0);
    if (!mounted) return;
    if (r.success && r.data != null) {
      setState(() {
        _institution = r.data;
        _loading = false;
      });
    } else {
      setState(() {
        _error = r.error;
        _loading = false;
      });
    }
  }

  Future<void> _loadReviews() async {
    final instId = int.tryParse(widget.id) ?? 0;
    if (instId == 0) return;
    setState(() => _loadingReviews = true);
    final r = await _api.getInstitutionReviews(instId);
    if (!mounted) return;
    if (r.success && r.data != null) {
      setState(() {
        _reviewsData = r.data;
        _loadingReviews = false;
      });
    } else {
      setState(() {
        _reviewsError = r.error;
        _loadingReviews = false;
      });
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      _load(),
      _loadReviews(),
      _loadJobs(),
    ]);
  }

  /// Returns the best available description for the current language.
  String? _resolveDesc(InstitutionModel inst, String lang) {
    switch (lang) {
      case 'kbd':
        return inst.descKbd?.isNotEmpty == true ? inst.descKbd : inst.desc;
      case 'en':
        return inst.descEn?.isNotEmpty == true ? inst.descEn : inst.desc;
      case 'ar':
        return inst.descAr?.isNotEmpty == true ? inst.descAr : inst.desc;
      default:
        return inst.desc;
    }
  }

  /// Converts stored rich-text/HTML into clean, readable plain text.
  /// Block tags become line breaks, the rest are stripped, and common
  /// HTML entities are decoded so nothing like `<p>` ever shows on screen.
  String _cleanHtml(String input) => HtmlUtils.toPlainText(input);

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Provider.of<LocaleProvider>(context);
    final prov = Provider.of<InstitutionsProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = locale.locale.languageCode;

    if (_loading) {
      return _buildShimmerLoading(context, isDark);
    }

    if (_error != null || _institution == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.institutions)),
        body: EmptyState(
          icon: Icons.error_outline_rounded,
          message: _error ?? 'Not found',
          actionLabel: l.retry,
          onAction: () => _load(),
        ),
      );
    }

    final inst = _institution!;
    final showDeptTab = _hasDepartments(inst);
    if (!showDeptTab && _activeTab == _DetailTab.departments) {
      _activeTab = _DetailTab.about;
    }
    final typeColor = AppColors.typeColor(inst.type);
    final isFav = prov.favorites.contains(inst.id);

    return Scaffold(
        backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFFBFBFE),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openChat(inst, l),
          backgroundColor: AppColors.primary,
          elevation: 4,
          icon: const Icon(Icons.forum_rounded, color: Colors.white, size: 20),
          label: Text(
            l.chatWithInstitution,
            style: const TextStyle(
              fontFamily: 'Rabar',
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: Colors.white,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshAll,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              // ── Premium Sliver Header ──
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                stretch: true,
                backgroundColor: typeColor,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.15),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white, size: 18),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.15),
                          child: IconButton(
                            icon: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isFav ? Colors.redAccent : Colors.white,
                              size: 22,
                            ),
                            onPressed: () => prov.toggleFavorite(inst.id),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _showTitle ? 1.0 : 0.0,
                  child: Text(
                    inst.name(lang),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Rabar',
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground],
                  background: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(40)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Cover image background
                        if (inst.imgUrl.isNotEmpty)
                          CachedNetworkImage(
                            imageUrl: inst.imgUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: typeColor),
                            errorWidget: (_, __, ___) =>
                                Container(color: typeColor),
                          )
                        else
                          Container(color: typeColor),
                        // Dark gradient overlay for legibility
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.1),
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        // Logo positioned nicely at the bottom
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: inst.logoUrl.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: inst.logoUrl,
                                        fit: BoxFit.contain,
                                        placeholder: (_, __) => Icon(
                                            Icons.school_rounded,
                                            color: typeColor,
                                            size: 40),
                                        errorWidget: (_, __, ___) => Icon(
                                            Icons.school_rounded,
                                            color: typeColor,
                                            size: 40),
                                      )
                                    : Icon(Icons.school_rounded,
                                        color: typeColor, size: 40),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // ── Name & Info ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            inst.name(lang),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Rabar',
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          _buildRatingHeaderBadge(inst, isDark, l),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Video Card ──
                    if (inst.video != null && inst.video!.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: RepaintBoundary(
                          child: _VideoCard(
                            videoUrl: inst.video!,
                            isDark: isDark,
                            typeColor: typeColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],

                    // ── Links & Actions Bar ──
                    _buildLinksAndActions(inst, l, isDark),
                    const SizedBox(height: 32),

                    // ── Premium Tab Switcher ──
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.03),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.2 : 0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildTabItem(_DetailTab.about, l.about, isDark),
                          if (showDeptTab)
                            _buildTabItem(
                                _DetailTab.departments, l.departments, isDark),
                          _buildTabItem(_DetailTab.news, l.news, isDark),
                          _buildTabItem(
                              _DetailTab.reviews, l.reviewsTab, isDark),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Tab Content ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: RepaintBoundary(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: KeyedSubtree(
                            key: ValueKey(_activeTab),
                            child: _buildTabContent(inst, isDark, lang, l),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            fontFamily: 'Rabar',
          ),
        ),
      ],
    );
  }

  void _openChat(InstitutionModel inst, AppLocalizations l) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isAuthenticated) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'چات لەگەڵ دامەزراوە',
            style: TextStyle(fontFamily: 'Rabar', fontWeight: FontWeight.w900),
          ),
          content: const Text(
            'تکایە سەرەتا بچۆ ژوورەوە بۆ ئەوەی بتوانیت نامە بنێریت بۆ دامەزراوەکە.',
            style: TextStyle(fontFamily: 'Rabar', fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel, style: const TextStyle(fontFamily: 'Rabar')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/login');
              },
              child: Text(l.login,
                  style: const TextStyle(
                      fontFamily: 'Rabar', fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InstitutionChatScreen(institution: inst),
      ),
    );
  }

  bool _hasDepartments(InstitutionModel inst) {
    final t = (inst.type ?? '').toLowerCase().trim();
    final name = (inst.nku ?? inst.nen ?? inst.nar ?? '').toLowerCase();

    // Explicitly exclude schools, kindergartens, daycares, language centers
    if (t == 'school' ||
        t == 'kg' ||
        t == 'dc' ||
        t == 'kindergarten' ||
        t == 'daycare' ||
        t == 'lang' ||
        t == 'language_center' ||
        t == 'edu') {
      return false;
    }

    // Explicitly include all types of universities and institutes (gov, priv, inst2, inst5, eve_inst, eve_uni, etc.)
    if (t == 'inst2' ||
        t == 'inst5' ||
        t == 'eve_inst' ||
        t == 'institute' ||
        t == 'gov' ||
        t == 'priv' ||
        t == 'eve_uni' ||
        t == 'university') {
      return true;
    }

    // Name-based check for institutes and universities
    if (name.contains('پەیمانگا') ||
        name.contains('پەیمانگەی') ||
        name.contains('زانکۆ') ||
        name.contains('کۆلێژ') ||
        name.contains('institute') ||
        name.contains('university')) {
      return true;
    }

    // Name-based check for daycares, kindergartens, schools
    if (name.contains('دایەنگە') ||
        name.contains('دایەنگەی') ||
        name.contains('باخچە') ||
        name.contains('مەکتەب') ||
        name.contains('قوتابخانە')) {
      return false;
    }

    // Fallback: check if department or college data exists
    return (inst.colleges != null && inst.colleges!.trim().isNotEmpty) ||
        (inst.depts != null && inst.depts!.trim().isNotEmpty);
  }

  Widget _buildLinksAndActions(
      InstitutionModel inst, AppLocalizations l, bool isDark) {
    final items = <Widget>[];

    void add(IconData icon, String label, Color color, VoidCallback onTap) {
      items.add(_buildActionItem(
          icon: icon, label: label, color: color, onTap: onTap));
    }

    add(Icons.forum_rounded, l.chat, const Color(0xFFF59E0B),
        () => _openChat(inst, l));

    if (inst.phone != null && inst.phone!.isNotEmpty) {
      add(Icons.phone_in_talk_rounded, l.contact, const Color(0xFF10B981),
          () => _launch('tel:${inst.phone!}'));
    }

    add(Icons.map_rounded, l.map, const Color(0xFFEC4899),
        () => context.push('/map', extra: inst));

    if (inst.web != null && inst.web!.isNotEmpty) {
      add(Icons.language_rounded, 'Website', const Color(0xFF6366F1),
          () => _launch(inst.web!));
    }
    if (inst.fb != null && inst.fb!.isNotEmpty) {
      add(Icons.facebook, 'Facebook', const Color(0xFF1877F2),
          () => _launch(inst.fb!));
    }
    if (inst.tg != null && inst.tg!.isNotEmpty) {
      add(Icons.telegram_rounded, 'Telegram', const Color(0xFF229ED9),
          () => _launch(inst.tg!));
    }
    if (inst.wa != null && inst.wa!.isNotEmpty) {
      add(Icons.chat_bubble_outline_rounded, 'WhatsApp',
          const Color(0xFF25D366), () => _launch('https://wa.me/${inst.wa}'));
    }
    if (inst.yt != null && inst.yt!.isNotEmpty) {
      add(Icons.play_circle_fill_rounded, 'YouTube', const Color(0xFFFF0000),
          () => _launch(inst.yt!));
    }
    if (inst.tk != null && inst.tk!.isNotEmpty) {
      add(Icons.music_note_rounded, 'TikTok', const Color(0xFF010101),
          () => _launch(inst.tk!));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: e,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTabItem(_DetailTab tab, String label, bool isDark) {
    final isActive = _activeTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
              fontFamily: 'Rabar',
              color: isActive
                  ? Colors.white
                  : (isDark
                      ? Colors.white60
                      : AppColors.textDark.withValues(alpha: 0.6)),
            ),
          ),
        ),
      ),
    );
  }

  /// Treats placeholder/empty payloads ("null", "[]", "{}") as no value.
  String? _clean(String? v) {
    if (v == null) return null;
    final t = v.trim();
    if (t.isEmpty || t == 'null' || t == '[]' || t == '{}') return null;
    return t;
  }

  /// Fees & services section — only rendered when at least one field is filled.
  Widget _buildServicesSection(InstitutionModel inst, bool isDark) {
    final accent = AppColors.typeColor(inst.type);
    final rows = <Widget>[];
    void add(IconData icon, String label, String? value) {
      final v = _clean(value);
      if (v == null) return;
      if (rows.isNotEmpty) {
        rows.add(Divider(
          height: 20,
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ));
      }
      rows.add(_InfoRow(
          icon: icon, label: label, value: v, accent: accent, isDark: isDark));
    }

    add(Icons.school_rounded, 'ئاستی خوێندن', inst.level);
    add(Icons.payments_rounded, 'خەرجی', inst.fee);
    // tuitionPlans is shown per-department in the Colleges tab — skip raw JSON here
    add(Icons.restaurant_rounded, 'خواردن', inst.meal);
    add(Icons.checkroom_rounded, 'جلوبەرگ', inst.uniform);
    add(Icons.menu_book_rounded, 'پەرتووک', inst.books);

    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _AcademicSection(
          icon: Icons.account_balance_wallet_rounded,
          title: 'خەرجی و خزمەتگوزاری',
          accentColor: accent,
          isDark: isDark,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: rows),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// Kindergarten info section — only rendered when at least one field is filled.
  Widget _buildKindergartenSection(InstitutionModel inst, bool isDark) {
    final accent = AppColors.typeColor(inst.type);
    final rows = <Widget>[];
    void add(IconData icon, String label, String? value) {
      final v = _clean(value);
      if (v == null) return;
      if (rows.isNotEmpty) {
        rows.add(Divider(
          height: 20,
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        ));
      }
      rows.add(_InfoRow(
          icon: icon, label: label, value: v, accent: accent, isDark: isDark));
    }

    add(Icons.cake_rounded, 'تەمەنی وەرگرتن', inst.kgAge);
    add(Icons.access_time_rounded, 'کاتژمێرەکانی خوێندن', inst.kgHours);
    add(Icons.payments_rounded, 'خەرجی', inst.kgFee);
    add(Icons.restaurant_rounded, 'خواردن', inst.kgMeal);
    add(Icons.checkroom_rounded, 'جلوبەرگ', inst.kgUniform);

    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        _AcademicSection(
          icon: Icons.child_care_rounded,
          title: 'زانیاری باخچەی منداڵان',
          accentColor: accent,
          isDark: isDark,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: rows),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// Active job vacancies posted by this institution
  Widget _buildInstitutionJobsSection(bool isDark, AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        children: [
          for (var i = 0; i < _institutionJobs.length; i++) ...[
            Builder(builder: (context) {
              final job = _institutionJobs[i];
              return InkWell(
                onTap: () => context.push(
                  '/jobs/${job.id}',
                  extra: job,
                ),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.work_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              job.title,
                              style: const TextStyle(
                                fontFamily: 'Rabar',
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                if (job.subject != null &&
                                    job.subject!.isNotEmpty)
                                  Text(
                                    job.subject!,
                                    style: TextStyle(
                                      fontFamily: 'Rabar',
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.white60
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    job.getEmploymentTypeLabel(l),
                                    style: const TextStyle(
                                      fontFamily: 'Rabar',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (i < _institutionJobs.length - 1)
              Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.05),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabContent(
      InstitutionModel inst, bool isDark, String lang, AppLocalizations l) {
    switch (_activeTab) {
      case _DetailTab.about:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            _StatsRow(isDark: isDark, inst: inst),
            const SizedBox(height: 20),

            // Description — show the right language variant
            Builder(builder: (context) {
              final raw = _resolveDesc(inst, lang);
              final desc = raw == null ? '' : _cleanHtml(raw);
              if (desc.isEmpty) return const SizedBox.shrink();
              return Column(
                children: [
                  _AcademicSection(
                    icon: Icons.info_outline_rounded,
                    title: l.about,
                    accentColor: AppColors.typeColor(inst.type),
                    isDark: isDark,
                    child: Text(
                      desc,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.9,
                        fontFamily: 'Rabar',
                        color: isDark
                            ? Colors.white70
                            : AppColors.textDark.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            }),

            // Fees & services (only the fields the institution actually filled)
            _buildServicesSection(inst, isDark),
            // Kindergarten-specific info
            _buildKindergartenSection(inst, isDark),

            // Open Job Vacancies posted by this institution
            if (_institutionJobs.isNotEmpty) ...[
              _AcademicSection(
                icon: Icons.work_rounded,
                title: '${l.jobVacancies} (${_institutionJobs.length})',
                accentColor: AppColors.typeColor(inst.type),
                isDark: isDark,
                child: _buildInstitutionJobsSection(isDark, l),
              ),
              const SizedBox(height: 20),
            ],

            // Contact & Social
            _AcademicSection(
              icon: Icons.contact_page_rounded,
              title: l.contact,
              accentColor: AppColors.typeColor(inst.type),
              isDark: isDark,
              child:
                  _ContactCard(inst: inst, isDark: isDark, onLaunch: _launch),
            ),
          ],
        );
      case _DetailTab.departments:
        final colleges = _parseColleges(inst.colleges, lang);
        final depts = _parseDepts(inst.depts, lang);
        // Build a dept-name → {fee,discount} lookup from tuition_plans
        final tuitionMap = _buildTuitionMap(inst.tuitionPlans);
        final strDiscount =
            lang == 'en' ? 'Discount' : (lang == 'ar' ? 'خصم' : 'داشکان');
        if (colleges.isEmpty && depts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: EmptyState(
              icon: Icons.account_balance_outlined,
              message: l.noInformation,
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The departments section below already lists everything (with fees),
            // so the college cards only stand in when there is no dept list at all.
            if (depts.isEmpty && colleges.isNotEmpty)
              _CollegesCard(colleges: colleges, isDark: isDark),
            if (depts.isNotEmpty) ...[
              _AcademicSection(
                icon: Icons.menu_book_rounded,
                title: l.departments,
                accentColor: AppColors.typeColor(inst.type),
                isDark: isDark,
                child: Column(
                  children: [
                    for (var i = 0; i < depts.length; i++)
                      _DeptRow(
                        name: depts[i]['translated'] ??
                            depts[i]['original'] ??
                            '',
                        price: tuitionMap[depts[i]['original']] ??
                            TuitionPrice.empty,
                        accent: AppColors.typeColor(inst.type),
                        isDark: isDark,
                        discountLabel: strDiscount,
                        showDivider: i < depts.length - 1,
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      case _DetailTab.news:
        if (inst.posts.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: EmptyState(
              icon: Icons.article_outlined,
              message: l.noPosts,
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: inst.posts.length,
          itemBuilder: (context, index) =>
              _PostCard(post: inst.posts[index], isDark: isDark),
        );
      case _DetailTab.reviews:
        return _buildReviewsTab(inst, isDark, lang, l);
    }
  }

  Widget _buildRatingHeaderBadge(
      InstitutionModel inst, bool isDark, AppLocalizations l) {
    final double rating = _reviewsData?.summary.averageRating ?? inst.ratingAvg;

    return GestureDetector(
      onTap: () => setState(() => _activeTab = _DetailTab.reviews),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.amber.withValues(alpha: 0.12)
              : const Color(0xFFFFF9E6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.amber.withValues(alpha: 0.3)
                : const Color(0xFFFFD54F),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: isDark ? 0.1 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 20),
            const SizedBox(width: 5),
            Text(
              rating > 0 ? rating.toStringAsFixed(1) : '0.0',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color:
                    isDark ? const Color(0xFFFFCA28) : const Color(0xFFB78103),
                fontFamily: 'Rabar',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsTab(
      InstitutionModel inst, bool isDark, String lang, AppLocalizations l) {
    if (_loadingReviews && _reviewsData == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child:
              CircularProgressIndicator(color: AppColors.typeColor(inst.type)),
        ),
      );
    }

    if (_reviewsError != null && _reviewsData == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: EmptyState(
          icon: Icons.error_outline_rounded,
          message: _reviewsError!,
          actionLabel: l.retry,
          onAction: _loadReviews,
        ),
      );
    }

    final summary = _reviewsData?.summary ??
        ReviewSummaryModel(
          averageRating: inst.ratingAvg,
          totalReviews: inst.reviewsCount,
          distribution: {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
        );
    final userReview = _reviewsData?.userReview;
    final rawReviews = _reviewsData?.reviews ?? [];
    final reviews = List<ReviewModel>.from(rawReviews);
    if (userReview != null) {
      reviews.sort((a, b) {
        if (a.id == userReview.id) return -1;
        if (b.id == userReview.id) return 1;
        return 0;
      });
    }
    final accentColor = AppColors.typeColor(inst.type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Rating Breakdown Summary Card ──
        _buildRatingSummaryCard(summary, isDark, l),

        // ── "Write Review" button (only shown if user hasn't reviewed yet) ──
        if (userReview == null) ...[
          const SizedBox(height: 18),
          _buildWriteReviewButton(inst, l),
        ],
        const SizedBox(height: 24),

        // ── Reviews List Header ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.rate_review_rounded, size: 20, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  l.reviews,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Rabar',
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${summary.totalReviews}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  fontFamily: 'Rabar',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ── Reviews List / Empty State ──
        if (reviews.isEmpty)
          _buildEmptyReviewsState(inst, isDark, l)
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final rev = reviews[index];
              final isMyReview = userReview?.id == rev.id;
              return _buildReviewCard(
                  inst, rev, isMyReview, isDark, accentColor, l);
            },
          ),
      ],
    );
  }

  Widget _buildRatingSummaryCard(
      ReviewSummaryModel summary, bool isDark, AppLocalizations l) {
    final total = summary.totalReviews;
    final rating = summary.averageRating;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left: Score & Stars
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rating > 0 ? rating.toStringAsFixed(1) : '0.0',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Rabar',
                    color: Color(0xFFFFB300),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                RatingBarIndicator(
                  rating: rating,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFFB300),
                  ),
                  itemCount: 5,
                  itemSize: 18.0,
                  unratedColor: Colors.amber.withValues(alpha: 0.2),
                ),
                const SizedBox(height: 6),
                Text(
                  '$total ${total == 1 ? l.review : l.reviews}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rabar',
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                ),
              ],
            ),
          ),

          // Middle Divider
          Container(
            height: 90,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),

          // Right: Star distribution bars
          Expanded(
            flex: 6,
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = summary.distribution[star] ?? 0;
                final ratio = total > 0 ? (count / total) : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Rabar',
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.star_rounded,
                          size: 12, color: Color(0xFFFFB300)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 6,
                            backgroundColor: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : Colors.black.withValues(alpha: 0.05),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFFFB300)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 22,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Rabar',
                            color: isDark ? Colors.white38 : Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWriteReviewButton(InstitutionModel inst, AppLocalizations l) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showReviewBottomSheet(inst),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.rate_review_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  l.writeReview,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Rabar',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(InstitutionModel inst, ReviewModel rev,
      bool isMyReview, bool isDark, Color accentColor, AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isMyReview
              ? const Color(0xFFFFD54F).withValues(alpha: 0.7)
              : (isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03)),
          width: isMyReview ? 1.2 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: accentColor.withValues(alpha: 0.15),
                backgroundImage: rev.userAvatar != null &&
                        rev.userAvatar!.isNotEmpty
                    ? CachedNetworkImageProvider(rev.userAvatar!)
                    : null,
                child: (rev.userAvatar == null || rev.userAvatar!.isEmpty)
                    ? Text(
                        rev.userName.isNotEmpty
                            ? rev.userName.substring(0, 1).toUpperCase()
                            : 'U',
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          fontFamily: 'Rabar',
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            rev.userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Rabar',
                            ),
                          ),
                        ),
                        if (isMyReview) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB300)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFFFB300)
                                    .withValues(alpha: 0.3),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              l.yourRating,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFFFB300),
                                fontFamily: 'Rabar',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: rev.rating.toDouble(),
                          itemBuilder: (_, __) => const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB300),
                          ),
                          itemCount: 5,
                          itemSize: 13.0,
                        ),
                        if (rev.createdAt != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            rev.createdAt!.split('T').first,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.black38,
                              fontFamily: 'Rabar',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (isMyReview) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      color: AppColors.primary,
                      tooltip: l.editReview,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () =>
                          _showReviewBottomSheet(inst, existing: rev),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      color: Colors.redAccent,
                      tooltip: l.deleteReview,
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () => _confirmDeleteReview(rev.id),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (rev.comment != null && rev.comment!.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              rev.comment!,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.6,
                fontFamily: 'Rabar',
                color: isDark ? Colors.white70 : AppColors.textDark,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyReviewsState(
      InstitutionModel inst, bool isDark, AppLocalizations l) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star_outline_rounded,
                size: 38, color: Color(0xFFFFB300)),
          ),
          const SizedBox(height: 16),
          Text(
            l.noReviewsYet,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              fontFamily: 'Rabar',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.beFirstToReview,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Rabar',
              color: isDark ? Colors.white54 : Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewBottomSheet(InstitutionModel inst, {ReviewModel? existing}) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (!auth.isAuthenticated) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            l.reviewsTab,
            style: const TextStyle(
                fontFamily: 'Rabar', fontWeight: FontWeight.w900),
          ),
          content: Text(
            l.loginToReview,
            style: const TextStyle(fontFamily: 'Rabar', fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                l.cancel,
                style: const TextStyle(fontFamily: 'Rabar'),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/login');
              },
              child: Text(
                l.login,
                style: const TextStyle(
                    fontFamily: 'Rabar', fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      );
      return;
    }

    int selectedRating = existing?.rating ?? 5;
    final commentController =
        TextEditingController(text: existing?.comment ?? '');
    bool submitting = false;

    final impressions = [
      'مامۆستای بەتوانا ⭐',
      'ژینگەی لەبار 🏫',
      'خزمەتگوزاری بەرز 👍',
      'بەڕێوەبردنی ڕێک ✨',
      'پاک و خاوێن 🌿',
    ];

    String ratingLabel(int r) {
      switch (r) {
        case 1:
          return 'خراپە 😞';
        case 2:
          return 'مامناوەندە 😐';
        case 3:
          return 'باشە 🙂';
        case 4:
          return 'زۆر باشە 😊';
        default:
          return 'نایاب و بێوێنەیە 🤩';
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 14,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag Handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Title
                    Text(
                      existing != null ? l.editReview : l.writeReview,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Rabar',
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      inst.name(
                          Provider.of<LocaleProvider>(context, listen: false)
                              .locale
                              .languageCode),
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Rabar',
                        color: isDark ? Colors.white54 : Colors.black45,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Interactive Rating Bar
                    RatingBar.builder(
                      initialRating: selectedRating.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 42.0,
                      unratedColor: Colors.amber.withValues(alpha: 0.2),
                      itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB300),
                      ),
                      onRatingUpdate: (rating) {
                        setModalState(() {
                          selectedRating = rating.toInt();
                        });
                      },
                    ),
                    const SizedBox(height: 10),

                    // Rating mood label
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        ratingLabel(selectedRating),
                        key: ValueKey(selectedRating),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Rabar',
                          color: Color(0xFFFFB300),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Quick Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: impressions.map((tag) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              final current = commentController.text.trim();
                              if (current.isEmpty) {
                                commentController.text = tag;
                              } else if (!current.contains(tag)) {
                                commentController.text = '$current • $tag';
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontFamily: 'Rabar',
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),

                    // Comment Field
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      style: const TextStyle(fontFamily: 'Rabar', fontSize: 14),
                      decoration: InputDecoration(
                        hintText: l.shareYourExperience,
                        hintStyle: TextStyle(
                          fontFamily: 'Rabar',
                          fontSize: 13,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: submitting
                            ? null
                            : () async {
                                final messenger = ScaffoldMessenger.of(context);
                                final nav = Navigator.of(ctx);
                                setModalState(() => submitting = true);
                                final r = await _api.submitInstitutionReview(
                                  inst.id,
                                  rating: selectedRating,
                                  comment: commentController.text.trim(),
                                );
                                if (!mounted) return;
                                setModalState(() => submitting = false);
                                if (r.success) {
                                  nav.pop();
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l.reviewSubmittedSuccess,
                                        style: const TextStyle(
                                            fontFamily: 'Rabar'),
                                      ),
                                      backgroundColor: const Color(0xFF10B981),
                                    ),
                                  );
                                  _loadReviews();
                                } else {
                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        r.error ?? 'Error',
                                        style: const TextStyle(
                                            fontFamily: 'Rabar'),
                                      ),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              },
                        child: submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                l.submit,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Rabar',
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteReview(int reviewId) {
    final l = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l.deleteReview,
          style: const TextStyle(fontFamily: 'Rabar', fontWeight: FontWeight.w900),
        ),
        content: Text(
          l.deleteReviewConfirm,
          style: const TextStyle(fontFamily: 'Rabar'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              l.cancel,
              style: const TextStyle(fontFamily: 'Rabar'),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(ctx);
              final r = await _api.deleteReview(reviewId);
              if (!mounted) return;
              if (r.success) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      l.reviewDeletedSuccess,
                      style: const TextStyle(fontFamily: 'Rabar'),
                    ),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
                _loadReviews();
              }
            },
            child: Text(
              l.delete,
              style: const TextStyle(fontFamily: 'Rabar'),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _parseColleges(String? raw, String lang) {
    if (raw == null || raw.isEmpty) return [];
    final trimmed = raw.trim();
    if (trimmed.startsWith('[')) {
      try {
        final List<dynamic> decoded = jsonDecode(trimmed);
        return decoded.map((c) {
          if (c is! Map) return <String, dynamic>{};

          String cNameTranslated = c['name'] ?? '';
          if (lang == 'en' &&
              c['name_en'] != null &&
              c['name_en'].toString().isNotEmpty) {
            cNameTranslated = c['name_en'];
          } else if (lang == 'ar' &&
              c['name_ar'] != null &&
              c['name_ar'].toString().isNotEmpty) {
            cNameTranslated = c['name_ar'];
          } else if (lang == 'kbd' &&
              c['name_kbd'] != null &&
              c['name_kbd'].toString().isNotEmpty) {
            cNameTranslated = c['name_kbd'];
          }

          final deptsList = (c['depts'] as List<dynamic>? ?? []).map((d) {
            if (d is Map) {
              String dNameTranslated = d['name'] ?? '';
              if (lang == 'en' &&
                  d['name_en'] != null &&
                  d['name_en'].toString().isNotEmpty) {
                dNameTranslated = d['name_en'];
              } else if (lang == 'ar' &&
                  d['name_ar'] != null &&
                  d['name_ar'].toString().isNotEmpty) {
                dNameTranslated = d['name_ar'];
              } else if (lang == 'kbd' &&
                  d['name_kbd'] != null &&
                  d['name_kbd'].toString().isNotEmpty) {
                dNameTranslated = d['name_kbd'];
              }
              return {
                'original': d['name'] ?? '',
                'translated': dNameTranslated,
                'fee': d['fee'],
                'discount': d['discount'],
              };
            }
            return d;
          }).toList();

          return {
            'name': cNameTranslated, // display name
            'original': c['name'],
            'departments': deptsList,
          };
        }).toList();
      } catch (_) {}
    }

    // 2. Fallback to comma-separated string
    return trimmed
        .split(',')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'name': s.trim(), 'original': s.trim(), 'departments': []})
        .toList();
  }

  List<Map<String, dynamic>> _parseDepts(String? raw, String lang) {
    if (raw == null || raw.isEmpty) return [];
    final trimmed = raw.trim();
    if (trimmed.startsWith('[')) {
      try {
        final List<dynamic> decoded = jsonDecode(trimmed);
        return decoded.map((e) {
          if (e is Map) {
            String translated = e['ku'] ?? e['name'] ?? '';
            if (lang == 'en' &&
                e['en'] != null &&
                e['en'].toString().isNotEmpty) {
              translated = e['en'];
            } else if (lang == 'ar' &&
                e['ar'] != null &&
                e['ar'].toString().isNotEmpty) {
              translated = e['ar'];
            } else if (lang == 'kbd' &&
                e['kbd'] != null &&
                e['kbd'].toString().isNotEmpty) {
              translated = e['kbd'];
            }
            return {
              'original': e['ku'] ?? e['name'] ?? '',
              'translated': translated,
            };
          } else if (e is String) {
            return {'original': e, 'translated': e};
          }
          return {'original': '', 'translated': ''};
        }).toList();
      } catch (_) {}
    }
    return trimmed
        .split('\n')
        .where((s) => s.trim().isNotEmpty)
        .map((s) => {'original': s.trim(), 'translated': s.trim()})
        .toList();
  }

  /// Builds a map from dept name → price tags using the tuition_plans JSON.
  Map<String, TuitionPrice> _buildTuitionMap(String? raw) {
    if (raw == null || raw.isEmpty) return {};
    final trimmed = raw.trim();
    if (!trimmed.startsWith('[')) return {};
    try {
      final List<dynamic> plans = jsonDecode(trimmed);
      return {
        for (final p in plans)
          if (p is Map && p['dept'] != null)
            p['dept'].toString(): TuitionPrice.parse(p)
      };
    } catch (_) {
      return {};
    }
  }

  Widget _buildShimmerLoading(BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF8F9FD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ShimmerBox(
                width: double.infinity, height: 280, borderRadius: 0),
            const SizedBox(height: 32),
            const ShimmerBox(width: 250, height: 28, borderRadius: 12),
            const SizedBox(height: 12),
            const ShimmerBox(width: 150, height: 20, borderRadius: 8),
            const SizedBox(height: 40),
            Row(
              children: List.generate(
                  3,
                  (i) => const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: ShimmerBox(
                              width: double.infinity,
                              height: 80,
                              borderRadius: 16),
                        ),
                      )),
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: ShimmerBox(
                  width: double.infinity, height: 64, borderRadius: 24),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 120, height: 24, borderRadius: 8),
                  SizedBox(height: 16),
                  ShimmerBox(
                      width: double.infinity, height: 120, borderRadius: 20),
                  SizedBox(height: 32),
                  ShimmerBox(
                      width: double.infinity, height: 90, borderRadius: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Academic Section Card ────────────────────────────────────────────────────

class _AcademicSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accentColor;
  final bool isDark;
  final Widget child;
  const _AcademicSection({
    required this.icon,
    required this.title,
    required this.accentColor,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.04),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with left accent bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 22,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: accentColor, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Rabar',
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ─── Info row (label + value) ───────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final bool isDark;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accent, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Rabar',
                  color: isDark
                      ? Colors.white54
                      : AppColors.textDark.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Rabar',
                  height: 1.6,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Stats row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final bool isDark;
  final InstitutionModel inst;
  const _StatsRow({required this.isDark, required this.inst});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().year;
    final l = AppLocalizations.of(context);

    // Only show stats the institution actually provided — no empty "—" cells.
    final items = <_StatItem>[
      if (inst.foundedYear != null)
        _StatItem(
            value: inst.foundedYear!.toString(),
            label: l.foundedYearLabel,
            icon: Icons.calendar_today_rounded,
            color: const Color(0xFFF59E0B)),
      if (inst.foundedYear != null)
        _StatItem(
            value: '${now - inst.foundedYear!}+',
            label: l.experienceYears,
            icon: Icons.auto_awesome_rounded,
            color: AppColors.primary),
      if (inst.studentsCount != null)
        _StatItem(
            value: inst.studentsCount! >= 1000
                ? '${(inst.studentsCount! / 1000).toStringAsFixed(1)}k+'
                : '${inst.studentsCount}+',
            label: l.studentsLabel,
            icon: Icons.groups_rounded,
            color: const Color(0xFF10B981)),
      if (inst.ratingAvg > 0 || inst.reviewsCount > 0)
        _StatItem(
            value: inst.ratingAvg.toStringAsFixed(1),
            label: l.rating,
            icon: Icons.star_rounded,
            color: const Color(0xFFFFB300)),
      _StatItem(
          value: inst.views >= 1000
              ? '${(inst.views / 1000).toStringAsFixed(1)}k'
              : '${inst.views}',
          label: l.visitorsLabel,
          icon: Icons.visibility_rounded,
          color: const Color(0xFF6366F1)),
    ];

    // Nothing to show → hide the whole card so the layout stays clean.
    if (items.isEmpty) return const SizedBox.shrink();

    // Interleave dividers between the available stat items.
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) children.add(const _VDivider());
      children.add(items[i]);
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Row(children: children),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value, label;
  final IconData icon;
  final Color color;
  const _StatItem(
      {required this.value,
      required this.label,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: color,
                  fontFamily: 'Rabar')),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey.withValues(alpha: 0.8),
                  fontFamily: 'Rabar')),
        ]),
      );
}

class _VDivider extends StatelessWidget {
  const _VDivider();
  @override
  Widget build(BuildContext context) => Container(
      width: 1, height: 40, color: Colors.grey.withValues(alpha: 0.1));
}

// ─── Video card ───────────────────────────────────────────────────────────────

class _VideoCard extends StatefulWidget {
  final String videoUrl;
  final bool isDark;
  final Color typeColor;

  const _VideoCard({
    required this.videoUrl,
    required this.isDark,
    required this.typeColor,
  });

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> {
  YoutubePlayerController? _controller;
  String? _videoId;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _startPlaying();
  }

  void _startPlaying() {
    if (_videoId == null) return;
    final ctrl = YoutubePlayerController(
      initialVideoId: _videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    );
    _controller = ctrl;
    _playing = true;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) return const SizedBox.shrink();

    // ── Thumbnail (shown until user taps play) ──
    if (!_playing) {
      final thumb = 'https://img.youtube.com/vi/$_videoId/hqdefault.jpg';
      return GestureDetector(
        onTap: _startPlaying,
        child: Container(
          width: double.infinity,
          height: 210,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: thumb,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                      color: widget.typeColor.withValues(alpha: 0.15)),
                  errorWidget: (_, __, ___) => Container(
                      color: widget.typeColor.withValues(alpha: 0.15)),
                ),
                // Dark overlay
                Container(color: Colors.black.withValues(alpha: 0.35)),
                // Play button
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.redAccent, size: 38),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ── Player (after tap) ──
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressColors: const ProgressBarColors(
            playedColor: Colors.redAccent,
            handleColor: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}

// ─── Contact card ─────────────────────────────────────────────────────────────

class _ContactCard extends StatelessWidget {
  final InstitutionModel inst;
  final bool isDark;
  final Function(String) onLaunch;
  const _ContactCard(
      {required this.inst, required this.isDark, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    void add(IconData icon, String label, Color color, String? url) {
      if (items.isNotEmpty) items.add(const SizedBox(height: 10));
      items.add(_ContactTile(
        icon: icon,
        label: label,
        color: color,
        isDark: isDark,
        onTap: url != null ? () => onLaunch(url) : () {},
      ));
    }

    if (inst.addr != null && inst.addr!.isNotEmpty) {
      add(Icons.location_on_rounded, inst.addr!, const Color(0xFFF43F5E), null);
    }
    if (inst.email != null && inst.email!.isNotEmpty) {
      add(Icons.email_rounded, inst.email!, const Color(0xFF3B82F6),
          'mailto:${inst.email}');
    }

    if (items.isEmpty) {
      return Text(
        'No contact details available.',
        style: TextStyle(
          color: isDark ? Colors.white54 : Colors.black54,
          fontFamily: 'Rabar',
        ),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: items);
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;
  const _ContactTile(
      {required this.icon,
      required this.label,
      required this.color,
      required this.isDark,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: isDark ? Colors.white24 : Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Colleges Card ────────────────────────────────────────────────────────────

/// College names that carry no information beyond "these are the departments",
/// in every language the app stores data in.
const _genericCollegeNames = {
  'بەشەکان',
  'بەش',
  'پشک',
  'الأقسام',
  'departments',
  'bölümler',
};

/// One department line: the name on top, its tuition underneath.
///
/// The two halves are stacked rather than squeezed into a single row so that
/// long department names never push the prices out of alignment — every row
/// starts its price at the same place, which is what makes a long list
/// readable. Shared by the departments tab and the college cards.
class _DeptRow extends StatelessWidget {
  final String name;
  final TuitionPrice price;
  final Color accent;
  final bool isDark;
  final String discountLabel;
  final bool showDivider;

  const _DeptRow({
    required this.name,
    required this.price,
    required this.accent,
    required this.isDark,
    required this.discountLabel,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: showDivider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.05),
                ),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rabar',
                    color: isDark ? Colors.white70 : AppColors.textDark,
                  ),
                ),
              ),
              if (price.hasDiscount) ...[
                const SizedBox(width: 8),
                _discountPill(),
              ],
            ],
          ),
          if (!price.isEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 13, top: 4),
              child: _priceLine(),
            ),
        ],
      ),
    );
  }

  /// A compact `15%` tag. The word "discount" is left off deliberately —
  /// repeated down a list of twenty departments it was pure noise, and the
  /// struck-through price next to it already says what the tag means.
  Widget _discountPill() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: isDark ? 0.18 : 0.09),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sell_rounded, size: 10, color: AppColors.error),
            const SizedBox(width: 3),
            Text(
              '${price.discount}%',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                fontFamily: 'Rabar',
                color: AppColors.error,
              ),
            ),
          ],
        ),
      );

  Widget _priceLine() {
    final muted = isDark ? Colors.white38 : const Color(0xFF94A3B8);

    // Discounted: the price actually paid leads, the old one trails struck out.
    if (price.hasDiscount) {
      return Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            price.finalPrice,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              fontFamily: 'Rabar',
              color: AppColors.success,
            ),
          ),
          Text(
            price.fee,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              fontFamily: 'Rabar',
              color: muted,
              decoration: TextDecoration.lineThrough,
              decorationColor: muted,
            ),
          ),
        ],
      );
    }

    // A discount that could not be read as a percentage — show it spelled out
    // rather than dropping the offer altogether.
    if (price.discount.isNotEmpty) {
      return Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (price.fee.isNotEmpty) _plainFee(),
          Text(
            '$discountLabel ${price.discount}',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              fontFamily: 'Rabar',
              color: AppColors.error,
            ),
          ),
        ],
      );
    }

    return _plainFee();
  }

  Widget _plainFee() => Text(
        price.fee,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          fontFamily: 'Rabar',
          color: accent,
        ),
      );
}

class _CollegesCard extends StatelessWidget {
  final List<Map<String, dynamic>> colleges;
  final bool isDark;
  const _CollegesCard({required this.colleges, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final strDiscount =
        lang == 'en' ? 'Discount' : (lang == 'ar' ? 'خصم' : 'داشکان');

    return Column(
      children: colleges.map((college) {
        final departments = college['departments'] as List<dynamic>? ?? [];
        final collegeName = (college['name'] ?? '').toString().trim();
        if (collegeName.isEmpty) return const SizedBox.shrink();
        // Some institutions store their departments under a college that is just
        // called "Departments" — the same word as the tab this list sits in.
        // Matched against every language, since the label is stored data and has
        // nothing to do with the language the app is currently showing.
        final isGenericName = collegeName.isEmpty ||
            _genericCollegeNames.contains(collegeName.toLowerCase());
        final leadingIcon = Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.account_balance_rounded,
              color: Colors.white, size: 22),
        );
        final titleRow = Row(
          children: [
            Expanded(
              child: Text(
                college['name'] ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Rabar',
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ),
            if (college['fee'] != null &&
                college['fee'].toString().trim().isNotEmpty)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  college['fee'].toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Rabar',
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        );
        // Rows are built once and reused by all three layouts below.
        // dept can be a string (legacy) or a Map with name/fee/discount.
        final deptRows = <Widget>[
          for (var i = 0; i < departments.length; i++)
            _DeptRow(
              name: departments[i] is Map
                  ? (departments[i]['translated'] ??
                          departments[i]['original'] ??
                          '')
                      .toString()
                  : departments[i].toString(),
              price: TuitionPrice.parse(
                  departments[i] is Map ? departments[i] as Map : null),
              accent: AppColors.primary,
              isDark: isDark,
              discountLabel: strDiscount,
              showDivider: i < departments.length - 1,
            ),
        ];

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          // Three shapes, depending on what the data actually carries:
          child: departments.isEmpty
              // Nothing to expand into — one plain row, no "no information" line.
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      leadingIcon,
                      const SizedBox(width: 16),
                      Expanded(child: titleRow),
                    ],
                  ),
                )
              // A college literally named "Departments" just repeats the tab it
              // sits under, so drop the header and list its departments directly.
              : isGenericName
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: deptRows,
                      ),
                    )
                  : ExpansionTile(
                      // Open by default — the departments are the point of this
                      // card, so don't make people tap to reveal them.
                      initiallyExpanded: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      collapsedShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      leading: leadingIcon,
                      title: titleRow,
                      childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      children: deptRows,
                    ),
        );
      }).toList(),
    );
  }
}

// ─── Post Card ────────────────────────────────────────────────────────────

class _PostCard extends StatelessWidget {
  final PostModel post;
  final bool isDark;
  const _PostCard({required this.post, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/news-detail', extra: post),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const ShimmerBox(
                      width: double.infinity, height: 200, borderRadius: 0),
                  errorWidget: (_, __, ___) => const SizedBox(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (post.title != null && post.title!.isNotEmpty)
                    Text(
                      post.title!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Rabar',
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                  if (post.content.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      post.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: isDark
                            ? Colors.white70
                            : AppColors.textDark.withValues(alpha: 0.7),
                        fontFamily: 'Rabar',
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        size: 14,
                        color: AppColors.primary.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'کردنەوەی زیاتر',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Rabar',
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
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
    );
  }
}
