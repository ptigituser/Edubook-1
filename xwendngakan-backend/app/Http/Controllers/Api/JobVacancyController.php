<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\JobVacancy;
use App\Models\Institution;
use Illuminate\Http\Request;

class JobVacancyController extends Controller
{
    /**
     * Get list of active job vacancies with filters.
     */
    public function index(Request $request)
    {
        $query = JobVacancy::query()
            ->where('is_active', true)
            ->where('is_approved', true);

        if ($request->filled('search')) {
            $s = trim($request->search);
            $query->where(function ($q) use ($s) {
                $q->where('title', 'like', "%{$s}%")
                  ->orWhere('institution_name', 'like', "%{$s}%")
                  ->orWhere('subject', 'like', "%{$s}%")
                  ->orWhere('description', 'like', "%{$s}%");
            });
        }

        if ($request->filled('city') && $request->city !== 'all') {
            $query->where('city', $request->city);
        }

        if ($request->filled('category') && $request->category !== 'all') {
            $query->where('category', $request->category);
        }

        if ($request->filled('subject') && $request->subject !== 'all') {
            $query->where('subject', $request->subject);
        }

        if ($request->filled('employment_type') && $request->employment_type !== 'all') {
            $query->where('employment_type', $request->employment_type);
        }

        if ($request->filled('institution_id')) {
            $query->where('institution_id', $request->institution_id);
        }

        $vacancies = $query->orderByDesc('id')->paginate(15);

        return response()->json([
            'success'      => true,
            'data'         => $vacancies->items(),
            'current_page' => $vacancies->currentPage(),
            'last_page'    => $vacancies->lastPage(),
            'total'        => $vacancies->total(),
        ]);
    }

    /**
     * Get single vacancy detail and increment views.
     */
    public function show($id)
    {
        $vacancy = JobVacancy::find($id);

        if (!$vacancy) {
            return response()->json([
                'success' => false,
                'message' => 'هەلی کارەکە نەدۆزرایەوە',
            ], 404);
        }

        $vacancy->increment('views_count');

        return response()->json([
            'success' => true,
            'data'    => $vacancy,
        ]);
    }

    /**
     * Store new job vacancy.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'institution_id'   => 'nullable|exists:institutions,id',
            'institution_name' => 'required|string|max:255',
            'title'            => 'required|string|max:255',
            'category'         => 'required|string|max:100',
            'subject'          => 'nullable|string|max:100',
            'education_level'  => 'nullable|string|max:100',
            'employment_type'  => 'required|string|max:50',
            'city'             => 'required|string|max:100',
            'salary_range'     => 'nullable|string|max:100',
            'gender'           => 'nullable|string|max:20',
            'experience_years' => 'nullable|string|max:50',
            'description'      => 'required|string',
            'requirements'     => 'nullable|string',
            'contact_phone'    => 'required|string|max:50',
            'contact_whatsapp' => 'nullable|string|max:50',
            'contact_email'    => 'nullable|email|max:100',
        ]);

        if (!empty($validated['institution_id'])) {
            $inst = Institution::find($validated['institution_id']);
            if ($inst) {
                $validated['institution_name'] = $inst->nku ?? $inst->nen ?? $validated['institution_name'];
                $validated['institution_logo'] = $inst->logo;
            }
        }

        $vacancy = JobVacancy::create($validated);

        return response()->json([
            'success' => true,
            'data'    => $vacancy,
            'message' => 'هەلی کارەکە بە سەرکەوتوویی بڵاوکرایەوە',
        ], 201);
    }

    /**
     * Get brief stats for jobs.
     */
    public function stats()
    {
        $totalJobs = JobVacancy::where('is_active', true)->count();
        $teacherJobs = JobVacancy::where('is_active', true)->where('category', 'teacher')->count();
        $adminJobs = JobVacancy::where('is_active', true)->where('category', 'admin')->count();

        return response()->json([
            'success' => true,
            'data'    => [
                'total'   => $totalJobs,
                'teacher' => $teacherJobs,
                'admin'   => $adminJobs,
            ],
        ]);
    }
}
