import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/institutions_provider.dart';
import '../../providers/locale_provider.dart';
import '../../shared/widgets/cards.dart';
import '../../shared/widgets/common_widgets.dart';

class InstitutionsScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilter;
  const InstitutionsScreen({super.key, this.initialFilter});
  
  @override
  State<InstitutionsScreen> createState() => _InstitutionsScreenState();
}

class _InstitutionsScreenState extends State<InstitutionsScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  String? _selectedType;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialFilter?['type'];
    _selectedCity = widget.initialFilter?['city'];
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prov = Provider.of<InstitutionsProvider>(context, listen: false);
      
      if (widget.initialFilter != null) {
        prov.setFilter(
          type: widget.initialFilter?['type'] ?? '',
          city: widget.initialFilter?['city'] ?? '',
        );
      }
      
      prov.fetchInstitutions(refresh: true);
    });
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 200) {
        Provider.of<InstitutionsProvider>(context, listen: false).fetchInstitutions();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Provider.of<LocaleProvider>(context);
    final prov = Provider.of<InstitutionsProvider>(context);
    final lang = locale.locale.languageCode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.institutions,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  AppSearchBar(
                    controller: _searchCtrl,
                    hint: l.searchHint,
                    hasActiveFilter: _selectedCity != null || _selectedType != null,
                    onChanged: (v) => Provider.of<InstitutionsProvider>(context, listen: false).setSearch(v),
                    onFilterTap: () => _showAdvancedFilter(context, l, prov),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _FilterChip(
                          label: l.all,
                          isSelected: _selectedType == null,
                          onTap: () {
                            setState(() => _selectedType = null);
                            Provider.of<InstitutionsProvider>(context, listen: false).setFilter(type: '');
                          },
                        ),
                        ...prov.institutionTypes.map((type) => _FilterChip(
                              label: '${type.emoji ?? ''} ${type.localizedName(lang)}',
                              isSelected: _selectedType == type.key,
                              onTap: () {
                                setState(() => _selectedType = type.key);
                                Provider.of<InstitutionsProvider>(context, listen: false).setFilter(type: type.key);
                              },
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedCity != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(_selectedCity!, style: const TextStyle(color: AppColors.primary, fontSize: 13)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedCity = null);
                        Provider.of<InstitutionsProvider>(context, listen: false).setFilter(city: '');
                      },
                      child: const Icon(Icons.close, size: 16, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async =>
                    Provider.of<InstitutionsProvider>(context, listen: false).fetchInstitutions(refresh: true),
                child: prov.loading && prov.institutions.isEmpty
                    ? _buildShimmer()
                    : prov.institutions.isEmpty
                        ? EmptyState(icon: Icons.school_outlined, message: l.noInstitutionsFound)
                        : GridView.builder(
                            controller: _scrollCtrl,
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.82,
                            ),
                            itemCount: prov.institutions.length + (prov.hasMore ? 1 : 0),
                            itemBuilder: (_, i) {
                              if (i >= prov.institutions.length) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final inst = prov.institutions[i];
                              return InstitutionCard(
                                institution: inst,
                                lang: lang,
                                isFavorite: prov.favorites.contains(inst.id),
                                onFavorite: () => prov.toggleFavorite(inst.id),
                                onTap: () => context.push('/institutions/${inst.id}'),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdvancedFilter(BuildContext context, AppLocalizations l, InstitutionsProvider prov) {
    String tempCity = _selectedCity ?? '';
    String tempType = _selectedType ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final bottomInset = MediaQuery.of(context).padding.bottom;
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header (Fixed)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 8),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white24 : Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.advancedFilter,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Rabar',
                                ),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempCity = '';
                                tempType = '';
                              });
                            },
                            child: Text(
                              l.clear,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Rabar',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.cities,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Rabar',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: AppConstants.iraqiCities.map((city) {
                            final isSelected = tempCity == city;
                            return GestureDetector(
                              onTap: () => setModalState(() => tempCity = isSelected ? '' : city),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.darkBg
                                          : Colors.grey.withValues(alpha: 0.08)),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark
                                            ? AppColors.darkBorder
                                            : AppColors.lightBorder),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  AppConstants.localizedCityName(
                                      city, Localizations.localeOf(context).languageCode),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? Colors.white70 : AppColors.textDark),
                                    fontSize: 12.5,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    fontFamily: 'Rabar',
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l.institutionType,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Rabar',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: prov.institutionTypes.map((type) {
                            final isSelected = tempType == type.key;
                            final lang = Localizations.localeOf(context).languageCode;
                            final label = type.localizedName(lang);
                            return GestureDetector(
                              onTap: () => setModalState(() => tempType = isSelected ? '' : type.key),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.darkBg
                                          : Colors.grey.withValues(alpha: 0.08)),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark
                                            ? AppColors.darkBorder
                                            : AppColors.lightBorder),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (type.emoji != null && type.emoji!.isNotEmpty) ...[
                                      Text(type.emoji!, style: const TextStyle(fontSize: 13)),
                                      const SizedBox(width: 5),
                                    ],
                                    Text(
                                      label,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark ? Colors.white70 : AppColors.textDark),
                                        fontSize: 12.5,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        fontFamily: 'Rabar',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer (Fixed with Safe Area)
                Container(
                  padding: EdgeInsets.fromLTRB(24, 12, 24, bottomInset > 0 ? bottomInset + 8 : 20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                  ),
                  child: GradientButton(
                    text: l.apply,
                    onPressed: () {
                      setState(() {
                        _selectedCity = tempCity.isEmpty ? null : tempCity;
                        _selectedType = tempType.isEmpty ? null : tempType;
                      });
                      prov.setFilter(type: tempType, city: tempCity);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ShimmerBox(
        width: double.infinity,
        height: double.infinity,
        borderRadius: AppConstants.radiusLg,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.fast,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (Theme.of(context).brightness == Brightness.dark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? Colors.white
                : (Theme.of(context).brightness == Brightness.dark ? AppColors.textWhite : AppColors.textDark),
            fontFamily: 'Rabar',
          ),
        ),
      ),
    );
  }
}
