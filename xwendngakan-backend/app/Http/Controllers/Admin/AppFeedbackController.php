<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AppFeedback;
use Illuminate\Http\Request;

class AppFeedbackController extends Controller
{
    public function index(Request $request)
    {
        $query = AppFeedback::latest();

        if ($request->filled('rating')) {
            $query->where('rating', $request->rating);
        }

        if ($request->filled('type')) {
            $query->where('feedback_type', $request->type);
        }

        $feedbacks = $query->paginate(20);

        $totalCount = AppFeedback::count();
        $avgRating = $totalCount > 0 ? round(AppFeedback::avg('rating'), 1) : 5.0;
        $ratingsBreakdown = [
            5 => AppFeedback::where('rating', 5)->count(),
            4 => AppFeedback::where('rating', 4)->count(),
            3 => AppFeedback::where('rating', 3)->count(),
            2 => AppFeedback::where('rating', 2)->count(),
            1 => AppFeedback::where('rating', 1)->count(),
        ];

        return view('admin.feedbacks.index', compact('feedbacks', 'totalCount', 'avgRating', 'ratingsBreakdown'));
    }

    public function destroy($id)
    {
        $feedback = AppFeedback::findOrFail($id);
        $feedback->delete();

        return back()->with('success', 'تێبینییەکە بە سەرکەوتوویی سڕایەوە.');
    }
}
