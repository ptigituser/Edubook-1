<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\AppVersion;
use Illuminate\Http\Request;

class AppVersionController extends Controller
{
    public function index()
    {
        $android = AppVersion::where('platform', AppVersion::PLATFORM_ANDROID)->first();
        if (!$android) {
            $android = AppVersion::create([
                'platform' => AppVersion::PLATFORM_ANDROID,
                'version' => '1.1.0',
                'build_number' => 27,
                'force_update' => false,
                'store_url' => 'https://play.google.com/store/apps/details?id=com.khwenden.ibrahim',
                'release_notes' => 'نوێکردنەوە و چاکسازی لە ئەپڵیکەیشن.',
            ]);
        }

        $ios = AppVersion::where('platform', AppVersion::PLATFORM_IOS)->first();
        if (!$ios) {
            $ios = AppVersion::create([
                'platform' => AppVersion::PLATFORM_IOS,
                'version' => '1.1.0',
                'build_number' => 27,
                'force_update' => false,
                'store_url' => 'https://apps.apple.com',
                'release_notes' => 'نوێکردنەوە و چاکسازی لە ئەپڵیکەیشن.',
            ]);
        }

        return view('admin.app-versions.index', compact('android', 'ios'));
    }

    public function update(Request $request, $id)
    {
        $version = AppVersion::findOrFail($id);

        $validated = $request->validate([
            'version'          => 'required|string|max:50',
            'build_number'     => 'required|integer|min:1',
            'force_update'     => 'nullable|boolean',
            'store_url'        => 'required|url|max:500',
            'release_notes'    => 'nullable|string',
            'release_notes_en' => 'nullable|string',
            'release_notes_ar' => 'nullable|string',
        ]);

        $validated['force_update'] = $request->boolean('force_update');

        $version->update($validated);

        return back()->with('success', 'زانیارییەکانی وەشانی ئەپ بە سەرکەوتوویی نوێکرانەوە.');
    }
}
