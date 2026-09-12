@extends('admin.layouts.app')

@section('title', 'وەشانی ئەپ (فۆرس ئەپدەیت)')

@section('content')
<div class="page-header">
    <div>
        <h1>وەشانی ئەپ و فۆرس ئەپدەیت</h1>
        <div class="breadcrumb">دیاریکردنی دوایین وەشانی مۆبایل ئەپ و چالاککردنی نوێکردنەوەی ناچاری (Force Update)</div>
    </div>
</div>

@if(session('success'))
    <div class="alert alert-success mb-4" style="background: #10B981; color: white; border-radius: 12px; padding: 12px 16px; margin-bottom: 20px;">
        {{ session('success') }}
    </div>
@endif

<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(360px, 1fr)); gap: 24px;">

    <!-- Android Version Card -->
    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #E2E8F0; padding-bottom: 16px; margin-bottom: 20px;">
            <div style="display: flex; align-items: center; gap: 12px;">
                <div style="width: 44px; height: 44px; border-radius: 12px; background: #DCFCE7; color: #16A34A; display: flex; align-items: center; justify-content: center; font-size: 24px;">
                    🤖
                </div>
                <div>
                    <h3 style="margin: 0; font-size: 18px; color: #0F172A;">Android (گووگڵ پلەی)</h3>
                    <div style="font-size: 12px; color: #64748B;">پلاتفۆرمی ئەندرۆید</div>
                </div>
            </div>
            <div>
                @if($android->force_update)
                    <span style="background: #FEE2E2; color: #DC2626; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: bold;">
                        🚨 فۆرس ئەپدەیت چالاکە
                    </span>
                @else
                    <span style="background: #E2E8F0; color: #475569; padding: 4px 10px; border-radius: 9999px; font-size: 12px;">
                        ئارەزوومەندانە
                    </span>
                @endif
            </div>
        </div>

        <form action="{{ route('admin.app-versions.update', $android->id) }}" method="POST">
            @csrf
            @method('PUT')

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                <div class="form-group">
                    <label class="form-label">وەشان (Version) <span class="required">*</span></label>
                    <input type="text" name="version" class="form-control" value="{{ old('version', $android->version) }}" placeholder="1.1.0" required>
                </div>
                <div class="form-group">
                    <label class="form-label">ژمارەی بڵاوکراوە (Build) <span class="required">*</span></label>
                    <input type="number" name="build_number" class="form-control" value="{{ old('build_number', $android->build_number) }}" placeholder="27" required>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label">بەستەری گووگڵ پلەی (Store URL) <span class="required">*</span></label>
                <input type="url" name="store_url" class="form-control" value="{{ old('store_url', $android->store_url) }}" dir="ltr" required>
            </div>

            <!-- Force Update Toggle -->
            <div style="background: #FFFBEB; border: 1px solid #FDE68A; border-radius: 12px; padding: 14px; margin-bottom: 20px;">
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: 700; color: #92400E;">
                    <input type="checkbox" name="force_update" value="1" {{ $android->force_update ? 'checked' : '' }} style="width: 18px; height: 18px;">
                    چالاککردنی نوێکردنەوەی ناچاری (Force Update)
                </label>
                <div style="font-size: 12px; color: #B45309; margin-top: 6px;">
                    ئەگەر ئەم بژاردەیە دیاری بکەیت، بەکارهێنەرانی ئەندرۆید کە وەشانی کۆنتریان پێیە ناتوانن لە ئەپ بەردەوام بن تا نوێی نەکەنەوە.
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label">تێبینی نوێکردنەوە بە کوردی (Release Notes - Sorani)</label>
                <textarea name="release_notes" class="form-control" rows="3">{{ old('release_notes', $android->release_notes) }}</textarea>
            </div>

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label">Release Notes (English)</label>
                <textarea name="release_notes_en" class="form-control" rows="2" dir="ltr">{{ old('release_notes_en', $android->release_notes_en) }}</textarea>
            </div>

            <div class="form-group" style="margin-bottom: 20px;">
                <label class="form-label">ملاحظات التحديث (العربية)</label>
                <textarea name="release_notes_ar" class="form-control" rows="2">{{ old('release_notes_ar', $android->release_notes_ar) }}</textarea>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">
                پاشەکەوتکردنی زانیارییەکانی ئەندرۆید
            </button>
        </form>
    </div>

    <!-- iOS Version Card -->
    <div class="card">
        <div style="display: flex; align-items: center; justify-content: space-between; border-bottom: 1px solid #E2E8F0; padding-bottom: 16px; margin-bottom: 20px;">
            <div style="display: flex; align-items: center; gap: 12px;">
                <div style="width: 44px; height: 44px; border-radius: 12px; background: #F1F5F9; color: #0F172A; display: flex; align-items: center; justify-content: center; font-size: 24px;">
                    🍎
                </div>
                <div>
                    <h3 style="margin: 0; font-size: 18px; color: #0F172A;">iOS (ئەپ ستۆڕ)</h3>
                    <div style="font-size: 12px; color: #64748B;">پلاتفۆرمی ئایفۆن و ئایپاد</div>
                </div>
            </div>
            <div>
                @if($ios->force_update)
                    <span style="background: #FEE2E2; color: #DC2626; padding: 4px 10px; border-radius: 9999px; font-size: 12px; font-weight: bold;">
                        🚨 فۆرس ئەپدەیت چالاکە
                    </span>
                @else
                    <span style="background: #E2E8F0; color: #475569; padding: 4px 10px; border-radius: 9999px; font-size: 12px;">
                        ئارەزوومەندانە
                    </span>
                @endif
            </div>
        </div>

        <form action="{{ route('admin.app-versions.update', $ios->id) }}" method="POST">
            @csrf
            @method('PUT')

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                <div class="form-group">
                    <label class="form-label">وەشان (Version) <span class="required">*</span></label>
                    <input type="text" name="version" class="form-control" value="{{ old('version', $ios->version) }}" placeholder="1.1.0" required>
                </div>
                <div class="form-group">
                    <label class="form-label">ژمارەی بڵاوکراوە (Build) <span class="required">*</span></label>
                    <input type="number" name="build_number" class="form-control" value="{{ old('build_number', $ios->build_number) }}" placeholder="27" required>
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label">بەستەری ئەپ ستۆڕ (Store URL) <span class="required">*</span></label>
                <input type="url" name="store_url" class="form-control" value="{{ old('store_url', $ios->store_url) }}" dir="ltr" required>
            </div>

            <!-- Force Update Toggle -->
            <div style="background: #FFFBEB; border: 1px solid #FDE68A; border-radius: 12px; padding: 14px; margin-bottom: 20px;">
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-weight: 700; color: #92400E;">
                    <input type="checkbox" name="force_update" value="1" {{ $ios->force_update ? 'checked' : '' }} style="width: 18px; height: 18px;">
                    چالاککردنی نوێکردنەوەی ناچاری (Force Update)
                </label>
                <div style="font-size: 12px; color: #B45309; margin-top: 6px;">
                    ئەگەر ئەم بژاردەیە دیاری بکەیت، بەکارهێنەرانی iOS دەبێت نوێکردنەوە بکەن تا بتوانن بەردەوام بن.
                </div>
            </div>

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label">تێبینی نوێکردنەوە بە کوردی (Release Notes - Sorani)</label>
                <textarea name="release_notes" class="form-control" rows="3">{{ old('release_notes', $ios->release_notes) }}</textarea>
            </div>

            <div class="form-group" style="margin-bottom: 16px;">
                <label class="form-label">Release Notes (English)</label>
                <textarea name="release_notes_en" class="form-control" rows="2" dir="ltr">{{ old('release_notes_en', $ios->release_notes_en) }}</textarea>
            </div>

            <div class="form-group" style="margin-bottom: 20px;">
                <label class="form-label">ملاحظات التحديث (العربية)</label>
                <textarea name="release_notes_ar" class="form-control" rows="2">{{ old('release_notes_ar', $ios->release_notes_ar) }}</textarea>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center;">
                پاشەکەوتکردنی زانیارییەکانی ئایفۆن
            </button>
        </form>
    </div>

</div>
@endsection
