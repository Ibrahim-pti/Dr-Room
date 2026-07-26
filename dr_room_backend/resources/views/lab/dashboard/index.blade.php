@extends('lab.layouts.app')

@section('content')
<div class="fade-up" style="display:flex;flex-direction:column;gap:24px;padding-bottom:40px;">

    <!-- Welcome -->
    <div style="display:flex;flex-wrap:wrap;align-items:flex-end;justify-content:space-between;gap:16px;background:#fff;padding:24px 28px;border-radius:16px;border:1px solid #e2e8f0;">
        <div>
            <h1 style="font-size:1.6rem;font-weight:800;color:#0f172a;margin:0 0 6px;">داشبۆردی تاقیگە</h1>
            <p style="margin:0;color:#64748b;font-size:0.9rem;font-weight:500;">بەخێربێیتەوە بۆ سیستەم، <span style="color:#7c3aed;font-weight:700;">{{ explode(' ', $user->name)[0] }}</span></p>
        </div>
        <div style="display:flex;align-items:center;gap:8px;background:#f8fafc;padding:8px 16px;border-radius:10px;font-size:0.82rem;color:#94a3b8;font-weight:600;">
            <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
            {{ now()->format('Y-m-d') }}
        </div>
    </div>

    <!-- Stats -->
    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:16px;">
        @php
            $stats = [
                ['label' => 'داواکارییەکانی ئەمڕۆ', 'value' => 28, 'color' => '#7c3aed', 'bg' => '#f5f3ff', 'icon' => 'M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z'],
                ['label' => 'پشکنینی تەواوکراو', 'value' => 15, 'color' => '#059669', 'bg' => '#ecfdf5', 'icon' => 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z'],
                ['label' => 'لە چاوەڕوانیدا', 'value' => 13, 'color' => '#d97706', 'bg' => '#fffbeb', 'icon' => 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z'],
            ];
        @endphp
        @foreach($stats as $s)
        <div style="background:#fff;border-radius:14px;padding:22px;border:1px solid #e2e8f0;transition:transform 0.2s ease,box-shadow 0.2s ease;cursor:default;" onmouseover="this.style.transform='translateY(-3px)';this.style.boxShadow='0 8px 25px rgba(0,0,0,0.06)'" onmouseout="this.style.transform='none';this.style.boxShadow='none'">
            <div style="width:44px;height:44px;border-radius:12px;background:{{ $s['bg'] }};display:flex;align-items:center;justify-content:center;margin-bottom:16px;">
                <svg width="22" height="22" fill="none" stroke="{{ $s['color'] }}" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="{{ $s['icon'] }}"/></svg>
            </div>
            <div style="font-size:1.75rem;font-weight:800;color:#0f172a;margin-bottom:4px;" dir="ltr">{{ $s['value'] }}</div>
            <div style="font-size:0.8rem;color:#64748b;font-weight:600;">{{ $s['label'] }}</div>
        </div>
        @endforeach
    </div>

    <!-- Content Grid -->
    <div style="display:grid;grid-template-columns:2fr 1fr;gap:20px;">

        <!-- Recent Requests -->
        <div style="background:#fff;border-radius:16px;border:1px solid #e2e8f0;overflow:hidden;display:flex;flex-direction:column;">
            <div style="padding:20px 24px;border-bottom:1px solid #f1f5f9;display:flex;justify-content:space-between;align-items:center;">
                <h3 style="margin:0;font-size:1rem;font-weight:700;color:#0f172a;">داواکارییە نوێیەکان</h3>
                <a href="{{ route('lab.patients.index') }}" style="font-size:0.8rem;font-weight:700;color:#7c3aed;text-decoration:none;background:#f5f3ff;padding:6px 14px;border-radius:8px;transition:background 0.2s;" onmouseover="this.style.background='#ede9fe'" onmouseout="this.style.background='#f5f3ff'">هەمووی ببینە</a>
            </div>
            <div style="padding:8px 12px;flex:1;">
                @php
                    $dummies = [
                        ['id' => '#L-1024', 'name' => 'عەلی ئەحمەد', 'type' => 'پشکنینی خوێنی گشتی (CBC)', 'status' => 'نوێ', 'sc' => '#7c3aed', 'sb' => '#f5f3ff'],
                        ['id' => '#L-1025', 'name' => 'سارا کەریم', 'type' => 'پشکنینی شەکرە (FBS)', 'status' => 'لە کارکردندایە', 'sc' => '#d97706', 'sb' => '#fffbeb'],
                        ['id' => '#L-1026', 'name' => 'حەسەن قادر', 'type' => 'پشکنینی ڤیتامین D', 'status' => 'تەواوکراو', 'sc' => '#059669', 'sb' => '#ecfdf5'],
                        ['id' => '#L-1027', 'name' => 'ڕەزان محەمەد', 'type' => 'پشکنینی هۆرمۆنی تایرۆید', 'status' => 'نوێ', 'sc' => '#7c3aed', 'sb' => '#f5f3ff'],
                    ];
                @endphp
                @foreach($dummies as $d)
                <div style="display:flex;align-items:center;gap:14px;padding:12px 14px;border-radius:12px;transition:background 0.15s;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                    <div style="width:52px;text-align:center;">
                        <div style="font-size:0.82rem;font-weight:800;color:#0f172a;">{{ $d['id'] }}</div>
                    </div>
                    <div style="width:40px;height:40px;border-radius:50%;background:#f1f5f9;display:flex;align-items:center;justify-content:center;font-weight:700;color:#64748b;font-size:0.9rem;flex-shrink:0;">{{ mb_substr($d['name'], 0, 1) }}</div>
                    <div style="flex:1;min-width:0;">
                        <div style="font-size:0.88rem;font-weight:700;color:#0f172a;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">{{ $d['name'] }}</div>
                        <div style="font-size:0.78rem;color:#94a3b8;font-weight:500;">{{ $d['type'] }}</div>
                    </div>
                    <span style="font-size:0.72rem;font-weight:700;padding:5px 12px;border-radius:8px;white-space:nowrap;background:{{ $d['sb'] }};color:{{ $d['sc'] }};">{{ $d['status'] }}</span>
                </div>
                @endforeach
            </div>
        </div>

        <!-- Chart -->
        <div style="background:#fff;border-radius:16px;border:1px solid #e2e8f0;padding:22px;display:flex;flex-direction:column;">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
                <h3 style="margin:0;font-size:1rem;font-weight:700;color:#0f172a;">ئاماری پشکنینەکان</h3>
            </div>
            <div style="position:relative;flex:1;min-height:250px;">
                <canvas id="appointmentsChart"></canvas>
            </div>
        </div>
    </div>
</div>

<style>
    @media (max-width: 1023px) {
        div[style*="grid-template-columns:2fr 1fr"] { grid-template-columns: 1fr !important; }
    }
    @media (max-width: 639px) {
        div[style*="grid-template-columns:repeat(3,1fr)"] { grid-template-columns: 1fr !important; }
    }
</style>

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
                        backgroundColor: ['#7c3aed', '#059669', '#d97706', '#64748b'],
                        borderWidth: 0,
                        hoverOffset: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: { font: { family: 'Rabar', weight: 'bold', size: 11 }, padding: 16, color: '#64748b' }
                        }
                    },
                    cutout: '72%'
                }
            });
        }
    });
</script>
@endsection
