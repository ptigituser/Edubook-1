import '../../core/localization/app_localizations.dart';
import '../../core/utils/image_utils.dart';

class JobVacancyModel {
  final int id;
  final int? institutionId;
  final String institutionName;
  final String? institutionLogo;
  final String title;
  final String category;
  final String? subject;
  final String? educationLevel;
  final String employmentType;
  final String city;
  final String? salaryRange;
  final String gender;
  final String? experienceYears;
  final String description;
  final String? requirements;
  final String contactPhone;
  final String? contactWhatsapp;
  final String? contactEmail;
  final int viewsCount;
  final DateTime? createdAt;

  String get logoUrl => ImageUtils.resolveUrl(institutionLogo);

  JobVacancyModel({
    required this.id,
    this.institutionId,
    required this.institutionName,
    this.institutionLogo,
    required this.title,
    required this.category,
    this.subject,
    this.educationLevel,
    required this.employmentType,
    required this.city,
    this.salaryRange,
    required this.gender,
    this.experienceYears,
    required this.description,
    this.requirements,
    required this.contactPhone,
    this.contactWhatsapp,
    this.contactEmail,
    this.viewsCount = 0,
    this.createdAt,
  });

  factory JobVacancyModel.fromJson(Map<String, dynamic> json) {
    return JobVacancyModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      institutionId: json['institution_id'] != null
          ? (json['institution_id'] is int
              ? json['institution_id']
              : int.tryParse(json['institution_id'].toString()))
          : null,
      institutionName: json['institution_name']?.toString() ?? '',
      institutionLogo: json['institution_logo']?.toString(),
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? 'teacher',
      subject: json['subject']?.toString(),
      educationLevel: json['education_level']?.toString(),
      employmentType: json['employment_type']?.toString() ?? 'full_time',
      city: json['city']?.toString() ?? '',
      salaryRange: json['salary_range']?.toString(),
      gender: json['gender']?.toString() ?? 'any',
      experienceYears: json['experience_years']?.toString(),
      description: json['description']?.toString() ?? '',
      requirements: json['requirements']?.toString(),
      contactPhone: json['contact_phone']?.toString() ?? '',
      contactWhatsapp: json['contact_whatsapp']?.toString(),
      contactEmail: json['contact_email']?.toString(),
      viewsCount: json['views_count'] is int
          ? json['views_count']
          : int.tryParse(json['views_count']?.toString() ?? '0') ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institution_id': institutionId,
      'institution_name': institutionName,
      'institution_logo': institutionLogo,
      'title': title,
      'category': category,
      'subject': subject,
      'education_level': educationLevel,
      'employment_type': employmentType,
      'city': city,
      'salary_range': salaryRange,
      'gender': gender,
      'experience_years': experienceYears,
      'description': description,
      'requirements': requirements,
      'contact_phone': contactPhone,
      'contact_whatsapp': contactWhatsapp,
      'contact_email': contactEmail,
    };
  }

  String getCategoryLabel(AppLocalizations l) {
    switch (category) {
      case 'teacher':
        return l.teacherJob;
      case 'admin':
        return l.adminJob;
      case 'support':
        return l.supportJob;
      default:
        return category;
    }
  }

  String getEmploymentTypeLabel(AppLocalizations l) {
    switch (employmentType) {
      case 'full_time':
        return l.fullTime;
      case 'part_time':
        return l.partTime;
      case 'temporary':
        return l.temporary;
      default:
        return employmentType;
    }
  }

  String getGenderLabel(AppLocalizations l) {
    switch (gender) {
      case 'female':
        return l.femaleOnly;
      case 'male':
        return l.maleOnly;
      default:
        return l.anyGender;
    }
  }
}
