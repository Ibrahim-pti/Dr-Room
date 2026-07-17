@extends('doctor.layouts.app')

@section('header_title', 'داشبۆرد')

@section('content')
<div class="space-y-8 animate-fade-in-up">
    <!-- Welcome Banner (Glassmorphic) -->
    <div class="relative overflow-hidden bg-gradient-to-r from-blue-600 to-indigo-700 rounded-[2rem] p-8 sm:p-10 text-white shadow-xl shadow-blue-500/20">
        <!-- Abstract Background Shapes -->
        <div class="absolute top-0 left-0 -ml-20 -mt-20 w-64 h-64 rounded-full bg-white/10 blur-3xl"></div>
        <div class="absolute bottom-0 left-40 -mb-20 w-48 h-48 rounded-full bg-indigo-400/20 blur-2xl"></div>
        
        <div class="relative z-10 flex flex-col md:flex-row items-center justify-between">
            <div class="mb-6 md:mb-0">
                <span class="inline-block py-1 px-3 rounded-full bg-white/20 backdrop-blur-md border border-white/30 text-xs font-semibold tracking-wider uppercase mb-4 shadow-sm">
                    {{ $doctor->specialty ?? 'پزیشکی گشتی' }}
                </span>
                <h2 class="text-3xl md:text-4xl font-bold mb-2 tracking-tight">بەخێربێیتەوە دکتۆر {{ explode(' ', $user->name)[0] }}!</h2>
                <p class="text-blue-100 text-lg max-w-lg font-light">ئەمڕۆ تۆ خاوەنی <strong class="font-semibold text-white">{{ $todayAppointments ?? 0 }}</strong> چاوپێکەوتنیت. ڕۆژێکی باش و سەرکەوتوو!</p>
            </div>
            
            <div class="flex space-x-3 space-x-reverse">
                <a href="#" class="bg-white text-blue-600 hover:bg-blue-50 px-5 py-2.5 rounded-xl font-medium transition-colors shadow-sm block text-center">
                    خشتەی کارەکان
                </a>
            </div>
        </div>
    </div>

    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Upcoming Appointments -->
        <div class="bg-white rounded-2xl p-6 shadow-[0_4px_20px_rgba(0,0,0,0.03)] border border-slate-100 flex items-center group hover:-translate-y-1 transition-all duration-300">
            <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-blue-100 to-blue-50 flex items-center justify-center text-blue-600 ml-5 group-hover:scale-110 transition-transform duration-300 shadow-inner">
                <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
            </div>
            <div>
                <p class="text-slate-500 text-sm font-medium mb-1">چاوپێکەوتنەکانی ئەمڕۆ</p>
                <div class="flex items-baseline space-x-2 space-x-reverse">
                    <p class="text-3xl font-bold text-slate-800">{{ $todayAppointments ?? 0 }}</p>
                    <span class="text-xs font-medium text-emerald-500 bg-emerald-50 px-2 py-0.5 rounded-full">لەسەر کات</span>
                </div>
            </div>
        </div>

        <!-- Total Patients -->
        <div class="bg-white rounded-2xl p-6 shadow-[0_4px_20px_rgba(0,0,0,0.03)] border border-slate-100 flex items-center group hover:-translate-y-1 transition-all duration-300">
            <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-indigo-100 to-indigo-50 flex items-center justify-center text-indigo-600 ml-5 group-hover:scale-110 transition-transform duration-300 shadow-inner">
                <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
            </div>
            <div>
                <p class="text-slate-500 text-sm font-medium mb-1">کۆی نەخۆشەکان</p>
                <p class="text-3xl font-bold text-slate-800">{{ $totalPatients ?? 0 }}</p>
            </div>
        </div>

        <!-- Rating -->
        <div class="bg-white rounded-2xl p-6 shadow-[0_4px_20px_rgba(0,0,0,0.03)] border border-slate-100 flex items-center group hover:-translate-y-1 transition-all duration-300">
            <div class="w-14 h-14 rounded-2xl bg-gradient-to-br from-amber-100 to-amber-50 flex items-center justify-center text-amber-500 ml-5 group-hover:scale-110 transition-transform duration-300 shadow-inner">
                <svg class="w-7 h-7" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
            </div>
            <div>
                <p class="text-slate-500 text-sm font-medium mb-1">هەڵسەنگاندنی گشتی</p>
                <div class="flex items-center space-x-2 space-x-reverse">
                    <p class="text-3xl font-bold text-slate-800">{{ number_format($doctor->rating ?? 0, 1) }}</p>
                    <span class="text-sm text-slate-400">/ 5.0 ({{ $doctor->total_reviews ?? 0 }})</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Appointments Section -->
    <div class="bg-white rounded-2xl shadow-[0_4px_24px_rgba(0,0,0,0.02)] border border-slate-100 overflow-hidden">
        <div class="px-8 py-6 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
            <div>
                <h3 class="text-lg font-bold text-slate-800">چاوپێکەوتنەکانی داهاتوو</h3>
                <p class="text-sm text-slate-500">ئەو نەخۆشانەی چاوەڕێی ڕاوێژن</p>
            </div>
            <a href="#" class="text-sm font-semibold text-blue-600 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 px-4 py-2 rounded-lg transition-colors">
                بینینی هەموو
            </a>
        </div>
        
        @if(isset($upcomingAppointments) && $upcomingAppointments->count() > 0)
            <div class="divide-y divide-slate-100">
                @foreach($upcomingAppointments as $appointment)
                    <div class="p-6 hover:bg-slate-50 transition-colors flex items-center justify-between">
                        <div class="flex items-center">
                            <div class="w-12 h-12 rounded-full bg-slate-200 overflow-hidden ml-4">
                                @if($appointment->patient->profile_image)
                                    <img src="{{ asset('storage/' . $appointment->patient->profile_image) }}" alt="Patient" class="w-full h-full object-cover">
                                @else
                                    <div class="w-full h-full flex items-center justify-center text-slate-500 font-bold bg-blue-100 text-blue-600">
                                        {{ substr($appointment->patient->name, 0, 1) }}
                                    </div>
                                @endif
                            </div>
                            <div>
                                <h4 class="text-md font-bold text-slate-800">{{ $appointment->patient->name }}</h4>
                                <p class="text-sm text-slate-500">{{ $appointment->appointment_date->format('Y-m-d h:i A') }} - {{ $appointment->type == 'online' ? 'ئۆنلاین' : 'لە نۆڕینگە' }}</p>
                            </div>
                        </div>
                        <div>
                            <span class="px-3 py-1 text-xs font-medium rounded-full {{ $appointment->status == 'pending' ? 'bg-amber-100 text-amber-700' : 'bg-emerald-100 text-emerald-700' }}">
                                {{ $appointment->status == 'pending' ? 'چاوەڕێ دەکات' : 'پەسەندکراوە' }}
                            </span>
                        </div>
                    </div>
                @endforeach
            </div>
        @else
            <div class="p-8 text-center text-slate-500 py-16">
                <div class="w-20 h-20 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-10 h-10 text-slate-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <h4 class="text-lg font-medium text-slate-700 mb-1">هیچ چاوپێکەوتنێک نییە</h4>
                <p class="text-sm max-w-sm mx-auto">کاتێک نەخۆشەکان چاوپێکەوتنیان لەگەڵت تۆمارکرد، لێرە دەردەکەون.</p>
            </div>
        @endif
    </div>
</div>

<style>
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .animate-fade-in-up {
        animation: fadeInUp 0.5s ease-out forwards;
    }
</style>
@endsection
