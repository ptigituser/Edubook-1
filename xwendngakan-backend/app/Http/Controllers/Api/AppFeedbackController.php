<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AppFeedback;
use Illuminate\Http\Request;

class AppFeedbackController extends Controller
{
    /**
     * Store new feedback or rating from the mobile app.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'rating'        => 'required|integer|min:1|max:5',
            'feedback_type' => 'nullable|string|max:50',
            'comment'       => 'nullable|string|max:3000',
            'platform'      => 'nullable|string|max:20',
            'app_version'   => 'nullable|string|max:50',
            'device_info'   => 'nullable|string|max:255',
            'user_name'     => 'nullable|string|max:100',
            'user_phone'    => 'nullable|string|max:50',
        ]);

        $user = $request->user();

        $feedback = AppFeedback::create([
            'user_id'       => $user?->id,
            'user_name'     => $validated['user_name'] ?? $user?->name ?? 'مێوان',
            'user_phone'    => $validated['user_phone'] ?? $user?->phone,
            'rating'        => $validated['rating'],
            'feedback_type' => $validated['feedback_type'] ?? 'general',
            'comment'       => $validated['comment'] ?? null,
            'platform'      => $validated['platform'] ?? 'android',
            'app_version'   => $validated['app_version'] ?? null,
            'device_info'   => $validated['device_info'] ?? null,
            'is_reviewed'   => false,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Feedback received successfully.',
            'data'    => $feedback,
        ], 201);
    }
}
