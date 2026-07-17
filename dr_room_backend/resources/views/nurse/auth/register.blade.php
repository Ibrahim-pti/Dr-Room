@extends('nurse.layouts.app')

@section('content')
<div class="bg-white/80 backdrop-blur-2xl rounded-[2.5rem] shadow-[0_20px_60px_-15px_rgba(0,0,0,0.1)] border border-white flex flex-col overflow-hidden max-w-lg mx-auto relative">
    
    <!-- Background Decor -->
    <div class="absolute top-0 right-0 w-64 h-64 bg-blue-500/10 rounded-full blur-3xl -mr-20 -mt-20 pointer-events-none"></div>
    <div class="absolute bottom-0 left-0 w-64 h-64 bg-indigo-500/10 rounded-full blur-3xl -ml-20 -mb-20 pointer-events-none"></div>
    
    <!-- Form Side -->
    <div class="w-full flex items-center justify-center p-8 sm:p-12 relative z-10">
        
        <div class="w-full max-w-sm my-auto animate-fade-in-up">
            <div class="mb-8 text-center">
                <div class="mx-auto flex items-center justify-center w-16 h-16 rounded-full bg-slate-50 border-4 border-white shadow-lg shadow-blue-500/10 mb-4 transform hover:scale-105 transition-transform duration-300 overflow-hidden relative">
                    <img src="{{ asset('images/nurse.png') }}" alt="Nurse Icon" class="w-full h-full object-contain">
                </div>
                <h1 class="text-2xl font-extrabold text-slate-800 tracking-tight mb-2">دروستکردنی ئەکاونت</h1>
                <p class="text-slate-500 font-medium text-sm">زانیارییەکانت پڕبکەرەوە بۆ بەشداریکردن</p>
            </div>

            @if ($errors->any())
                <div class="mb-6 p-4 bg-red-50/80 backdrop-blur-sm border border-red-100 text-red-600 rounded-2xl text-sm font-medium shadow-sm">
                    <ul class="space-y-1">
                        @foreach ($errors->all() as $error)
                            <li class="flex items-center">
                                <svg class="w-4 h-4 ml-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg> 
                                <span>{{ $error }}</span>
                            </li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <form method="POST" action="{{ route('nurse.register') }}" class="space-y-4">
                @csrf
                <div>
                    <label for="name" class="block text-sm font-bold text-slate-700 mb-2">ناوی تەواو</label>
                    <div class="relative group">
                        <svg class="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 group-focus-within:text-blue-500 transition-colors pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                        <input type="text" id="name" name="name" value="{{ old('name') }}" required autofocus
                            class="w-full text-right pr-11 pl-4 py-3 bg-slate-50/80 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                            placeholder="پ. سارا محمد">
                    </div>
                </div>

                <div>
                    <label for="email" class="block text-sm font-bold text-slate-700 mb-2">ئیمەیڵ</label>
                    <div class="relative group">
                        <svg class="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 group-focus-within:text-blue-500 transition-colors pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"></path></svg>
                        <input type="email" id="email" name="email" value="{{ old('email') }}" required dir="ltr"
                            class="w-full text-right pr-11 pl-4 py-3 bg-slate-50/80 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                            placeholder="nurse@example.com">
                    </div>
                </div>

                <div>
                    <label for="specialty" class="block text-sm font-bold text-slate-700 mb-2">پسپۆڕی</label>
                    <div class="relative group">
                        <svg class="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 group-focus-within:text-blue-500 transition-colors pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"></path></svg>
                        <input type="text" id="specialty" name="specialty" value="{{ old('specialty') }}" required
                            class="w-full text-right pr-11 pl-4 py-3 bg-slate-50/80 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                            placeholder="بۆ نموونە: پەرستاری گشتی">
                    </div>
                </div>

                <div>
                    <label for="password" class="block text-sm font-bold text-slate-700 mb-2">وشەی نهێنی</label>
                    <div class="relative group">
                        <svg class="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 group-focus-within:text-blue-500 transition-colors pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                        <input type="password" id="password" name="password" required dir="ltr"
                            class="w-full text-right pr-11 pl-4 py-3 bg-slate-50/80 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                            placeholder="••••••••">
                    </div>
                </div>

                <div>
                    <label for="password_confirmation" class="block text-sm font-bold text-slate-700 mb-2">دڵنیابوونەوەی وشەی نهێنی</label>
                    <div class="relative group">
                        <svg class="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400 group-focus-within:text-blue-500 transition-colors pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path></svg>
                        <input type="password" id="password_confirmation" name="password_confirmation" required dir="ltr"
                            class="w-full text-right pr-11 pl-4 py-3 bg-slate-50/80 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                            placeholder="••••••••">
                    </div>
                </div>

                <button type="submit" class="w-full py-4 px-4 bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white rounded-2xl font-bold text-lg transition-all duration-300 transform hover:-translate-y-1 hover:shadow-[0_10px_20px_-10px_rgba(79,70,229,0.5)] active:scale-[0.98] focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 mt-6 flex justify-center items-center gap-2 relative overflow-hidden group">
                    <span class="absolute w-0 h-0 transition-all duration-500 ease-out bg-white rounded-full group-hover:w-56 group-hover:h-56 opacity-10"></span>
                    <span class="relative">دروستکردنی ئەکاونت</span>
                    <svg class="w-5 h-5 relative rotate-180 group-hover:-translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                </button>
            </form>

            <div class="mt-8 text-center relative">
                <div class="absolute inset-0 flex items-center pointer-events-none">
                    <div class="w-full border-t border-slate-200"></div>
                </div>
                <div class="relative flex justify-center text-sm">
                    <span class="px-4 bg-white/80 text-slate-500 font-medium">
                        ئەکاونتت هەیە؟ <a href="{{ route('nurse.login') }}" class="text-blue-600 hover:text-blue-700 font-bold hover:underline transition-colors decoration-2 underline-offset-4">چوونەژوورەوە</a>
                    </span>
                </div>
            </div>
            
        </div>
    </div>

</div>
@endsection
