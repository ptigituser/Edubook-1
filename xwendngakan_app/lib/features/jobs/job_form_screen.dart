import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../providers/job_vacancies_provider.dart';

String _localizeCity(String city, AppLocalizations l) {
  switch (city) {
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

class JobFormScreen extends StatefulWidget {
  const JobFormScreen({super.key});

  @override
  State<JobFormScreen> createState() => _JobFormScreenState();
}

class _JobFormScreenState extends State<JobFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _institutionNameCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _educationLevelCtrl = TextEditingController();
  final _salaryRangeCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _requirementsCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _category = 'teacher';
  String _employmentType = 'full_time';
  String _city = 'هەولێر';
  String _gender = 'any';

  bool _submitting = false;

  final List<String> _cities = [
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
  void dispose() {
    _institutionNameCtrl.dispose();
    _titleCtrl.dispose();
    _subjectCtrl.dispose();
    _educationLevelCtrl.dispose();
    _salaryRangeCtrl.dispose();
    _experienceCtrl.dispose();
    _descriptionCtrl.dispose();
    _requirementsCtrl.dispose();
    _phoneCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final form = {
      'institution_name': _institutionNameCtrl.text.trim(),
      'title': _titleCtrl.text.trim(),
      'category': _category,
      if (_subjectCtrl.text.trim().isNotEmpty) 'subject': _subjectCtrl.text.trim(),
      if (_educationLevelCtrl.text.trim().isNotEmpty)
        'education_level': _educationLevelCtrl.text.trim(),
      'employment_type': _employmentType,
      'city': _city,
      if (_salaryRangeCtrl.text.trim().isNotEmpty) 'salary_range': _salaryRangeCtrl.text.trim(),
      'gender': _gender,
      if (_experienceCtrl.text.trim().isNotEmpty)
        'experience_years': _experienceCtrl.text.trim(),
      'description': _descriptionCtrl.text.trim(),
      if (_requirementsCtrl.text.trim().isNotEmpty)
        'requirements': _requirementsCtrl.text.trim(),
      'contact_phone': _phoneCtrl.text.trim(),
      if (_whatsappCtrl.text.trim().isNotEmpty) 'contact_whatsapp': _whatsappCtrl.text.trim(),
      if (_emailCtrl.text.trim().isNotEmpty) 'contact_email': _emailCtrl.text.trim(),
    };

    final prov = Provider.of<JobVacanciesProvider>(context, listen: false);
    final success = await prov.postJob(form);

    if (!mounted) return;
    final l = AppLocalizations.of(context);
    setState(() => _submitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l.jobPostedSuccess} ✅',
            style: const TextStyle(fontFamily: 'Rabar'),
          ),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l.somethingWentWrong,
            style: const TextStyle(fontFamily: 'Rabar'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.postJob,
          style: const TextStyle(
            fontFamily: 'Rabar',
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section 1: Institution & Title ──
              _buildSectionTitle(l.basicJobInfo, isDark),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _institutionNameCtrl,
                label: l.institutionNameLabel,
                hint: '...',
                icon: Icons.school_rounded,
                isDark: isDark,
                validator: (val) => (val == null || val.trim().isEmpty) ? l.requiredField : null,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _titleCtrl,
                label: l.jobTitleLabel,
                hint: '...',
                icon: Icons.badge_rounded,
                isDark: isDark,
                validator: (val) => (val == null || val.trim().isEmpty) ? l.requiredField : null,
              ),
              const SizedBox(height: 14),

              // Category & Employment Type
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: l.categoryLabel,
                      value: _category,
                      items: [
                        DropdownMenuItem(value: 'teacher', child: Text(l.teacherJob)),
                        DropdownMenuItem(value: 'admin', child: Text(l.adminJob)),
                        DropdownMenuItem(value: 'support', child: Text(l.supportJob)),
                        DropdownMenuItem(value: 'other', child: Text(l.otherCategory)),
                      ],
                      onChanged: (val) => setState(() => _category = val!),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdown(
                      label: l.employmentType,
                      value: _employmentType,
                      items: [
                        DropdownMenuItem(value: 'full_time', child: Text(l.fullTime)),
                        DropdownMenuItem(value: 'part_time', child: Text(l.partTime)),
                        DropdownMenuItem(value: 'temporary', child: Text(l.temporary)),
                      ],
                      onChanged: (val) => setState(() => _employmentType = val!),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // City & Gender
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: l.city,
                      value: _city,
                      items: _cities
                          .map((c) => DropdownMenuItem(value: c, child: Text(_localizeCity(c, l))))
                          .toList(),
                      onChanged: (val) => setState(() => _city = val!),
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDropdown(
                      label: l.genderPreference,
                      value: _gender,
                      items: [
                        DropdownMenuItem(value: 'any', child: Text(l.anyGender)),
                        DropdownMenuItem(value: 'female', child: Text(l.femaleOnly)),
                        DropdownMenuItem(value: 'male', child: Text(l.maleOnly)),
                      ],
                      onChanged: (val) => setState(() => _gender = val!),
                      isDark: isDark,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Section 2: Details & Salary ──
              _buildSectionTitle(l.jobDetailsAndRequirements, isDark),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _subjectCtrl,
                      label: l.subjectOrSpecialty,
                      hint: '...',
                      icon: Icons.book_rounded,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _educationLevelCtrl,
                      label: l.educationStage,
                      hint: '...',
                      icon: Icons.auto_stories_rounded,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _salaryRangeCtrl,
                      label: l.salary,
                      hint: '...',
                      icon: Icons.payments_rounded,
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _experienceCtrl,
                      label: l.experienceYears,
                      hint: '...',
                      icon: Icons.history_edu_rounded,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _descriptionCtrl,
                label: l.jobDescription,
                hint: '...',
                icon: Icons.description_rounded,
                maxLines: 4,
                isDark: isDark,
                validator: (val) => (val == null || val.trim().isEmpty) ? l.requiredField : null,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _requirementsCtrl,
                label: l.requirements,
                hint: '...',
                icon: Icons.checklist_rounded,
                maxLines: 3,
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // ── Section 3: Contact Info ──
              _buildSectionTitle(l.contactInfo, isDark),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _phoneCtrl,
                label: '${l.contactPhone} (${l.required})',
                hint: '0750 000 0000',
                icon: Icons.call_rounded,
                keyboardType: TextInputType.phone,
                isDark: isDark,
                validator: (val) => (val == null || val.trim().isEmpty) ? l.requiredField : null,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _whatsappCtrl,
                label: '${l.whatsApp} (${l.optional})',
                hint: '0750 000 0000',
                icon: Icons.chat_bubble_rounded,
                keyboardType: TextInputType.phone,
                isDark: isDark,
              ),
              const SizedBox(height: 14),
              _buildTextField(
                controller: _emailCtrl,
                label: '${l.email} (${l.optional})',
                hint: 'example@domain.com',
                icon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                isDark: isDark,
              ),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.send_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l.postJob,
                            style: const TextStyle(
                              fontFamily: 'Rabar',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Rabar',
        fontSize: 15.5,
        fontWeight: FontWeight.w900,
        color: isDark ? Colors.white : AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontFamily: 'Rabar', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          fontFamily: 'Rabar',
          color: isDark ? Colors.white60 : AppColors.textMuted,
        ),
        hintStyle: TextStyle(
          fontFamily: 'Rabar',
          fontSize: 13,
          color: isDark ? Colors.white30 : Colors.black26,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    required bool isDark,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      style: TextStyle(
        fontFamily: 'Rabar',
        fontSize: 13.5,
        color: isDark ? Colors.white : Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'Rabar',
          color: isDark ? Colors.white60 : AppColors.textMuted,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black.withValues(alpha: 0.08),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
