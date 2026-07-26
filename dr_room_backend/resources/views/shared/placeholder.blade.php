@extends($layout)

@section('content')
<div class="fade-up" style="display:flex;flex-direction:column;gap:24px;padding-bottom:40px;">
    <!-- Header -->
    <div style="display:flex;flex-wrap:wrap;align-items:center;justify-content:space-between;gap:16px;background:#fff;padding:24px 28px;border-radius:16px;border:1px solid #e2e8f0;">
        <div>
            <h1 style="font-size:1.6rem;font-weight:800;color:#0f172a;margin:0 0 6px;">{{ $title ?? 'بەش' }}</h1>
            <p style="margin:0;color:#64748b;font-size:0.9rem;font-weight:500;display:flex;align-items:center;gap:6px;">
                بەڕێوەبردن و بینینی زانیارییەکانی تایبەت بە {{ $title ?? 'ئەم بەشە' }}
            </p>
        </div>
        
        <div style="display:flex;align-items:center;gap:12px;">
            <button style="display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:10px 20px;border-radius:12px;background:#fff;border:1px solid #e2e8f0;color:#64748b;font-weight:700;font-size:0.9rem;cursor:pointer;transition:all 0.2s;font-family:inherit;" onmouseover="this.style.background='#f8fafc';this.style.color='#0f172a'" onmouseout="this.style.background='#fff';this.style.color='#64748b'">
                پاڵاوتن
            </button>
            <button style="display:inline-flex;align-items:center;justify-content:center;gap:8px;padding:10px 20px;border-radius:12px;background:#4f46e5;border:none;color:#fff;font-weight:700;font-size:0.9rem;cursor:pointer;transition:all 0.2s;font-family:inherit;" onmouseover="this.style.background='#4338ca'" onmouseout="this.style.background='#4f46e5'">
                <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                زیادکردنی نوێ
            </button>
        </div>
    </div>

    <!-- Stats -->
    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:16px;">
        @php
            $stats = [
                ['label' => 'کۆی گشتی', 'val' => '٢٤٥', 'color' => '#4f46e5', 'bg' => '#eef2ff'],
                ['label' => 'نوێ', 'val' => '١٢', 'color' => '#059669', 'bg' => '#ecfdf5'],
                ['label' => 'تەواوکراو', 'val' => '١٨٤', 'color' => '#d97706', 'bg' => '#fffbeb']
            ];
        @endphp
        @foreach($stats as $s)
        <div style="background:#fff;border-radius:14px;padding:22px;border:1px solid #e2e8f0;">
            <div style="font-size:0.8rem;color:#64748b;font-weight:700;margin-bottom:8px;">{{ $s['label'] }}</div>
            <div style="font-size:2rem;font-weight:800;color:{{ $s['color'] }};">{{ $s['val'] }}</div>
        </div>
        @endforeach
    </div>

    <!-- Search & Filters -->
    <div style="background:#fff;padding:16px;border-radius:16px;border:1px solid #e2e8f0;display:flex;gap:12px;flex-wrap:wrap;">
        <input type="text" placeholder="گەڕان..." style="flex:1;min-width:200px;padding:12px 16px;border-radius:10px;border:1px solid #e2e8f0;background:#f8fafc;font-family:inherit;font-size:0.9rem;outline:none;transition:border 0.2s;" onfocus="this.style.borderColor='#4f46e5'" onblur="this.style.borderColor='#e2e8f0'">
        
        <select style="padding:12px 16px;border-radius:10px;border:1px solid #e2e8f0;background:#fff;font-family:inherit;font-size:0.9rem;outline:none;color:#475569;font-weight:600;min-width:150px;">
            <option>هەموو جۆرەکان</option>
            <option>نوێترین</option>
            <option>کۆنترین</option>
        </select>
    </div>

    <!-- Data Table -->
    <div style="background:#fff;border-radius:16px;border:1px solid #e2e8f0;overflow:hidden;">
        <div style="overflow-x:auto;">
            <table style="width:100%;border-collapse:collapse;text-align:right;">
                <thead>
                    <tr style="background:#f8fafc;border-bottom:1px solid #e2e8f0;">
                        <th style="padding:16px 20px;font-size:0.8rem;color:#64748b;font-weight:700;">زانیاری سەرەکی</th>
                        <th style="padding:16px 20px;font-size:0.8rem;color:#64748b;font-weight:700;">بەروار</th>
                        <th style="padding:16px 20px;font-size:0.8rem;color:#64748b;font-weight:700;">دۆخ</th>
                        <th style="padding:16px 20px;font-size:0.8rem;color:#64748b;font-weight:700;text-align:left;">کردارەکان</th>
                    </tr>
                </thead>
                <tbody>
                    @php
                        $names = ['زانیاری نموونەیی ١', 'فایلی ژمارە ٢', 'داتای نوێی سیستەم', 'تۆماری تایبەت ٤', 'زانیاری گشتی ٥'];
                        $statuses = [
                            ['text' => 'تەواوکراو', 'color' => '#059669', 'bg' => '#ecfdf5'],
                            ['text' => 'لە چاوەڕوانیدا', 'color' => '#d97706', 'bg' => '#fffbeb'],
                            ['text' => 'بەڕێوەیە', 'color' => '#4f46e5', 'bg' => '#eef2ff'],
                            ['text' => 'تەواوکراو', 'color' => '#059669', 'bg' => '#ecfdf5'],
                            ['text' => 'هەڵوەشاوە', 'color' => '#dc2626', 'bg' => '#fef2f2']
                        ];
                    @endphp
                    @foreach($names as $index => $name)
                    <tr style="border-bottom:1px solid #f1f5f9;transition:background 0.2s;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                        <td style="padding:16px 20px;">
                            <div style="font-weight:800;color:#0f172a;font-size:0.9rem;margin-bottom:4px;">{{ $name }}</div>
                            <div style="color:#94a3b8;font-size:0.8rem;font-weight:600;">پێناسەی #ID-00{{ $index + 1 }}</div>
                        </td>
                        <td style="padding:16px 20px;">
                            <div style="font-weight:700;color:#475569;font-size:0.9rem;margin-bottom:4px;">{{ now()->subDays($index)->format('Y-m-d') }}</div>
                            <div style="color:#94a3b8;font-size:0.8rem;">{{ now()->subHours($index * 2)->format('H:i') }}</div>
                        </td>
                        <td style="padding:16px 20px;">
                            <span style="display:inline-block;padding:6px 12px;border-radius:8px;font-size:0.75rem;font-weight:700;background:{{ $statuses[$index]['bg'] }};color:{{ $statuses[$index]['color'] }};">
                                {{ $statuses[$index]['text'] }}
                            </span>
                        </td>
                        <td style="padding:16px 20px;text-align:left;">
                            <button style="background:none;border:none;color:#94a3b8;cursor:pointer;padding:6px;" onmouseover="this.style.color='#4f46e5'" onmouseout="this.style.color='#94a3b8'">
                                <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                            </button>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
            </table>
        </div>
        
        <!-- Pagination -->
        <div style="padding:16px 20px;border-top:1px solid #e2e8f0;display:flex;justify-content:space-between;align-items:center;font-size:0.85rem;color:#64748b;font-weight:600;">
            <div>پیشاندانی ١ بۆ ٥ لە ٢٤ ئەنجام</div>
            <div style="display:flex;gap:8px;">
                <button style="width:32px;height:32px;border-radius:8px;border:1px solid #e2e8f0;background:#fff;color:#94a3b8;cursor:pointer;font-weight:700;">1</button>
                <button style="width:32px;height:32px;border-radius:8px;border:none;background:#f1f5f9;color:#475569;cursor:pointer;font-weight:700;">2</button>
                <button style="width:32px;height:32px;border-radius:8px;border:none;background:#f1f5f9;color:#475569;cursor:pointer;font-weight:700;">3</button>
            </div>
        </div>
    </div>
</div>

<style>
    @media (max-width: 768px) {
        div[style*="grid-template-columns:repeat(3,1fr)"] { grid-template-columns: 1fr !important; }
    }
</style>
@endsection
