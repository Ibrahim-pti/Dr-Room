@extends($layout)

@section('content')
<div class="space-y-6 lg:space-y-8 pb-10 fade-in">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 bg-white p-6 rounded-3xl shadow-sm border border-slate-100/60 relative overflow-hidden">
        <!-- Decorative subtle background element -->
        <div class="absolute -left-10 -top-10 w-40 h-40 bg-gradient-to-br from-slate-100 to-transparent rounded-full opacity-50 pointer-events-none"></div>
        
        <div class="relative z-10">
            <h1 class="text-2xl md:text-3xl font-extrabold text-slate-800 tracking-tight">{{ $title ?? 'بەش' }}</h1>
            <p class="text-sm font-medium text-slate-500 mt-1.5 flex items-center gap-1.5">
                <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                بەڕێوەبردن و بینینی زانیارییەکانی تایبەت بە {{ $title ?? 'ئەم بەشە' }}
            </p>
        </div>
        
        <div class="flex items-center gap-3 relative z-10">
            <button class="inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-white border-2 border-slate-100 text-slate-600 hover:border-slate-200 hover:bg-slate-50 font-bold text-sm transition-all shadow-sm focus:ring-4 focus:ring-slate-100">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"/></svg>
                پاڵاوتن
            </button>
            <button class="inline-flex items-center justify-center gap-2 px-5 py-2.5 rounded-xl bg-gradient-to-l from-slate-800 to-slate-700 text-white hover:from-slate-700 hover:to-slate-600 font-bold text-sm transition-all shadow-lg shadow-slate-900/10 hover:shadow-xl hover:shadow-slate-900/20 transform hover:-translate-y-0.5 focus:ring-4 focus:ring-slate-200">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                زیادکردنی نوێ
            </button>
        </div>
    </div>

    <!-- Stats summary (Dynamic appearance) -->
    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
        @php
            $colors = ['blue', 'indigo', 'emerald'];
            $stats = [
                ['label' => 'کۆی گشتی', 'val' => '٢٤٥', 'icon' => 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z'],
                ['label' => 'نوێ', 'val' => '١٢', 'icon' => 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z'],
                ['label' => 'تەواوکراو', 'val' => '١٨٤', 'icon' => 'M5 13l4 4L19 7']
            ];
        @endphp
        @foreach($stats as $k => $stat)
        <div class="bg-white p-5 rounded-2xl shadow-[0_2px_15px_-3px_rgba(0,0,0,0.03)] border border-slate-100 flex items-center justify-between hover:border-{{$colors[$k]}}-100 transition-colors group cursor-pointer">
            <div>
                <p class="text-sm font-bold text-slate-500 mb-1 group-hover:text-{{$colors[$k]}}-600 transition-colors">{{ $stat['label'] }}</p>
                <p class="text-2xl font-black text-slate-800" dir="ltr">{{ $stat['val'] }}</p>
            </div>
            <div class="w-12 h-12 rounded-xl bg-slate-50 text-slate-400 flex items-center justify-center group-hover:bg-{{$colors[$k]}}-50 group-hover:text-{{$colors[$k]}}-500 transition-all">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="{{ $stat['icon'] }}"/></svg>
            </div>
        </div>
        @endforeach
    </div>

    <!-- Search & Filters Container -->
    <div class="bg-white p-2 rounded-2xl shadow-[0_2px_15px_-3px_rgba(0,0,0,0.03)] border border-slate-100 flex flex-col sm:flex-row gap-2">
        <div class="relative flex-1">
            <div class="absolute inset-y-0 right-0 pr-4 flex items-center pointer-events-none">
                <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
            </div>
            <input type="text" class="block w-full pr-11 pl-4 py-3 border-none bg-transparent text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-0 sm:text-sm font-medium transition-all" placeholder="گەڕان بەدوای زانیارییەکان...">
        </div>
        <div class="h-px sm:h-auto sm:w-px bg-slate-100 mx-2"></div>
        <div class="flex items-center">
            <select class="block w-full sm:w-auto py-3 px-4 border-none bg-transparent focus:outline-none focus:ring-0 sm:text-sm text-slate-600 font-bold cursor-pointer pr-8 bg-no-repeat appearance-none" style="background-image: url('data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' fill=\'none\' viewBox=\'0 0 24 24\' stroke=\'%2364748B\'><path stroke-linecap=\'round\' stroke-linejoin=\'round\' stroke-width=\'2\' d=\'M19 9l-7 7-7-7\'/></svg>'); background-position: left 0.5rem center; background-size: 1.2em;">
                <option>هەموو جۆرەکان</option>
                <option>نوێترین</option>
                <option>کۆنترین</option>
            </select>
        </div>
    </div>

    <!-- Data Table -->
    <div class="bg-white rounded-3xl shadow-[0_2px_15px_-3px_rgba(0,0,0,0.03)] border border-slate-100 overflow-hidden">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-slate-100">
                <thead class="bg-slate-50/80">
                    <tr>
                        <th scope="col" class="px-6 py-4 text-right text-xs font-black text-slate-400 uppercase tracking-wider w-16">
                            <input type="checkbox" class="rounded border-slate-300 text-slate-800 focus:ring-slate-800 cursor-pointer">
                        </th>
                        <th scope="col" class="px-6 py-4 text-right text-xs font-black text-slate-500 uppercase tracking-wider">زانیاری سەرەکی</th>
                        <th scope="col" class="px-6 py-4 text-right text-xs font-black text-slate-500 uppercase tracking-wider">بەروار</th>
                        <th scope="col" class="px-6 py-4 text-right text-xs font-black text-slate-500 uppercase tracking-wider">دۆخ</th>
                        <th scope="col" class="px-6 py-4 text-left text-xs font-black text-slate-500 uppercase tracking-wider">کردارەکان</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-slate-50">
                    @php
                        $names = ['زانیاری نموونەیی ١', 'فایلی ژمارە ٢', 'داتای نوێی سیستەم', 'تۆماری تایبەت ٤', 'زانیاری گشتی ٥'];
                        $statuses = [
                            ['text' => 'تەواوکراو', 'color' => 'emerald'],
                            ['text' => 'لە چاوەڕوانیدا', 'color' => 'amber'],
                            ['text' => 'بەڕێوەیە', 'color' => 'blue'],
                            ['text' => 'تەواوکراو', 'color' => 'emerald'],
                            ['text' => 'هەڵوەشاوە', 'color' => 'red']
                        ];
                    @endphp
                    @foreach($names as $index => $name)
                    <tr class="hover:bg-slate-50/50 transition-colors group">
                        <td class="px-6 py-4 whitespace-nowrap">
                            <input type="checkbox" class="rounded border-slate-300 text-slate-800 focus:ring-slate-800 cursor-pointer">
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center gap-4">
                                <div class="flex-shrink-0 h-11 w-11 rounded-2xl bg-gradient-to-br from-slate-100 to-slate-50 border border-slate-200 flex items-center justify-center text-slate-600 font-black shadow-sm group-hover:scale-105 transition-transform">
                                    {{ mb_substr($name, 0, 1) }}
                                </div>
                                <div>
                                    <div class="text-sm font-extrabold text-slate-800">{{ $name }}</div>
                                    <div class="text-xs font-medium text-slate-400 mt-0.5">پێناسەی #ID-00{{ $index + 1 }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-500 font-bold">
                            {{ now()->subDays($index)->format('Y-m-d') }}
                            <div class="text-xs font-medium text-slate-400 font-sans mt-0.5">
                                {{ now()->subHours($index * 2)->format('H:i') }}
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold bg-{{ $statuses[$index]['color'] }}-50 text-{{ $statuses[$index]['color'] }}-600 border border-{{ $statuses[$index]['color'] }}-100">
                                <span class="w-1.5 h-1.5 rounded-full bg-{{ $statuses[$index]['color'] }}-500"></span>
                                {{ $statuses[$index]['text'] }}
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-left text-sm font-medium">
                            <div class="flex items-center justify-end gap-1 opacity-60 group-hover:opacity-100 transition-opacity">
                                <button class="text-slate-400 hover:text-blue-600 p-2 rounded-xl hover:bg-blue-50 transition-all" title="بینین">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                </button>
                                <button class="text-slate-400 hover:text-emerald-600 p-2 rounded-xl hover:bg-emerald-50 transition-all" title="دەستکاری">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                </button>
                                <button class="text-slate-400 hover:text-red-600 p-2 rounded-xl hover:bg-red-50 transition-all" title="سڕینەوە">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                </button>
                            </div>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
        
        <!-- Pagination -->
        <div class="bg-white px-6 py-4 border-t border-slate-100 flex flex-col sm:flex-row items-center justify-between gap-4">
            <div class="text-sm text-slate-500 font-medium">
                پیشاندانی <span class="font-bold text-slate-700">١</span> بۆ <span class="font-bold text-slate-700">٥</span> لە <span class="font-bold text-slate-700">٢٤</span> ئەنجام
            </div>
            <div class="flex items-center gap-2">
                <button class="inline-flex items-center justify-center w-10 h-10 rounded-xl border-2 border-slate-100 bg-white text-slate-500 hover:bg-slate-50 hover:text-slate-800 transition-colors disabled:opacity-50" disabled>
                    <svg class="h-5 w-5 rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                </button>
                <div class="flex items-center gap-1">
                    <button class="w-10 h-10 rounded-xl bg-slate-800 text-white font-bold text-sm shadow-md">١</button>
                    <button class="w-10 h-10 rounded-xl bg-transparent text-slate-600 font-bold text-sm hover:bg-slate-100 transition-colors">٢</button>
                    <button class="w-10 h-10 rounded-xl bg-transparent text-slate-600 font-bold text-sm hover:bg-slate-100 transition-colors">٣</button>
                </div>
                <button class="inline-flex items-center justify-center w-10 h-10 rounded-xl border-2 border-slate-100 bg-white text-slate-500 hover:bg-slate-50 hover:text-slate-800 transition-colors">
                    <svg class="h-5 w-5 rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    .fade-in { animation: fadeIn 0.4s ease-out forwards; }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
</style>
@endsection
