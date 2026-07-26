@extends('lab.layouts.app')

@section('content')
<div class="space-y-6">
    <div class="bg-white p-6 rounded-3xl shadow-sm border border-slate-100">
        <h2 class="text-xl font-bold text-slate-800 mb-6">پرۆفایلی تاقیگە</h2>
        
        @if(session('success'))
            <div class="bg-emerald-50 text-emerald-600 p-4 rounded-xl mb-6 font-bold">
                {{ session('success') }}
            </div>
        @endif

        <form action="{{ route('lab.profile.update') }}" method="POST" class="space-y-4 max-w-2xl">
            @csrf
            @method('PUT')
            
            <div>
                <label class="block text-sm font-bold text-slate-700 mb-2">ناوی تەواو</label>
                <input type="text" name="name" value="{{ old('name', $user->name) }}" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500/20 font-medium text-slate-800">
                @error('name') <span class="text-red-500 text-sm font-bold mt-1 block">{{ $message }}</span> @enderror
            </div>
            
            <div>
                <label class="block text-sm font-bold text-slate-700 mb-2">ئیمەیڵ</label>
                <input type="email" name="email" value="{{ old('email', $user->email) }}" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500/20 font-medium text-slate-800" dir="ltr">
                @error('email') <span class="text-red-500 text-sm font-bold mt-1 block">{{ $message }}</span> @enderror
            </div>
            
            <div>
                <label class="block text-sm font-bold text-slate-700 mb-2">مۆبایل</label>
                <input type="text" name="phone" value="{{ old('phone', $user->phone) }}" class="w-full bg-slate-50 border-none rounded-xl px-4 py-3 focus:ring-2 focus:ring-indigo-500/20 font-medium text-slate-800" dir="ltr">
                @error('phone') <span class="text-red-500 text-sm font-bold mt-1 block">{{ $message }}</span> @enderror
            </div>
            
            <div class="pt-4">
                <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 px-8 rounded-xl transition-colors shadow-lg shadow-indigo-500/30">
                    نوێکردنەوەی زانیارییەکان
                </button>
            </div>
        </form>
    </div>
</div>
@endsection
