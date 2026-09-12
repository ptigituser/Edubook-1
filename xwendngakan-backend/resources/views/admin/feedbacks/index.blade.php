@extends('admin.layouts.app')

@section('title', 'ڕەیتینگ و تێبینییەکان')

@section('content')
<div class="page-header">
    <div>
        <h1>ڕەیتینگ و تێبینی بەکارهێنەران</h1>
        <div class="breadcrumb">ئەو سەرنج و هەڵسەنگاندنانەی کە بەکارهێنەران لە ئەپڵیکەیشنەوە ناردوویانە</div>
    </div>
</div>

@if(session('success'))
    <div class="alert alert-success mb-4" style="background: #10B981; color: white; border-radius: 12px; padding: 12px 16px; margin-bottom: 20px;">
        {{ session('success') }}
    </div>
@endif

<!-- Stats Cards -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 24px;">
    <div class="card" style="padding: 20px; display: flex; align-items: center; gap: 16px;">
        <div style="width: 50px; height: 50px; border-radius: 12px; background: #FEF3C7; color: #D97706; display: flex; align-items: center; justify-content: center; font-size: 24px;">
            ⭐
        </div>
        <div>
            <div style="font-size: 13px; color: #64748B;">تێکڕای ڕەیتینگ</div>
            <div style="font-size: 24px; font-weight: bold; color: #0F172A;">{{ $avgRating }} / 5.0</div>
        </div>
    </div>

    <div class="card" style="padding: 20px; display: flex; align-items: center; gap: 16px;">
        <div style="width: 50px; height: 50px; border-radius: 12px; background: #E0E7FF; color: #4F46E5; display: flex; align-items: center; justify-content: center; font-size: 24px;">
            💬
        </div>
        <div>
            <div style="font-size: 13px; color: #64748B;">کۆی تێبینی و دەنگەکان</div>
            <div style="font-size: 24px; font-weight: bold; color: #0F172A;">{{ $totalCount }}</div>
        </div>
    </div>

    <div class="card" style="padding: 20px;">
        <div style="font-size: 12px; color: #64748B; margin-bottom: 8px;">دابەشبوونی ئەستێرەکان</div>
        <div style="display: flex; gap: 8px; font-size: 12px;">
            <span>5⭐ ({{ $ratingsBreakdown[5] }})</span>
            <span>4⭐ ({{ $ratingsBreakdown[4] }})</span>
            <span>3⭐ ({{ $ratingsBreakdown[3] }})</span>
            <span>2⭐ ({{ $ratingsBreakdown[2] }})</span>
            <span>1⭐ ({{ $ratingsBreakdown[1] }})</span>
        </div>
    </div>
</div>

<!-- Feedback Table -->
<div class="card">
    <div style="overflow-x: auto;">
        <table class="table" style="width: 100%; border-collapse: collapse;">
            <thead>
                <tr style="border-bottom: 2px solid #F1F5F9; text-align: right;">
                    <th style="padding: 12px 16px;">بەکارهێنەر</th>
                    <th style="padding: 12px 16px;">ڕەیتینگ</th>
                    <th style="padding: 12px 16px;">جۆر</th>
                    <th style="padding: 12px 16px;">تێبینی / سەرنج</th>
                    <th style="padding: 12px 16px;">سیستەم / وەشان</th>
                    <th style="padding: 12px 16px;">کات</th>
                    <th style="padding: 12px 16px; text-align: center;">کردارەکان</th>
                </tr>
            </thead>
            <tbody>
                @forelse($feedbacks as $fb)
                    <tr style="border-bottom: 1px solid #F1F5F9;">
                        <td style="padding: 12px 16px;">
                            <strong>{{ $fb->user_name ?? ($fb->user ? $fb->user->name : 'مێوان') }}</strong>
                            @if($fb->user_phone)
                                <div style="font-size: 12px; color: #64748B;" dir="ltr">{{ $fb->user_phone }}</div>
                            @endif
                        </td>
                        <td style="padding: 12px 16px;">
                            <span style="color: #F59E0B; font-weight: bold;">
                                {{ str_repeat('⭐', $fb->rating) }} ({{ $fb->rating }})
                            </span>
                        </td>
                        <td style="padding: 12px 16px;">
                            @php
                                $typeLabels = [
                                    'suggestion' => ['💡 پێشنیاز', '#0284C7', '#E0F2FE'],
                                    'bug'        => ['⚠️ کێشە', '#DC2626', '#FEE2E2'],
                                    'general'    => ['💬 گشتی', '#4B5563', '#F3F4F6'],
                                    'praise'     => ['❤️ دەستخۆشی', '#D97706', '#FEF3C7'],
                                ];
                                $badge = $typeLabels[$fb->feedback_type] ?? ['💬 گشتی', '#4B5563', '#F3F4F6'];
                            @endphp
                            <span style="display: inline-block; padding: 3px 10px; border-radius: 9999px; font-size: 12px; font-weight: 600; color: {{ $badge[1] }}; background: {{ $badge[2] }};">
                                {{ $badge[0] }}
                            </span>
                        </td>
                        <td style="padding: 12px 16px; max-width: 320px;">
                            <div style="font-size: 13px; color: #1E293B; line-height: 1.5;">
                                {{ $fb->comment ?: '— هیچ تێبینییەکی نەنووسیوە —' }}
                            </div>
                        </td>
                        <td style="padding: 12px 16px; font-size: 12px; color: #64748B;">
                            <span style="text-transform: uppercase; font-weight: 600;">{{ $fb->platform }}</span>
                            @if($fb->app_version)
                                <span> • v{{ $fb->app_version }}</span>
                            @endif
                        </td>
                        <td style="padding: 12px 16px; font-size: 12px; color: #64748B;" dir="ltr">
                            {{ $fb->created_at->diffForHumans() }}
                        </td>
                        <td style="padding: 12px 16px; text-align: center;">
                            <form action="{{ route('admin.feedbacks.destroy', $fb->id) }}" method="POST" onsubmit="return confirm('دڵنیایت لە سڕینەوەی ئەم تێبینییە؟')">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-ghost" style="color: #EF4444; padding: 6px 10px; border-radius: 8px;">
                                    سڕینەوە
                                </button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 40px; color: #94A3B8;">
                            هێشتا هیچ تێبینی و ڕەیتینگێک تۆمار نەکراوە.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    @if($feedbacks->hasPages())
        <div style="padding: 16px;">
            {{ $feedbacks->links() }}
        </div>
    @endif
</div>
@endsection
