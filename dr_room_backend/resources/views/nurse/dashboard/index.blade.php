@extends('nurse.layouts.app')

@section('content')
<div class="space-y-6 lg:space-y-8 pb-10">
    
    <!-- Welcome Header -->
    <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 bg-white p-6 md:p-8 rounded-3xl shadow-sm border border-slate-100">
        <div>
            <h1 class="text-2xl md:text-3xl font-extrabold text-slate-900 mb-2">داشبۆرد</h1>
            <p class="text-slate-500 font-medium">بەخێربێیتەوە بۆ سیستەم، <span class="text-teal-600">پەرستار {{ explode(' ', $user->name)[0] }}</span></p>
        </div>
        <div class="text-sm font-medium text-slate-400 flex items-center gap-2 bg-slate-50 px-4 py-2 rounded-xl">
            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
            {{ now()->format('Y-m-d') }}
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 md:gap-6">
        <!-- Today Appointments -->
        <div class="bg-white rounded-3xl p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 hover:-translate-y-1 transition-transform duration-300 group">
            <div class="flex justify-between items-start mb-4">
                <div class="w-12 h-12 rounded-2xl bg-teal-50 text-teal-600 flex items-center justify-center group-hover:bg-teal-600 group-hover:text-white transition-colors duration-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
            </div>
            <div>
                <h3 class="text-3xl font-black text-slate-800 mb-1">{{ $todayAppointments ?? 12 }}</h3>
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
                <h3 class="text-3xl font-black text-slate-800 mb-1">{{ $completedAppointments ?? 8 }}</h3>
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
                <h3 class="text-3xl font-black text-slate-800 mb-1">{{ $pendingAppointments ?? 4 }}</h3>
                <p class="text-slate-500 text-sm font-medium">لە چاوەڕوانیدا</p>
            </div>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8">
        
        <!-- Upcoming Appointments -->
        <div class="lg:col-span-2 bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden flex flex-col">
            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <h3 class="text-lg font-bold text-slate-800">داواکارییەکانی ئەمڕۆ</h3>
                <a href="{{ route('nurse.appointments.index') }}" class="text-sm font-bold text-teal-600 hover:text-teal-700 bg-teal-50 px-4 py-2 rounded-xl transition-colors">هەمووی ببینە</a>
            </div>
            <div class="p-2 sm:p-4 flex-1">
                @if(isset($upcomingAppointments) && $upcomingAppointments->count() > 0)
                    <div class="space-y-2">
                        @foreach($upcomingAppointments->take(5) as $appointment)
                            <div class="flex items-center gap-4 p-4 hover:bg-slate-50 rounded-2xl transition-colors border border-transparent hover:border-slate-100">
                                <div class="w-16 text-center">
                                    <div class="text-lg font-black text-slate-800">{{ $appointment->appointment_date->format('h:i') }}</div>
                                    <div class="text-xs font-bold text-slate-400">{{ $appointment->appointment_date->format('A') == 'AM' ? 'ب.ن' : 'د.ن' }}</div>
                                </div>
                                <div class="w-12 h-12 rounded-full bg-gradient-to-br from-teal-100 to-emerald-100 border-2 border-white shadow-sm flex items-center justify-center flex-shrink-0 overflow-hidden">
                                    @if($appointment->patient->profile_image)
                                        <img src="{{ asset('storage/' . $appointment->patient->profile_image) }}" class="w-full h-full object-cover">
                                    @else
                                        <span class="text-teal-600 font-bold">{{ mb_substr($appointment->patient->name, 0, 1) }}</span>
                                    @endif
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h4 class="text-base font-bold text-slate-800 truncate">{{ $appointment->patient->name }}</h4>
                                    <p class="text-sm font-medium text-slate-500 truncate">{{ $appointment->service->name ?? 'پشکنینی گشتی' }}</p>
                                </div>
                                <div>
                                    <span class="inline-flex items-center justify-center px-3 py-1.5 rounded-xl text-xs font-bold whitespace-nowrap {{ $appointment->status == 'completed' ? 'bg-emerald-100 text-emerald-700' : ($appointment->status == 'pending' ? 'bg-amber-100 text-amber-700' : 'bg-teal-100 text-teal-700') }}">
                                        {{ $appointment->status == 'completed' ? 'تەواوکراو' : ($appointment->status == 'pending' ? 'چاوەڕێکراو' : 'بەڕێوەیە') }}
                                    </span>
                                </div>
                            </div>
                        @endforeach
                    </div>
                @else
                    <!-- Placeholder -->
                    <div class="space-y-2">
                        @php
                            $dummies = [
                                ['time' => '09:00', 'ampm' => 'ب.ن', 'name' => 'عەلی ئەحمەد', 'type' => 'پشکنینی خوێن', 'status' => 'completed', 'status_text' => 'تەواوکراو', 'color' => 'emerald'],
                                ['time' => '10:30', 'ampm' => 'ب.ن', 'name' => 'سارا کەریم', 'type' => 'پێدانی دەرمان', 'status' => 'upcoming', 'status_text' => 'بەڕێوەیە', 'color' => 'teal'],
                                ['time' => '11:30', 'ampm' => 'ب.ن', 'name' => 'حەسەن قادر', 'type' => 'پشکنینی شەکرە', 'status' => 'upcoming', 'status_text' => 'بەڕێوەیە', 'color' => 'teal'],
                                ['time' => '01:00', 'ampm' => 'د.ن', 'name' => 'زانا عوسمان', 'type' => 'گۆڕینی برین', 'status' => 'pending', 'status_text' => 'چاوەڕێکراو', 'color' => 'amber'],
                            ];
                        @endphp
                        @foreach($dummies as $dummy)
                            <div class="flex items-center gap-3 sm:gap-4 p-3 sm:p-4 hover:bg-slate-50 rounded-2xl transition-colors border border-transparent hover:border-slate-100">
                                <div class="w-12 sm:w-16 text-center">
                                    <div class="text-base sm:text-lg font-black text-slate-800">{{ $dummy['time'] }}</div>
                                    <div class="text-[10px] sm:text-xs font-bold text-slate-400">{{ $dummy['ampm'] }}</div>
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
                @endif
            </div>
        </div>

        <!-- Right Side: Chart -->
        <div class="flex flex-col gap-6 lg:gap-8">
            <div class="bg-white rounded-3xl shadow-sm border border-slate-100 p-6 flex-1 flex flex-col">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-lg font-bold text-slate-800">پوختەی کارکردن</h3>
                    <select class="bg-slate-50 border-none text-sm font-bold text-slate-600 py-2 px-3 rounded-xl cursor-pointer outline-none focus:ring-2 focus:ring-teal-500/20">
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
                type: 'bar',
                data: {
                    labels: ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ه'],
                    datasets: [{
                        label: 'داواکارییەکان',
                        data: [5, 8, 12, 7, 15, 10, 4],
                        backgroundColor: '#14B8A6',
                        borderRadius: 6,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { grid: { display: false }, border: { display: false }, ticks: { color: '#94A3B8', font: { family: 'Rabar', weight: 'bold' } } },
                        y: { beginAtZero: true, grid: { color: '#F1F5F9' }, border: { display: false, dash: [4, 4] }, ticks: { color: '#94A3B8', maxTicksLimit: 5, font: { weight: 'bold' } } }
                    }
                }
            });
        }
    });
</script>
@endsection
