import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/job_vacancy_model.dart';
import '../../providers/job_vacancies_provider.dart';
import '../../providers/teachers_cv_provider.dart';
import '../cv/cv_screen.dart';

String _localizeCity(String city, AppLocalizations l) {
  switch (city) {
    case 'all':
      return l.allFilter;
    case 'هەولێر':
      return l.cityErbil;
    case 'سلێمانی':
      return l.citySulaymaniyah;
    case 'دهۆک':
      return l.cityDuhok;
    case 'کەرکووک':
    case 'کەرکوک':
      return l.cityKirkuk;
    case 'هەڵەبجە':
      return l.cityHalabja;
    case 'زاخۆ':
      return l.cityZakho;
    case 'سۆران':
      return l.citySoran;
    case 'کۆیە':
      return l.cityKoya;
    default:
      return city;
  }
}

class JobsAndCvsHubScreen extends StatefulWidget {
  final int initialTabIndex;
  const JobsAndCvsHubScreen({super.key, this.initialTabIndex = 0});

  @override
  State<JobsAndCvsHubScreen> createState() => _JobsAndCvsHubScreenState();
}

class _JobsAndCvsHubScreenState extends State<JobsAndCvsHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _jobsSearchCtrl = TextEditingController();
  final _cvSearchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _jobsSearchCtrl.dispose();
    _cvSearchCtrl.dispose();
    super.dispose();
  }

  void _showJobsFilterModal(
    BuildContext context,
    JobVacanciesProvider prov,
    AppLocalizations l,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l.filter,
                      style: const TextStyle(
                        fontFamily: 'Rabar',
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (prov.selectedCity != null || prov.selectedCategory != null)
                      TextButton(
                        onPressed: () {
                          prov.setCity('all');
                          prov.setCategory(null);
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          l.clearFilters,
                          style: const TextStyle(
                            fontFamily: 'Rabar',
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  l.city,
                  style: const TextStyle(
                    fontFamily: 'Rabar',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in ['all', 'هەولێر', 'سلێمانی', 'دهۆک', 'کەرکووک', 'هەڵەبجە', 'زاخۆ', 'سۆران', 'کۆیە'])
                      ChoiceChip(
                        label: Text(_localizeCity(c, l)),
                        selected: (c == 'all' && prov.selectedCity == null) || prov.selectedCity == c,
                        onSelected: (_) {
                          prov.setCity(c);
                          Navigator.pop(ctx);
                        },
                        labelStyle: TextStyle(
                          fontFamily: 'Rabar',
                          fontWeight: FontWeight.w700,
                          color: ((c == 'all' && prov.selectedCity == null) || prov.selectedCity == c)
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        selectedColor: AppColors.primary,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUnifiedSearchBar(
    bool isDark,
    AppLocalizations l,
    bool isJobsTab,
    JobVacanciesProvider jobsProv,
    CvProvider cvProv,
  ) {
    final hasFilter = isJobsTab
        ? (jobsProv.selectedCity != null || jobsProv.selectedCategory != null)
        : (cvProv.selectedCity != null || cvProv.selectedEducation != null);

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: isDark ? Colors.white38 : Colors.black38,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: isJobsTab ? _jobsSearchCtrl : _cvSearchCtrl,
              onChanged: (v) {
                if (isJobsTab) {
                  jobsProv.setSearch(v);
                } else {
                  cvProv.setSearch(v);
                }
                setState(() {});
              },
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: 'Rabar',
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                hintText: isJobsTab
                    ? l.searchJobHint
                    : l.searchCvHint,
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Rabar',
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          if ((isJobsTab ? _jobsSearchCtrl : _cvSearchCtrl).text.isNotEmpty)
            GestureDetector(
              onTap: () {
                if (isJobsTab) {
                  _jobsSearchCtrl.clear();
                  jobsProv.setSearch('');
                } else {
                  _cvSearchCtrl.clear();
                  cvProv.setSearch('');
                }
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.close_rounded, size: 18, color: Colors.grey),
              ),
            ),
          Container(
            height: 20,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            color: isDark ? Colors.white12 : Colors.black12,
          ),
          GestureDetector(
            onTap: () {
              if (isJobsTab) {
                _showJobsFilterModal(context, jobsProv, l, isDark);
              } else {
                showCvAdvancedFilter(context, cvProv);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: hasFilter ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.tune_rounded,
                size: 20,
                color: hasFilter ? Colors.white : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldHeader(bool isDark, AppLocalizations l) {
    final isJobsTab = _tabController.index == 0;
    final cvProv = Provider.of<CvProvider>(context);
    final jobsProv = Provider.of<JobVacanciesProvider>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Glowing Decorative Shapes
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Row
                  Row(
                    children: [
                      if (Navigator.of(context).canPop()) ...[
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            isJobsTab
                                ? Icons.work_rounded
                                : Icons.description_rounded,
                            key: ValueKey(isJobsTab),
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.jobsAndCvs,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontFamily: 'Rabar',
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isJobsTab
                                  ? l.jobVacanciesSubtitle
                                  : l.cvBankSubtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                                fontFamily: 'Rabar',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // ── TabBar INSIDE the Gold Card! ──
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.white.withValues(alpha: 0.88),
                      labelStyle: const TextStyle(
                        fontFamily: 'Rabar',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Rabar',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.work_rounded, size: 16),
                              const SizedBox(width: 6),
                              Text(l.jobVacancies),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.badge_rounded, size: 16),
                              const SizedBox(width: 6),
                              Text(l.cvBank),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Floating Pill Search Bar (inside the gold card!) ──
                  _buildUnifiedSearchBar(isDark, l, isJobsTab, jobsProv, cvProv),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF8FAFC),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Column(
          children: [
            _buildGoldHeader(isDark, l),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _JobVacanciesTab(),
                  CvScreen(showHeader: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobVacanciesTab extends StatefulWidget {
  const _JobVacanciesTab();

  @override
  State<_JobVacanciesTab> createState() => _JobVacanciesTabState();
}

class _JobVacanciesTabState extends State<_JobVacanciesTab> {
  final _scrollCtrl = ScrollController();

  final List<String> _cities = [
    'all',
    'هەولێر',
    'سلێمانی',
    'دهۆک',
    'کەرکووک',
    'هەڵەبجە',
    'زاخۆ',
    'سۆران',
    'کۆیە',
  ];

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
        Provider.of<JobVacanciesProvider>(context, listen: false).fetchJobs();
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<JobVacanciesProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async => prov.fetchJobs(refresh: true),
        color: AppColors.primary,
        child: CustomScrollView(
          controller: _scrollCtrl,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── City Filter Chips ──
            SliverToBoxAdapter(
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _cities.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final city = _cities[i];
                    final isSelected = (city == 'all' && prov.selectedCity == null) ||
                        (prov.selectedCity == city);
                    return GestureDetector(
                      onTap: () => prov.setCity(city),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark ? AppColors.darkCard : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _localizeCity(city, l),
                            style: TextStyle(
                              fontFamily: 'Rabar',
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : AppColors.textDark),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // ── Category Chips (Teacher, Admin, Support) ──
            SliverToBoxAdapter(
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildCategoryChip(
                      label: l.allFilter,
                      isSelected: prov.selectedCategory == null,
                      onTap: () => prov.setCategory(null),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: '👨‍🏫 ${l.teacherJob}',
                      isSelected: prov.selectedCategory == 'teacher',
                      onTap: () => prov.setCategory('teacher'),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: '💼 ${l.adminJob}',
                      isSelected: prov.selectedCategory == 'admin',
                      onTap: () => prov.setCategory('admin'),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildCategoryChip(
                      label: '🤝 ${l.supportJob}',
                      isSelected: prov.selectedCategory == 'support',
                      onTap: () => prov.setCategory('support'),
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            // ── Jobs List ──
            if (prov.loading && prov.jobs.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => Container(
                      height: 140,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    childCount: 4,
                  ),
                ),
              )
            else if (prov.jobs.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.work_off_rounded, color: AppColors.primary, size: 36),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l.noJobsFound,
                          style: const TextStyle(
                            fontFamily: 'Rabar',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l.noJobsSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Rabar',
                            fontSize: 12.5,
                            color: isDark ? Colors.white54 : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final job = prov.jobs[i];
                      return _JobCard(
                        job: job,
                        isDark: isDark,
                        l: l,
                        onCall: () => _makeCall(job.contactPhone),
                        onTap: () => context.push(
                          '/jobs/${job.id}',
                          extra: job,
                        ),
                      );
                    },
                    childCount: prov.jobs.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.15)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.06)),
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Rabar',
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? Colors.white70 : AppColors.textDark),
            ),
          ),
        ),
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobVacancyModel job;
  final bool isDark;
  final AppLocalizations l;
  final VoidCallback onCall;
  final VoidCallback onTap;

  const _JobCard({
    required this.job,
    required this.isDark,
    required this.l,
    required this.onCall,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Logo + Institution Name + City
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: job.institutionLogo != null && job.institutionLogo!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: job.institutionLogo!,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Center(
                                child: Icon(Icons.school_rounded, color: AppColors.primary, size: 22),
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.school_rounded, color: AppColors.primary, size: 22),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.institutionName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Rabar',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white70 : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 13, color: AppColors.primary),
                            const SizedBox(width: 2),
                            Text(
                              job.city,
                              style: const TextStyle(
                                fontFamily: 'Rabar',
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      job.getCategoryLabel(l),
                      style: const TextStyle(
                        fontFamily: 'Rabar',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Job Title
              Text(
                job.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Rabar',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 10),

              // Chips Row: Employment, Salary, Gender
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildTag(
                    icon: Icons.schedule_rounded,
                    label: job.getEmploymentTypeLabel(l),
                    color: const Color(0xFF0284C7),
                  ),
                  if (job.salaryRange != null && job.salaryRange!.isNotEmpty)
                    _buildTag(
                      icon: Icons.payments_rounded,
                      label: job.salaryRange!,
                      color: const Color(0xFF10B981),
                    ),
                  if (job.subject != null && job.subject!.isNotEmpty)
                    _buildTag(
                      icon: Icons.book_rounded,
                      label: job.subject!,
                      color: const Color(0xFFF59E0B),
                    ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),

              // Bottom Row: Call button + Details prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: onCall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.call_rounded, size: 15, color: AppColors.primary),
                          const SizedBox(width: 5),
                          Text(
                            l.callNow,
                            style: const TextStyle(
                              fontFamily: 'Rabar',
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        l.jobDetails,
                        style: TextStyle(
                          fontFamily: 'Rabar',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white60 : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: isDark ? Colors.white60 : AppColors.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Rabar',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
