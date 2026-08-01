@extends('doctor.layouts.app')
@section('header_title', 'ڕێکخستنی پڕۆفایل')

@section('content')
<div class="mb-6">
    <h2 class="text-xl font-bold text-slate-800">ڕێکخستنەکانی پڕۆفایل</h2>
    <p class="text-sm text-slate-500 mt-1">لێرە دەتوانیت زانیارییە کەسییەکان و پیشەییەکانت نوێ بکەیتەوە.</p>
</div>

@if(session('success'))
    <div class="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 rounded-xl">
        {{ session('success') }}
    </div>
@endif

@if(session('error'))
    <div class="mb-6 p-4 bg-red-50 border border-red-200 text-red-700 rounded-xl font-medium">
        {{ session('error') }}
    </div>
@endif

<form id="profile-form" action="{{ route('doctor.profile.update') }}" method="POST" enctype="multipart/form-data" class="bg-white rounded-2xl shadow-sm border border-slate-200/60 p-6 max-w-3xl">
    @csrf
    @method('PUT')
    
    <div class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Name -->
            <div>
                <label for="name" class="block text-sm font-medium text-slate-700 mb-2">ناوی تەواو</label>
                <input type="text" id="name" name="name" value="{{ old('name', $user->name) }}" required
                    class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium text-slate-700">
                @error('name') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>

            <!-- Phone -->
            <div>
                <label for="phone" class="block text-sm font-medium text-slate-700 mb-2">ژمارە مۆبایل</label>
                <input type="text" id="phone" name="phone" value="{{ old('phone', $user->phone) }}" required dir="ltr"
                    class="w-full text-right px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium text-slate-700">
                @error('phone') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>
        </div>

        @if($doctor)
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Specialty -->
            <div>
                <label for="specialty" class="block text-sm font-medium text-slate-700 mb-2">پسپۆڕی</label>
                <input type="text" id="specialty" name="specialty" value="{{ old('specialty', $doctor->specialty) }}"
                    class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium text-slate-700">
                @error('specialty') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>

            <!-- Consultation Fee -->
            <div>
                <label for="consultation_fee" class="block text-sm font-medium text-slate-700 mb-2">نرخی بینین ($)</label>
                <input type="number" step="0.01" id="consultation_fee" name="consultation_fee" value="{{ old('consultation_fee', $doctor->consultation_fee) }}" dir="ltr"
                    class="w-full text-right px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium text-slate-700">
                @error('consultation_fee') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>
        </div>

        <!-- Bio -->
        <div>
            <label for="bio" class="block text-sm font-medium text-slate-700 mb-2">کورتەیەک دەربارەی خۆت</label>
            <textarea id="bio" name="bio" rows="4"
                class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium text-slate-700">{{ old('bio', $doctor->bio) }}</textarea>
            @error('bio') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>
        
        <!-- Video Upload -->
        <div class="border border-slate-200 rounded-xl p-4 bg-slate-50/50">
            <h3 class="text-sm font-semibold text-slate-800 mb-4">ڤیدیۆی ناساندن (هەڵبژاردەیی)</h3>
            
            <div class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-slate-700 mb-2">جۆری ڤیدیۆ هەڵبژێرە</label>
                    <div class="flex gap-4">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="video_type" value="youtube" class="text-blue-600 focus:ring-blue-500" {{ old('video_type', $doctor->video_type) == 'youtube' ? 'checked' : '' }} onchange="toggleVideoInputs('youtube')">
                            <span class="text-sm text-slate-700">لینکی یوتیوب</span>
                        </label>
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="radio" name="video_type" value="uploaded" class="text-blue-600 focus:ring-blue-500" {{ old('video_type', $doctor->video_type) == 'uploaded' ? 'checked' : '' }} onchange="toggleVideoInputs('uploaded')">
                            <span class="text-sm text-slate-700">ئەپلۆدکردنی ڤیدیۆ</span>
                        </label>
                    </div>
                </div>

                <div id="youtube_input" class="{{ old('video_type', $doctor->video_type) == 'youtube' ? 'block' : 'hidden' }}">
                    <label for="youtube_url" class="block text-sm font-medium text-slate-700 mb-2">لینکی یوتیوب</label>
                    <input type="url" id="youtube_url" name="youtube_url" value="{{ old('youtube_url', $doctor->video_type == 'youtube' ? $doctor->video_url : '') }}" placeholder="https://youtube.com/watch?v=..." dir="ltr"
                        class="w-full text-left px-4 py-2 bg-white border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500">
                    @error('youtube_url') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
                </div>

                <div id="upload_input" class="{{ old('video_type', $doctor->video_type) == 'uploaded' ? 'block' : 'hidden' }}">
                    <label for="video_file" class="block text-sm font-medium text-slate-700 mb-2">فایلی ڤیدیۆ هەڵبژێرە (Max 50MB)</label>
                    <input type="file" id="video_file" name="video_file" accept="video/mp4,video/x-m4v,video/*"
                        class="block w-full text-sm text-slate-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100">
                    @error('video_file') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
                    
                    @if($doctor->video_type == 'uploaded' && $doctor->video_url)
                        <div class="mt-2 text-sm text-green-600">ڤیدیۆیەک پێشتر ئەپلۆد کراوە.</div>
                    @endif
                </div>
            </div>
        </div>
        @endif

        <div class="pt-4 border-t border-slate-100 flex justify-end">
            <button id="submit-btn" type="submit" class="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-medium transition-colors shadow-lg shadow-blue-500/30 flex items-center justify-center min-w-[140px]">
                پاشەکەوتکردن
            </button>
        </div>
    </div>
</form>

<script>
    function toggleVideoInputs(type) {
        document.getElementById('youtube_input').style.display = type === 'youtube' ? 'block' : 'none';
        document.getElementById('upload_input').style.display = type === 'uploaded' ? 'block' : 'none';
    }

    document.getElementById('profile-form').addEventListener('submit', function() {
        var btn = document.getElementById('submit-btn');
        btn.disabled = true;
        btn.innerHTML = '<svg class="animate-spin -ml-1 mr-2 h-5 w-5 text-white inline-block" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg> چاوەڕێ بکە...';
        btn.classList.add('opacity-70', 'cursor-not-allowed');
    });
</script>
@endsection
