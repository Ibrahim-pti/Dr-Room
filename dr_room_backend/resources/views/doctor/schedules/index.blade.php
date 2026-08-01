@extends('doctor.layouts.app')
@section('header_title', 'خشتەی کارکردن')

@section('content')

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

<div class="mb-6">
    <h2 class="text-xl font-bold text-slate-800">کاتەکانی کارکردن</h2>
    <p class="text-sm text-slate-500 mt-1">ئەو کاتانە دیاری بکە کە نەخۆشەکان دەتوانن نۆرەت لێ بگرن.</p>
</div>

<!-- Add New Schedule Form -->
<form action="{{ route('doctor.schedules.store') }}" method="POST" class="bg-white rounded-2xl shadow-sm border border-slate-200/60 p-6 mb-8 max-w-5xl">
    @csrf
    
    <div class="mb-6">
        <label class="block text-sm font-medium text-slate-700 mb-3">ڕۆژەکان (دەتوانیت چەند ڕۆژێک بەیەکەوە هەڵبژێریت)</label>
        <div class="flex flex-wrap gap-4">
            @php
                $days = [
                    'Saturday' => 'شەممە',
                    'Sunday' => 'یەکشەممە',
                    'Monday' => 'دووشەممە',
                    'Tuesday' => 'سێشەممە',
                    'Wednesday' => 'چوارشەممە',
                    'Thursday' => 'پێنجشەممە',
                    'Friday' => 'هەینی'
                ];
            @endphp
            @foreach($days as $en => $ku)
            <label class="inline-flex items-center bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 cursor-pointer hover:bg-slate-100 transition-colors">
                <input type="checkbox" name="days[]" value="{{ $en }}" class="w-4 h-4 text-blue-600 bg-white border-slate-300 rounded focus:ring-blue-500 focus:ring-2">
                <span class="mr-2 text-sm font-medium text-slate-700">{{ $ku }}</span>
            </label>
            @endforeach
        </div>
        @error('days') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
    </div>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <div>
            <label for="start_time" class="block text-sm font-medium text-slate-700 mb-2">کاتی دەستپێکردن</label>
            <input type="time" id="start_time" name="start_time" required
                class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 font-medium text-slate-700">
            @error('start_time') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>

        <div>
            <label for="end_time" class="block text-sm font-medium text-slate-700 mb-2">کاتی کۆتایهاتن</label>
            <input type="time" id="end_time" name="end_time" required
                class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 font-medium text-slate-700">
            @error('end_time') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>

        <div>
            <label for="slot_minutes" class="block text-sm font-medium text-slate-700 mb-2">ماوەی هەر نۆرەیەک</label>
            <select id="slot_minutes" name="slot_minutes" required
                class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 font-medium text-slate-700">
                @foreach([10, 15, 20, 30, 45, 60] as $minutes)
                    <option value="{{ $minutes }}" {{ old('slot_minutes', 30) == $minutes ? 'selected' : '' }}>{{ $minutes }} خولەک</option>
                @endforeach
            </select>
            <p class="text-xs text-slate-400 mt-1">کاتەکە بەم ماوەیە دابەش دەکرێت.</p>
            @error('slot_minutes') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>
    </div>

    <div class="flex justify-end">
        <button type="submit" class="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-medium transition-colors shadow-lg shadow-blue-500/30">
            زیادکردنی کاتەکان
        </button>
    </div>
</form>

<!-- Existing Schedules List -->
<div class="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden max-w-5xl mb-12">
    <table class="w-full text-right text-sm">
        <thead class="bg-slate-50 text-slate-600 font-medium">
            <tr>
                <th class="py-4 px-6 border-b border-slate-200">ڕۆژ</th>
                <th class="py-4 px-6 border-b border-slate-200">کاتی دەستپێکردن</th>
                <th class="py-4 px-6 border-b border-slate-200">کاتی کۆتایهاتن</th>
                <th class="py-4 px-6 border-b border-slate-200">ماوەی نۆرە</th>
                <th class="py-4 px-6 border-b border-slate-200">ژمارەی نۆرە</th>
                <th class="py-4 px-6 border-b border-slate-200">کردارەکان</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-slate-100 text-slate-700">
            @forelse($schedules as $schedule)
            <tr class="hover:bg-slate-50/50 transition-colors">
                <td class="py-4 px-6 font-medium text-slate-800">{{ __('days.' . $schedule->day_of_week) ?? $schedule->day_of_week }}</td>
                <td class="py-4 px-6 text-slate-600" dir="ltr">{{ \Carbon\Carbon::parse($schedule->start_time)->format('h:i A') }}</td>
                <td class="py-4 px-6 text-slate-600" dir="ltr">{{ \Carbon\Carbon::parse($schedule->end_time)->format('h:i A') }}</td>
                @php
                    $slotLength = $schedule->slot_minutes ?: 30;
                    $spanMinutes = \Carbon\Carbon::parse($schedule->start_time)
                        ->diffInMinutes(\Carbon\Carbon::parse($schedule->end_time));
                @endphp
                <td class="py-4 px-6 text-slate-600">{{ $slotLength }} خولەک</td>
                <td class="py-4 px-6 text-slate-600">{{ intdiv($spanMinutes, $slotLength) }} نۆرە</td>
                <td class="py-4 px-6">
                    <form action="{{ route('doctor.schedules.destroy', $schedule->id) }}" method="POST" onsubmit="return confirm('دڵنیایت لە سڕینەوەی ئەم کاتە؟');">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="text-red-500 hover:text-red-700 p-2 rounded-lg hover:bg-red-50 transition-colors">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                            </svg>
                        </button>
                    </form>
                </td>
            </tr>
            @empty
            <tr>
                <td colspan="6" class="py-8 px-6 text-center text-slate-500">
                    هیچ کاتێک دیاری نەکراوە.
                </td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>

<!-- Title for Time Offs -->
<div class="mt-12 mb-6">
    <h2 class="text-xl font-bold text-slate-800">پشووەکان (دەرکەنارەکان)</h2>
    <p class="text-sm text-slate-500 mt-1">ئەگەر لە ڕۆژێکدا گەشتت هەیە یان کارێکی پێویستت هەیە، کاتەکەی لێرە داخڵ بکە تاوەکو نەخۆش نەتوانێت لەو کاتەدا نۆرەت لێ بگرێت.</p>
</div>

<!-- Add New Time Off Form -->
<form action="{{ route('doctor.time_offs.store') }}" method="POST" class="bg-white rounded-2xl shadow-sm border border-slate-200/60 p-6 mb-8 max-w-5xl">
    @csrf
    
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
        <div>
            <label for="start_datetime" class="block text-sm font-medium text-slate-700 mb-2">لە بەرواری و کاتژمێر</label>
            <input type="datetime-local" id="start_datetime" name="start_datetime" required
                class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 font-medium text-slate-700">
            @error('start_datetime') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>
        
        <div>
            <label for="end_datetime" class="block text-sm font-medium text-slate-700 mb-2">تا بەرواری و کاتژمێر</label>
            <input type="datetime-local" id="end_datetime" name="end_datetime" required
                class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 font-medium text-slate-700">
            @error('end_datetime') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>
    </div>

    <div class="mb-6">
        <label for="reason" class="block text-sm font-medium text-slate-700 mb-2">هۆکار (ئارەزوومەندانە - لەناو ئەپەکە نیشان دەدرێت)</label>
        <input type="text" id="reason" name="reason" placeholder="نموونە: کۆبوونەوە، پشووی ساڵانە..."
            class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 text-slate-700">
        @error('reason') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
    </div>

    <div class="flex justify-end">
        <button type="submit" class="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-medium transition-colors shadow-lg shadow-blue-500/30">
            زیادکردنی پشوو
        </button>
    </div>
</form>

<!-- Existing Time Offs List -->
<div class="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden max-w-5xl mb-12">
    <table class="w-full text-right text-sm">
        <thead class="bg-slate-50 text-slate-600 font-medium">
            <tr>
                <th class="py-4 px-6 border-b border-slate-200">کاتی دەستپێکردن</th>
                <th class="py-4 px-6 border-b border-slate-200">کاتی کۆتایهاتن</th>
                <th class="py-4 px-6 border-b border-slate-200">هۆکار</th>
                <th class="py-4 px-6 border-b border-slate-200">کردارەکان</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-slate-100 text-slate-700">
            @forelse($timeOffs ?? [] as $timeOff)
            <tr class="hover:bg-slate-50/50 transition-colors">
                <td class="py-4 px-6 text-slate-600" dir="ltr">{{ $timeOff->start_datetime->format('Y-m-d h:i A') }}</td>
                <td class="py-4 px-6 text-slate-600" dir="ltr">{{ $timeOff->end_datetime->format('Y-m-d h:i A') }}</td>
                <td class="py-4 px-6 text-slate-600">{{ $timeOff->reason ?? '-' }}</td>
                <td class="py-4 px-6">
                    <form action="{{ route('doctor.time_offs.destroy', $timeOff->id) }}" method="POST" onsubmit="return confirm('دڵنیایت لە سڕینەوەی ئەم پشووە؟');">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="text-red-500 hover:text-red-700 p-2 rounded-lg hover:bg-red-50 transition-colors">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                            </svg>
                        </button>
                    </form>
                </td>
            </tr>
            @empty
            <tr>
                <td colspan="4" class="py-8 px-6 text-center text-slate-500">
                    هیچ پشوویەک تۆمار نەکراوە.
                </td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>

@endsection
