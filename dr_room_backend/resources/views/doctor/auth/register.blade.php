@extends('doctor.layouts.app')

@section('content')
<div class="bg-white rounded-[2rem] shadow-[0_10px_40px_rgba(0,0,0,0.08)] border border-slate-100 flex flex-col lg:flex-row overflow-hidden min-h-[550px]">
    
    <!-- Form Side (Right in RTL, First in DOM) -->
    <div class="w-full lg:w-1/2 flex items-center justify-center p-8 sm:p-12 relative z-10 bg-white">
        
        <div class="w-full max-w-sm w-full my-auto animate-fade-in-up">
            <div class="mb-10 text-center lg:text-right">
                <h1 class="text-3xl font-bold text-slate-800 tracking-tight mb-3">دروستکردنی ئەکاونت</h1>
                <p class="text-slate-500 font-medium">زانیارییەکانت پڕبکەرەوە بۆ بەشداریکردن</p>
            </div>

            @if ($errors->any())
                <div class="mb-8 p-4 bg-red-50 border border-red-100 text-red-600 rounded-2xl text-sm font-medium">
                    <ul class="space-y-1">
                        @foreach ($errors->all() as $error)
                            <li class="flex items-center"><svg class="w-4 h-4 ml-2" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg> {{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <form method="POST" action="{{ route('doctor.register') }}" class="space-y-4">
                @csrf
                <div>
                    <label for="name" class="block text-sm font-bold text-slate-700 mb-1.5">ناوی تەواو</label>
                    <input type="text" id="name" name="name" value="{{ old('name') }}" required autofocus
                        class="w-full text-right px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                        placeholder="د. ئەحمەد محمد">
                </div>

                <div>
                    <label for="email" class="block text-sm font-bold text-slate-700 mb-1.5">ئیمەیڵ</label>
                    <input type="email" id="email" name="email" value="{{ old('email') }}" required dir="ltr"
                        class="w-full text-left px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                        placeholder="doctor@example.com">
                </div>

                <div>
                    <label for="specialty" class="block text-sm font-bold text-slate-700 mb-1.5">پسپۆڕی</label>
                    <input type="text" id="specialty" name="specialty" value="{{ old('specialty') }}" required
                        class="w-full text-right px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                        placeholder="بۆ نموونە: پزیشکی ددان">
                </div>

                <div>
                    <label for="password" class="block text-sm font-bold text-slate-700 mb-1.5">وشەی نهێنی</label>
                    <input type="password" id="password" name="password" required dir="ltr"
                        class="w-full text-left px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                        placeholder="••••••••">
                </div>

                <div>
                    <label for="password_confirmation" class="block text-sm font-bold text-slate-700 mb-1.5">دڵنیابوونەوەی وشەی نهێنی</label>
                    <input type="password" id="password_confirmation" name="password_confirmation" required dir="ltr"
                        class="w-full text-left px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 focus:bg-white transition-all font-medium text-slate-700 shadow-sm"
                        placeholder="••••••••">
                </div>

                <button type="submit" class="w-full py-3.5 px-4 bg-gradient-to-l from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white rounded-xl font-bold text-lg transition-all transform hover:scale-[1.02] hover:shadow-lg active:scale-95 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 mt-6">
                    دروستکردنی ئەکاونت
                </button>
            </form>

            <div class="mt-8 text-center lg:text-right">
                <p class="text-sm text-slate-500 font-medium">ئەکاونتت هەیە؟ <a href="{{ route('doctor.login') }}" class="text-blue-600 hover:text-blue-700 font-bold hover:underline transition-colors">چوونەژوورەوە</a></p>
            </div>
        </div>
    </div>

    <!-- Image Side (Left in RTL, Second in DOM) -->
    <div class="hidden lg:flex w-1/2 relative bg-slate-50 items-center justify-center p-8">
        <div class="absolute inset-0 bg-gradient-to-br from-blue-50/50 to-indigo-50/50"></div>
        <img src="{{ asset('images/doctor.png') }}" alt="Doctor Illustration" class="w-full h-full object-contain relative z-10 drop-shadow-xl hover:scale-105 transition-transform duration-700">
    </div>

</div>
@endsection
