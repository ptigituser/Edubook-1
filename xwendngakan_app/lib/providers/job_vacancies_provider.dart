import 'package:flutter/material.dart';
import '../data/models/job_vacancy_model.dart';
import '../data/services/api_service.dart';

class JobVacanciesProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<JobVacancyModel> _jobs = [];
  bool _loading = false;
  bool _hasMore = true;
  String? _error;

  String _searchQuery = '';
  String? _selectedCity;
  String? _selectedCategory;
  String? _selectedSubject;
  String? _selectedEmploymentType;
  int _page = 1;

  List<JobVacancyModel> get jobs => _jobs;
  bool get loading => _loading;
  bool get hasMore => _hasMore;
  String? get error => _error;

  String get searchQuery => _searchQuery;
  String? get selectedCity => _selectedCity;
  String? get selectedCategory => _selectedCategory;
  String? get selectedSubject => _selectedSubject;
  String? get selectedEmploymentType => _selectedEmploymentType;

  JobVacanciesProvider() {
    fetchJobs(refresh: true);
  }

  Future<void> fetchJobs({bool refresh = false}) async {
    if (_loading) return;
    if (refresh) {
      _page = 1;
      _hasMore = true;
      _jobs = [];
    }
    if (!_hasMore) return;

    _loading = true;
    _error = null;
    notifyListeners();

    final result = await _api.getJobVacancies(
      search: _searchQuery,
      city: _selectedCity,
      category: _selectedCategory,
      subject: _selectedSubject,
      employmentType: _selectedEmploymentType,
      page: _page,
    );

    if (result.success && result.data != null) {
      final newItems = result.data!;
      if (refresh) {
        _jobs = newItems;
      } else {
        _jobs.addAll(newItems);
      }
      _hasMore = newItems.length >= 15;
      _page++;
    } else {
      _error = result.error;
    }

    _loading = false;
    notifyListeners();
  }

  void setCity(String? city) {
    if (_selectedCity == city) return;
    _selectedCity = (city == null || city == 'all' || city.isEmpty) ? null : city;
    fetchJobs(refresh: true);
  }

  void setCategory(String? category) {
    if (_selectedCategory == category) return;
    _selectedCategory = (category == null || category == 'all' || category.isEmpty) ? null : category;
    fetchJobs(refresh: true);
  }

  void setSubject(String? subject) {
    if (_selectedSubject == subject) return;
    _selectedSubject = (subject == null || subject == 'all' || subject.isEmpty) ? null : subject;
    fetchJobs(refresh: true);
  }

  void setSearch(String query) {
    _searchQuery = query;
    fetchJobs(refresh: true);
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCity = null;
    _selectedCategory = null;
    _selectedSubject = null;
    _selectedEmploymentType = null;
    fetchJobs(refresh: true);
  }

  Future<bool> postJob(Map<String, dynamic> form) async {
    final result = await _api.postJobVacancy(form);
    if (result.success) {
      await fetchJobs(refresh: true);
      return true;
    }
    return false;
  }
}
