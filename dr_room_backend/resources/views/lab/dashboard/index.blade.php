@extends('lab.layouts.app')

@section('content')
<div class="space-y-6 lg:space-y-8 pb-10">
    
    <!-- Welcome Header -->
    <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 bg-white p-6 md:p-8 rounded-3xl shadow-sm border border-slate-100">
        <div>
            <h1 class="text-2xl md:text-3xl font-extrabold text-slate-900 mb-2">داشبۆردی تاقیگە</h1>
            <p class="text-slate-500 font-medium">بەخێربێیتەوە بۆ سیستەم، <span class="text-indigo-600">{{ explode(' ', $user->name)[0] }}</span></p>
        </div>
        <div class="text-sm font-medium text-slate-400 flex items-center gap-2 bg-slate-50 px-4 py-2 rounded-xl">
            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
            {{ now()->format('Y-m-d') }}
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
        <!-- Today Requests -->
        <div class="bg-white rounded-3xl p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 hover:-translate-y-1 transition-transform duration-300 group">
            <div class="flex justify-between items-start mb-4">
                <div class="w-12 h-12 rounded-2xl bg-indigo-50 text-indigo-600 flex items-center justify-center group-hover:bg-indigo-600 group-hover:text-white transition-colors duration-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/></svg>
                </div>
            </div>
            <div>
                <h3 class="text-3xl font-black text-slate-800 mb-1">28</h3>
                <p class="text-slate-500 text-sm font-medium">داواکارییەکانی ئەمڕۆ</p>
            </div>
        </div>

        <!-- Completed -->
        <div class="bg-white rounded-3xl p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 hover:-translate-y-1 transition-transform duration-300 group">
            <div class="flex justify-between items-start mb-4">
                <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-500 flex items-center justify-center group-hover:bg-emerald-500 group-hover:text-white transition-colors duration-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
            </div>
            <div>
                <h3 class="text-3xl font-black text-slate-800 mb-1">15</h3>
                <p class="text-slate-500 text-sm font-medium">پشکنینی تەواوکراو</p>
            </div>
        </div>

        <!-- Pending -->
        <div class="bg-white rounded-3xl p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 hover:-translate-y-1 transition-transform duration-300 group">
            <div class="flex justify-between items-start mb-4">
                <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-500 flex items-center justify-center group-hover:bg-amber-500 group-hover:text-white transition-colors duration-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
            </div>
            <div>
                <h3 class="text-3xl font-black text-slate-800 mb-1">13</h3>
                <p class="text-slate-500 text-sm font-medium">لە چاوەڕوانیدا</p>
            </div>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8">
        
        <!-- Upcoming Requests -->
        <div class="lg:col-span-2 bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden flex flex-col">
            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <h3 class="text-lg font-bold text-slate-800">داواکارییە نوێیەکان</h3>
                <a href="{{ route('lab.patients.index') }}" class="text-sm font-bold text-indigo-600 hover:text-indigo-700 bg-indigo-50 px-4 py-2 rounded-xl transition-colors">هەمووی ببینە</a>
            </div>
            <div class="p-2 sm:p-4 flex-1">
                <div class="space-y-2">
                    @php
                        $dummies = [
                            ['id' => '#L-1024', 'name' => 'عەلی ئەحمەد', 'type' => 'پشکنینی خوێنی گشتی (CBC)', 'status_text' => 'نوێ', 'color' => 'indigo'],
                            ['id' => '#L-1025', 'name' => 'سارا کەریم', 'type' => 'پشکنینی شەکرە (FBS)', 'status_text' => 'لە کارکردندایە', 'color' => 'amber'],
                            ['id' => '#L-1026', 'name' => 'حەسەن قادر', 'type' => 'پشکنینی ڤیتامین D', 'status_text' => 'تەواوکراو', 'color' => 'emerald'],
                        ];
                    @endphp
                    @foreach($dummies as $dummy)
                        <div class="flex items-center gap-3 sm:gap-4 p-3 sm:p-4 hover:bg-slate-50 rounded-2xl transition-colors border border-transparent hover:border-slate-100">
                            <div class="w-16 text-center">
                                <div class="text-sm sm:text-base font-black text-slate-800">{{ $dummy['id'] }}</div>
                            </div>
                            <div class="w-10 h-10 sm:w-12 sm:h-12 rounded-full bg-slate-100 flex items-center justify-center flex-shrink-0 text-slate-500 font-bold text-sm sm:text-base">
                                {{ mb_substr($dummy['name'], 0, 1) }}
                            </div>
                            <div class="flex-1 min-w-0">
                                <h4 class="text-sm sm:text-base font-bold text-slate-800 truncate">{{ $dummy['name'] }}</h4>
                                <p class="text-xs sm:text-sm font-medium text-slate-500 truncate">{{ $dummy['type'] }}</p>
                            </div>
                            <div>
                                <span class="inline-flex items-center justify-center px-2.5 sm:px-3 py-1 sm:py-1.5 rounded-xl text-[10px] sm:text-xs font-bold bg-{{ $dummy['color'] }}-100 text-{{ $dummy['color'] }}-700 whitespace-nowrap">
                                    {{ $dummy['status_text'] }}
                                </span>
                            </div>
                        </div>
                    @endforeach
                </div>
            </div>
        </div>

        <!-- Right Side: Chart -->
        <div class="flex flex-col gap-6 lg:gap-8">
            <div class="bg-white rounded-3xl shadow-sm border border-slate-100 p-6 flex-1 flex flex-col">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-lg font-bold text-slate-800">ئاماری پشکنینەکان</h3>
                    <select class="bg-slate-50 border-none text-sm font-bold text-slate-600 py-2 px-3 rounded-xl cursor-pointer outline-none focus:ring-2 focus:ring-indigo-500/20">
                        <option>ئەم هەفتەیە</option>
                        <option>ئەم مانگە</option>
                    </select>
                </div>
                <div class="relative flex-1 w-full min-h-[250px]">
                    <canvas id="appointmentsChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('appointmentsChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['خوێن', 'شەکرە', 'ڤیتامینات', 'پشکنینی تر'],
                    datasets: [{
                        data: [45, 25, 20, 10],
                        backgroundColor: ['#4F46E5', '#10B981', '#F59E0B', '#64748B'],
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { 
                        legend: { position: 'bottom', labels: { font: { family: 'Rabar', weight: 'bold' }, padding: 20 } }
                    },
                    cutout: '75%'
                }
            });
        }
    });
</script>
@endsection
