@extends('doctor.layouts.app')

@section('content')
<div class="space-y-6 lg:space-y-8 pb-10">
    
    <!-- Welcome Header -->
    <div class="flex flex-col sm:flex-row sm:items-end justify-between gap-4 bg-white p-6 md:p-8 rounded-3xl shadow-sm border border-slate-100">
        <div>
            <h1 class="text-2xl md:text-3xl font-extrabold text-slate-900 mb-2">داشبۆرد</h1>
            <p class="text-slate-500 font-medium">بەخێربێیتەوە بۆ سیستەم، <span class="text-blue-600">دکتۆر {{ explode(' ', $user->name)[0] }}</span></p>
        </div>
        <div class="text-sm font-medium text-slate-400 flex items-center gap-2 bg-slate-50 px-4 py-2 rounded-xl">
            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
            {{ now()->format('Y-m-d') }}
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 md:gap-6">
        <!-- Today Appointments -->
        <div class="bg-white rounded-3xl p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 hover:-translate-y-1 transition-transform duration-300 group">
            <div class="flex justify-between items-start mb-4">
                <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-colors duration-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
                </div>
                <span class="inline-flex items-center gap-1 text-sm font-bold text-emerald-500 bg-emerald-50 px-2.5 py-1 rounded-lg">
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 15l7-7 7 7"/></svg>
                    ١٥٪
                </span>
            </div>
            <div>
                <h3 class="text-3xl font-black text-slate-800 mb-1">{{ $todayAppointments ?? 24 }}</h3>
                <p class="text-slate-500 text-sm font-medium">نەخۆشەکانی ئەمڕۆ</p>
            </div>
        </div>

        <!-- Completed -->
        <div class="bg-white rounded-3xl p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 hover:-translate-y-1 transition-transform duration-300 group">
            <div class="flex justify-between items-start mb-4">
                <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-500 flex items-center justify-center group-hover:bg-emerald-500 group-hover:text-white transition-colors duration-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <span class="inline-flex items-center gap-1 text-sm font-bold text-emerald-500 bg-emerald-50 px-2.5 py-1 rounded-lg">
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 15l7-7 7 7"/></svg>
                    ٨٪
                </span>
            </div>
            <div>
                <h3 class="text-3xl font-black text-slate-800 mb-1">{{ $completedAppointments ?? 18 }}</h3>
                <p class="text-slate-500 text-sm font-medium">پشکنینی تەواوکراو</p>
            </div>
        </div>

        <!-- Online Consultations -->
        <div class="bg-white rounded-3xl p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 hover:-translate-y-1 transition-transform duration-300 group">
            <div class="flex justify-between items-start mb-4">
                <div class="w-12 h-12 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center group-hover:bg-purple-600 group-hover:text-white transition-colors duration-300">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"/></svg>
                </div>
            </div>
            <div>
                <h3 class="text-3xl font-black text-slate-800 mb-1">{{ $pendingAppointments ?? 6 }}</h3>
                <p class="text-slate-500 text-sm font-medium">ڕاوێژی ئۆنلاین</p>
            </div>
        </div>

        <!-- Rating -->
        <div class="bg-white rounded-3xl p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100 hover:-translate-y-1 transition-transform duration-300 group">
            <div class="flex justify-between items-start mb-4">
                <div class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-500 flex items-center justify-center group-hover:bg-amber-500 group-hover:text-white transition-colors duration-300">
                    <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                </div>
                <div class="flex gap-0.5">
                    @for($i = 0; $i < 5; $i++)
                        <svg class="w-4 h-4 {{ $i < round($doctor->rating ?? 4.8) ? 'text-amber-400' : 'text-slate-200' }}" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>
                    @endfor
                </div>
            </div>
            <div>
                <h3 class="text-3xl font-black text-slate-800 mb-1" dir="ltr">{{ number_format($doctor->rating ?? 4.8, 1) }}</h3>
                <p class="text-slate-500 text-sm font-medium">هەڵسەنگاندنی گشتی</p>
            </div>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8">
        
        <!-- Upcoming Appointments (Takes 2 columns on large screens) -->
        <div class="lg:col-span-2 bg-white rounded-3xl shadow-sm border border-slate-100 overflow-hidden flex flex-col">
            <div class="p-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <h3 class="text-lg font-bold text-slate-800">خشتەی کارکردنی ئەمڕۆ</h3>
                <a href="{{ route('doctor.appointments.index') }}" class="text-sm font-bold text-blue-600 hover:text-blue-700 bg-blue-50 px-4 py-2 rounded-xl transition-colors">هەمووی ببینە</a>
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
                                <div class="w-12 h-12 rounded-full bg-gradient-to-br from-indigo-100 to-purple-100 border-2 border-white shadow-sm flex items-center justify-center flex-shrink-0 overflow-hidden">
                                    @if($appointment->patient->profile_image)
                                        <img src="{{ asset('storage/' . $appointment->patient->profile_image) }}" class="w-full h-full object-cover">
                                    @else
                                        <span class="text-indigo-600 font-bold">{{ mb_substr($appointment->patient->name, 0, 1) }}</span>
                                    @endif
                                </div>
                                <div class="flex-1 min-w-0">
                                    <h4 class="text-base font-bold text-slate-800 truncate">{{ $appointment->patient->name }}</h4>
                                    <p class="text-sm font-medium text-slate-500 truncate">{{ $appointment->type == 'online' ? 'ڕاوێژی ئۆنلاین' : 'سەردانی نۆڕینگە' }}</p>
                                </div>
                                <div>
                                    <span class="inline-flex items-center justify-center px-3 py-1.5 rounded-xl text-xs font-bold whitespace-nowrap {{ $appointment->status == 'completed' ? 'bg-emerald-100 text-emerald-700' : ($appointment->status == 'pending' ? 'bg-amber-100 text-amber-700' : 'bg-blue-100 text-blue-700') }}">
                                        {{ $appointment->status == 'completed' ? 'تەواوکراو' : ($appointment->status == 'pending' ? 'چاوەڕێکراو' : 'بەڕێوەیە') }}
                                    </span>
                                </div>
                            </div>
                        @endforeach
                    </div>
                @else
                    <!-- Placeholder Data for UI presentation if no data -->
                    <div class="space-y-2">
                        @php
                            $dummies = [
                                ['time' => '09:00', 'ampm' => 'ب.ن', 'name' => 'عەلی ئەحمەد', 'type' => 'سەردانی نۆڕینگە', 'status' => 'completed', 'status_text' => 'تەواوکراو', 'color' => 'emerald'],
                                ['time' => '10:30', 'ampm' => 'ب.ن', 'name' => 'سارا کەریم', 'type' => 'بەدواداچوون', 'status' => 'upcoming', 'status_text' => 'بەڕێوەیە', 'color' => 'blue'],
                                ['time' => '11:30', 'ampm' => 'ب.ن', 'name' => 'حەسەن قادر', 'type' => 'ڕاوێژی ئۆنلاین', 'status' => 'upcoming', 'status_text' => 'بەڕێوەیە', 'color' => 'blue'],
                                ['time' => '01:00', 'ampm' => 'د.ن', 'name' => 'زانا عوسمان', 'type' => 'سەردانی نۆڕینگە', 'status' => 'pending', 'status_text' => 'چاوەڕێکراو', 'color' => 'amber'],
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

        <!-- Right Side: Chart & Recent Patients -->
        <div class="flex flex-col gap-6 lg:gap-8">
            
            <!-- Earnings Chart -->
            <div class="bg-white rounded-3xl shadow-sm border border-slate-100 p-6">
                <div class="flex justify-between items-center mb-6">
                    <h3 class="text-lg font-bold text-slate-800">پوختەی سەردانەکان</h3>
                    <select class="bg-slate-50 border-none text-sm font-bold text-slate-600 py-2 px-3 rounded-xl cursor-pointer outline-none focus:ring-2 focus:ring-blue-500/20">
                        <option>ئەم هەفتەیە</option>
                        <option>ئەم مانگە</option>
                    </select>
                </div>
                <div class="relative h-48 w-full">
                    <canvas id="appointmentsChart"></canvas>
                </div>
            </div>

            <!-- Recent Patients -->
            <div class="bg-white rounded-3xl shadow-sm border border-slate-100 flex-1 flex flex-col">
                <div class="p-6 pb-2">
                    <h3 class="text-lg font-bold text-slate-800">دوایین نەخۆشەکان</h3>
                </div>
                <div class="p-4 flex-1">
                    <div class="space-y-1">
                        @php
                            $recentDummies = [
                                ['name' => 'عەلی ئەحمەد', 'desc' => 'نێر، ٣٨ ساڵ', 'date' => 'ئەمڕۆ'],
                                ['name' => 'سارا کەریم', 'desc' => 'مێ، ٣٥ ساڵ', 'date' => 'ئەمڕۆ'],
                                ['name' => 'حەسەن قادر', 'desc' => 'نێر، ٤٢ ساڵ', 'date' => 'دوێنێ'],
                            ];
                        @endphp
                        @foreach($recentDummies as $p)
                            <div class="flex items-center gap-3 p-3 hover:bg-slate-50 rounded-2xl transition-colors">
                                <div class="w-10 h-10 rounded-full bg-blue-50 text-blue-600 flex items-center justify-center font-bold">
                                    {{ mb_substr($p['name'], 0, 1) }}
                                </div>
                                <div class="flex-1">
                                    <div class="text-sm font-bold text-slate-800">{{ $p['name'] }}</div>
                                    <div class="text-xs font-medium text-slate-500">{{ $p['desc'] }}</div>
                                </div>
                                <div class="text-xs font-bold text-slate-400 bg-slate-100 px-2.5 py-1 rounded-lg">{{ $p['date'] }}</div>
                            </div>
                        @endforeach
                    </div>
                </div>
                <div class="p-4 pt-0">
                    <a href="{{ route('doctor.patients.index') }}" class="block w-full text-center py-3 rounded-xl bg-slate-50 hover:bg-slate-100 text-slate-600 font-bold transition-colors text-sm">
                        بینینی هەموو نەخۆشەکان
                    </a>
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
                type: 'line',
                data: {
                    labels: ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ه'],
                    datasets: [{
                        label: 'سەردانەکان',
                        data: [12, 19, 15, 25, 22, 30, 28],
                        borderColor: '#3B82F6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#ffffff',
                        pointBorderColor: '#3B82F6',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        x: { grid: { display: false }, border: { display: false }, ticks: { color: '#94A3B8', font: { family: 'Rabar', weight: 'bold' } } },
                        y: { beginAtZero: true, grid: { color: '#F1F5F9' }, border: { display: false, dash: [4, 4] }, ticks: { color: '#94A3B8', maxTicksLimit: 5, font: { weight: 'bold' } } }
                    },
                    interaction: { intersect: false, mode: 'index' }
                }
            });
        }
    });
</script>
@endsection
