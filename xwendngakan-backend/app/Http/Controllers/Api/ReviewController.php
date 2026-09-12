<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Institution;
use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    /**
     * Get reviews and rating summary for an institution.
     */
    public function index(Request $request, int $institutionId)
    {
        $institution = Institution::findOrFail($institutionId);

        $reviews = Review::where('institution_id', $institutionId)
            ->latest()
            ->get();

        $totalReviews = $reviews->count();
        $avgRating = $totalReviews > 0 ? round($reviews->avg('rating'), 1) : 0.0;

        // Distribution of ratings (1 to 5 stars)
        $distribution = [
            5 => $reviews->where('rating', 5)->count(),
            4 => $reviews->where('rating', 4)->count(),
            3 => $reviews->where('rating', 3)->count(),
            2 => $reviews->where('rating', 2)->count(),
            1 => $reviews->where('rating', 1)->count(),
        ];

        // Check if the current authenticated user has already submitted a review
        $currentUser = auth('sanctum')->user();
        $userReview = null;
        if ($currentUser) {
            $userReview = $reviews->firstWhere('user_id', $currentUser->id);
        }

        return response()->json([
            'success' => true,
            'data' => [
                'summary' => [
                    'average_rating' => $avgRating,
                    'total_reviews'  => $totalReviews,
                    'distribution'   => $distribution,
                ],
                'user_review' => $userReview,
                'reviews'     => $reviews->values(),
            ],
        ]);
    }

    /**
     * Submit or update a review for an institution.
     */
    public function store(Request $request, int $institutionId)
    {
        $request->validate([
            'rating'    => 'required|integer|min:1|max:5',
            'comment'   => 'nullable|string|max:1000',
            'user_name' => 'nullable|string|max:100',
        ]);

        $institution = Institution::findOrFail($institutionId);
        $user = $request->user('sanctum') ?? $request->user();

        $userName = $user?->name ?? $request->input('user_name') ?? 'بەکارهێنەر';
        $userAvatar = $user?->avatar ?? null;
        $userId = $user?->id;

        if ($userId) {
            // Update or create review by this user
            $review = Review::updateOrCreate(
                [
                    'institution_id' => $institutionId,
                    'user_id'        => $userId,
                ],
                [
                    'user_name'   => $userName,
                    'user_avatar' => $userAvatar,
                    'rating'      => $request->rating,
                    'comment'     => $request->comment,
                ]
            );
        } else {
            // Guest review
            $review = Review::create([
                'institution_id' => $institutionId,
                'user_id'        => null,
                'user_name'      => $userName,
                'user_avatar'    => null,
                'rating'         => $request->rating,
                'comment'        => $request->comment,
            ]);
        }

        // Fresh summary
        $allReviews = Review::where('institution_id', $institutionId)->get();
        $totalReviews = $allReviews->count();
        $avgRating = $totalReviews > 0 ? round($allReviews->avg('rating'), 1) : 0.0;
        $distribution = [
            5 => $allReviews->where('rating', 5)->count(),
            4 => $allReviews->where('rating', 4)->count(),
            3 => $allReviews->where('rating', 3)->count(),
            2 => $allReviews->where('rating', 2)->count(),
            1 => $allReviews->where('rating', 1)->count(),
        ];

        return response()->json([
            'success' => true,
            'message' => 'هەڵسەنگاندنەکەت بە سەرکەوتوویی تۆمارکرا.',
            'data'    => [
                'review'  => $review,
                'summary' => [
                    'average_rating' => $avgRating,
                    'total_reviews'  => $totalReviews,
                    'distribution'   => $distribution,
                ],
            ],
        ], 201);
    }

    /**
     * Delete a review.
     */
    public function destroy(Request $request, int $id)
    {
        $review = Review::findOrFail($id);
        $user = $request->user();

        // Must be the owner or an admin
        if ($user && ($user->id === $review->user_id || $user->is_admin)) {
            $review->delete();

            return response()->json([
                'success' => true,
                'message' => 'هەڵسەنگاندنەکە بە سەرکەوتوویی سڕایەوە.',
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'ڕێگەت پێدراو نییە بۆ سڕینەوەی ئەم هەڵسەنگاندنە.',
        ], 403);
    }
}
