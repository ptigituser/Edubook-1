<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AppVersion;
use Illuminate\Http\Request;

class AppVersionController extends Controller
{
    /**
     * Check for app updates.
     */
    public function check(Request $request)
    {
        return response()->json([
            'success' => true,
            'data'    => [
                'update_available' => false,
                'force_update'     => false,
            ],
        ]);
    }
}
