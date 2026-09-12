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
    <div class="alert alert-success" style="margin-bottom: 20px;">
        {{ session('success') }}
    </div>
@endif

<!-- Stats Cards -->
<div class="stats-grid" style="margin-bottom: 24px;">
    <div class="stat-card" style="--stat-color: #F59E0B;">
        <div class="stat-icon" style="font-size: 20px;">⭐</div>
        <div class="stat-label">تێکڕای ڕەیتینگ</div>
        <div class="stat-value" style="color: #FBBF24;">{{ $avgRating }} <span style="font-size: 16px; color: var(--text-muted); font-weight: normal;">/ 5.0</span></div>
        <div class="stat-desc" style="color: #F59E0B;">
            {{ str_repeat('★', (int)round($avgRating)) }}{{ str_repeat('☆', 5 - (int)round($avgRating)) }}
        </div>
    </div>

    <div class="stat-card" style="--stat-color: #6366F1;">
        <div class="stat-icon" style="font-size: 20px;">💬</div>
        <div class="stat-label">کۆی تێبینی و دەنگەکان</div>
        <div class="stat-value" style="color: #A5B4FC;">{{ $totalCount }}</div>
        <div class="stat-desc" style="color: var(--text-muted);">تێبینی و هەڵسەنگاندن</div>
    </div>

    <div class="stat-card" style="--stat-color: #10B981; grid-column: span 2;">
        <div class="stat-label" style="margin-bottom: 10px;">دابەشبوونی ئەستێرەکان</div>
        <div style="display: flex; flex-wrap: wrap; gap: 8px;">
            @for($s = 5; $s >= 1; $s--)
                <div style="background: var(--bg-surface); border: 1px solid var(--border); padding: 6px 12px; border-radius: 8px; display: flex; align-items: center; gap: 6px;">
                    <span style="color: #F59E0B; font-weight: bold;">{{ $s }} ★</span>
                    <span style="font-weight: 800; color: var(--text-main); font-size: 14px;">{{ $ratingsBreakdown[$s] ?? 0 }}</span>
                </div>
            @endfor
        </div>
        <div class="stat-desc" style="margin-top: 8px; color: var(--text-muted);">پوختەی هەموو دەنگە تۆمارکراوەکان</div>
    </div>
</div>

<!-- Feedback Table -->
<div class="card">
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>بەکارهێنەر</th>
                    <th>ڕەیتینگ</th>
                    <th>جۆر</th>
                    <th>تێبینی / سەرنج</th>
                    <th>سیستەم / وەشان</th>
                    <th>کات</th>
                    <th style="text-align: center;">کردارەکان</th>
                </tr>
            </thead>
            <tbody>
                @forelse($feedbacks as $fb)
                    <tr>
                        <td>
                            <div style="font-weight: 700; color: var(--text-main);">
                                {{ $fb->user_name ?? ($fb->user ? $fb->user->name : 'مێوان') }}
                            </div>
                            @if($fb->user_phone)
                                <div style="font-size: 12px; color: var(--text-muted);" dir="ltr">
                                    {{ $fb->user_phone }}
                                </div>
                            @endif
                        </td>
                        <td>
                            <div style="display: inline-flex; align-items: center; gap: 4px; background: rgba(245, 158, 11, 0.12); padding: 4px 10px; border-radius: 8px; border: 1px solid rgba(245, 158, 11, 0.25);">
                                <span style="color: #FBBF24; font-size: 15px; letter-spacing: 1px;">
                                    {{ str_repeat('★', $fb->rating) }}
                                </span>
                                <span style="font-weight: 800; color: #FBBF24; font-size: 13px; margin-right: 4px;">
                                    ({{ $fb->rating }})
                                </span>
                            </div>
                        </td>
                        <td>
                            @php
                                $typeLabels = [
                                    'suggestion' => ['💡 پێشنیاز', '#38BDF8', 'rgba(56, 189, 248, 0.15)'],
                                    'bug'        => ['⚠️ کێشە', '#F87171', 'rgba(239, 68, 68, 0.15)'],
                                    'general'    => ['💬 گشتی', '#94A3B8', 'rgba(148, 163, 184, 0.15)'],
                                    'praise'     => ['❤️ دەستخۆشی', '#FBBF24', 'rgba(251, 191, 36, 0.15)'],
                                ];
                                $badge = $typeLabels[$fb->feedback_type] ?? ['💬 گشتی', '#94A3B8', 'rgba(148, 163, 184, 0.15)'];
                            @endphp
                            <span style="display: inline-block; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: 700; color: {{ $badge[1] }}; background: {{ $badge[2] }}; border: 1px solid {{ $badge[1] }}33;">
                                {{ $badge[0] }}
                            </span>
                        </td>
                        <td style="max-width: 340px;">
                            @if($fb->comment)
                                <div style="font-size: 13.5px; color: var(--text-main); line-height: 1.6; word-break: break-word;">
                                    {{ $fb->comment }}
                                </div>
                            @else
                                <span style="font-size: 12.5px; color: var(--text-muted); font-style: italic;">
                                    — هیچ تێبینییەکی نەنووسیوە —
                                </span>
                            @endif
                        </td>
                        <td>
                            <div style="font-size: 12px; color: var(--text-main); font-weight: 600;">
                                <span style="text-transform: uppercase;">{{ $fb->platform }}</span>
                            </div>
                            @if($fb->app_version)
                                <div style="font-size: 11px; color: var(--text-muted);">
                                    v{{ $fb->app_version }}
                                </div>
                            @endif
                        </td>
                        <td style="font-size: 12px; color: var(--text-muted); white-space: nowrap;" dir="ltr">
                            {{ $fb->created_at->diffForHumans() }}
                        </td>
                        <td style="text-align: center;">
                            <form action="{{ route('admin.feedbacks.destroy', $fb->id) }}" method="POST" onsubmit="return confirm('دڵنیایت لە سڕینەوەی ئەم تێبینییە؟')">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-ghost" style="color: var(--danger); padding: 6px 12px; border-radius: 8px;" title="سڕینەوە">
                                    سڕینەوە
                                </button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 48px; color: var(--text-muted);">
                            <div style="font-size: 32px; margin-bottom: 8px;">📭</div>
                            هێشتا هیچ تێبینی و ڕەیتینگێک تۆمار نەکراوە.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    @if($feedbacks->hasPages())
        <div style="padding: 16px; border-top: 1px solid var(--border);">
            {{ $feedbacks->links() }}
        </div>
    @endif
</div>
@endsection
