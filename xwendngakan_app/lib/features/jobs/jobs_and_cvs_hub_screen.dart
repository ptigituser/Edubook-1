import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/job_vacancy_model.dart';
import '../../providers/job_vacancies_provider.dart';
import '../cv/cv_screen.dart';

class JobsAndCvsHubScreen extends StatefulWidget {
  final int initialTabIndex;
  const JobsAndCvsHubScreen({super.key, this.initialTabIndex = 0});

  @override
  State<JobsAndCvsHubScreen> createState() => _JobsAndCvsHubScreenState();
}

class _JobsAndCvsHubScreenState extends State<JobsAndCvsHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkCard : Colors.white,
        elevation: 0,
        title: Text(
          l.jobsAndCvs,
          style: const TextStyle(
            fontFamily: 'Rabar',
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: isDark ? Colors.white60 : AppColors.textMuted,
              labelStyle: const TextStyle(
                fontFamily: 'Rabar',
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
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
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _JobVacanciesTab(),
          CvScreen(),
        ],
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
  final _searchCtrl = TextEditingController();
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
    _searchCtrl.dispose();
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
            // ── Search & Filter Bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onSubmitted: (val) => prov.setSearch(val),
                          textInputAction: TextInputAction.search,
                          style: const TextStyle(fontFamily: 'Rabar', fontSize: 13.5),
                          decoration: InputDecoration(
                            hintText: 'گەڕان لە هەلی کارەکان (مامۆستا، باخچە، زانکۆ)...',
                            hintStyle: TextStyle(
                              fontFamily: 'Rabar',
                              fontSize: 12.5,
                              color: isDark ? Colors.white30 : AppColors.textMuted,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (_searchCtrl.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            prov.setSearch('');
                          },
                          child: const Icon(Icons.close_rounded, size: 18, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ),
            ),

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
                            city == 'all' ? l.allFilter : city,
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
                          'لەم کاتەدا هیچ هەلی کارێکی نوێ لەلایەن دامەزراوەکانەوە ڕانەگەیەندراوە',
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
