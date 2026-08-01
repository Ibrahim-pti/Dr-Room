@extends('doctor.layouts.app')
@section('header_title', 'خزمەتگوزارییەکان')

@section('content')
<div class="mb-6">
    <h2 class="text-xl font-bold text-slate-800">جۆرەکانی سەردان و نەخۆشییەکان</h2>
    <p class="text-sm text-slate-500 mt-1">لێرە دەتوانیت ئەو خزمەتگوزاریانە زیاد بکەیت کە پێشکەشی دەکەیت لەگەڵ نرخەکانیان.</p>
</div>

@if(session('success'))
    <div class="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 rounded-xl">
        {{ session('success') }}
    </div>
@endif

<!-- Add New Service Form -->
<form action="{{ route('doctor.services.store') }}" method="POST" class="bg-white rounded-2xl shadow-sm border border-slate-200/60 p-6 mb-8 max-w-3xl">
    @csrf
    
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
        <div>
            <label for="name_ckb" class="block text-sm font-medium text-slate-700 mb-2">ناوی خزمەتگوزاری (کوردی)</label>
            <div class="flex gap-2">
                <input type="text" id="name_ckb" name="name_ckb" required
                    class="w-full px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium text-slate-700">
                <button type="button" onclick="translateService()" class="px-3 bg-indigo-50 text-indigo-600 rounded-xl hover:bg-indigo-100 transition-colors tooltip" title="وەرگێڕان بۆ زمانەکانی تر">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                      <path fill-rule="evenodd" d="M7 2a1 1 0 011 1v1h3a1 1 0 110 2H9.516l1.285 2.57A9.957 9.957 0 0113 7h-1a7.962 7.962 0 00-1.742 1.353l1.854 3.708A7.95 7.95 0 0015 10h1a9.953 9.953 0 01-3.666 3.666l-1.39-2.78A5.952 5.952 0 019 12a5.952 5.952 0 01-1.944-1.114l-1.39 2.78A9.953 9.953 0 012 10h1a7.95 7.95 0 002.888 2.061l1.854-3.708A7.962 7.962 0 006 7H5a1 1 0 110-2h3V3a1 1 0 011-1z" clip-rule="evenodd" />
                    </svg>
                </button>
            </div>
            @error('name_ckb') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>
        
        <div>
            <label for="price" class="block text-sm font-medium text-slate-700 mb-2">نرخ ($)</label>
            <input type="number" step="0.01" id="price" name="price" required dir="ltr"
                class="w-full text-right px-4 py-2.5 bg-slate-50 border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all font-medium text-slate-700">
            @error('price') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>
    </div>

    <!-- Hidden translations (filled via js or auto-filled on backend) -->
    <div id="translations_container" class="hidden grid grid-cols-1 md:grid-cols-2 gap-6 mb-6 pt-4 border-t border-slate-100">
        <div>
            <label for="name_en" class="block text-sm font-medium text-slate-700 mb-2">ناوی خزمەتگوزاری (ئینگلیزی)</label>
            <input type="text" id="name_en" name="name_en" dir="ltr"
                class="w-full px-4 py-2 bg-white border border-slate-200 rounded-lg">
        </div>
        <div>
            <label for="name_ar" class="block text-sm font-medium text-slate-700 mb-2">ناوی خزمەتگوزاری (عەرەبی)</label>
            <input type="text" id="name_ar" name="name_ar" dir="rtl"
                class="w-full px-4 py-2 bg-white border border-slate-200 rounded-lg">
        </div>
    </div>

    <div class="flex justify-end">
        <button type="submit" class="px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-medium transition-colors shadow-lg shadow-blue-500/30">
            زیادکردنی خزمەتگوزاری
        </button>
    </div>
</form>

<!-- Existing Services List -->
<div class="bg-white rounded-2xl shadow-sm border border-slate-200/60 overflow-hidden">
    <table class="w-full text-right text-sm">
        <thead class="bg-slate-50 text-slate-600 font-medium">
            <tr>
                <th class="py-4 px-6 border-b border-slate-200">ناوی خزمەتگوزاری</th>
                <th class="py-4 px-6 border-b border-slate-200">نرخ</th>
                <th class="py-4 px-6 border-b border-slate-200">کردارەکان</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-slate-100 text-slate-700">
            @forelse($services as $service)
            <tr class="hover:bg-slate-50/50 transition-colors">
                <td class="py-4 px-6">
                    <div class="font-medium text-slate-800">{{ $service->name_ckb }}</div>
                    <div class="text-xs text-slate-500 mt-1">EN: {{ $service->name_en }} | AR: {{ $service->name_ar }}</div>
                </td>
                <td class="py-4 px-6 font-semibold text-emerald-600">${{ $service->price }}</td>
                <td class="py-4 px-6">
                    <form action="{{ route('doctor.services.destroy', $service->id) }}" method="POST" onsubmit="return confirm('دڵنیایت لە سڕینەوەی؟');">
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
                <td colspan="3" class="py-8 px-6 text-center text-slate-500">
                    هیچ خزمەتگوزارییەک بوونی نییە. تکایە یەکەم خزمەتگوزاری زیاد بکە.
                </td>
            </tr>
            @endforelse
        </tbody>
    </table>
</div>

<script>
    function translateService() {
        const text = document.getElementById('name_ckb').value;
        if(!text) return;
        
        document.getElementById('translations_container').classList.remove('hidden');
        document.getElementById('name_en').value = 'لە وەرگێڕاندایە...';
        document.getElementById('name_ar').value = 'لە وەرگێڕاندایە...';

        fetch('{{ route('api.translate') }}', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-TOKEN': '{{ csrf_token() }}'
            },
            body: JSON.stringify({text: text})
        })
        .then(response => response.json())
        .then(data => {
            if(data.success) {
                document.getElementById('name_en').value = data.translations.en;
                document.getElementById('name_ar').value = data.translations.ar;
            }
        });
    }
</script>
@endsection
