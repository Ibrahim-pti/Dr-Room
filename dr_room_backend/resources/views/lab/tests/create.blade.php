@extends('lab.layouts.app')

@section('content')
<div class="fade-up" style="display:flex;flex-direction:column;gap:24px;padding-bottom:40px;max-width:800px;margin:0 auto;">

    <!-- Header -->
    <div style="display:flex;align-items:center;justify-content:space-between;background:#fff;padding:24px 28px;border-radius:16px;border:1px solid #e2e8f0;">
        <div style="display:flex;align-items:center;gap:16px;">
            <div style="width:48px;height:48px;border-radius:12px;background:#f5f3ff;color:#7c3aed;display:flex;align-items:center;justify-content:center;">
                <svg width="24" height="24" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
            </div>
            <div>
                <h1 style="font-size:1.5rem;font-weight:800;color:#0f172a;margin:0 0 4px;">زیادکردنی پشکنینی نوێ</h1>
                <p style="margin:0;color:#64748b;font-size:0.9rem;font-weight:500;">فۆڕمی تۆمارکردنی زانیارییەکانی پشکنینی نەخۆش</p>
            </div>
        </div>
        <a href="{{ route('lab.dashboard') }}" style="display:flex;align-items:center;gap:8px;padding:10px 16px;border-radius:10px;background:#f1f5f9;color:#475569;font-weight:700;font-size:0.9rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.background='#e2e8f0';this.style.color='#0f172a'" onmouseout="this.style.background='#f1f5f9';this.style.color='#475569'">
            <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
            گەڕانەوە
        </a>
    </div>

    <!-- Form Container -->
    <div style="background:#fff;border-radius:16px;border:1px solid #e2e8f0;overflow:hidden;">
        <form action="#" method="POST" style="display:flex;flex-direction:column;">
            @csrf
            
            <div style="padding:28px;display:flex;flex-direction:column;gap:24px;">
                
                <!-- Patient Search / Selection -->
                <div>
                    <label style="display:block;font-size:0.9rem;font-weight:700;color:#1e293b;margin-bottom:8px;">ناوی نەخۆش</label>
                    <div style="position:relative;">
                        <div style="position:absolute;top:50%;right:14px;transform:translateY(-50%);color:#94a3b8;">
                            <svg width="20" height="20" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </div>
                        <input type="text" placeholder="گەڕان بەدوای ناوی نەخۆش یان ژمارەی مۆبایل..." style="width:100%;padding:14px 44px 14px 16px;border-radius:12px;border:1px solid #e2e8f0;background:#f8fafc;font-family:inherit;font-size:0.95rem;outline:none;transition:border 0.2s;box-sizing:border-box;" onfocus="this.style.borderColor='#7c3aed';this.style.background='#fff'" onblur="this.style.borderColor='#e2e8f0';this.style.background='#f8fafc'">
                    </div>
                </div>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                    <!-- Test Type -->
                    <div>
                        <label style="display:block;font-size:0.9rem;font-weight:700;color:#1e293b;margin-bottom:8px;">جۆری پشکنین</label>
                        <select style="width:100%;padding:14px 16px;border-radius:12px;border:1px solid #e2e8f0;background:#f8fafc;font-family:inherit;font-size:0.95rem;font-weight:600;color:#475569;outline:none;transition:border 0.2s;box-sizing:border-box;cursor:pointer;" onfocus="this.style.borderColor='#7c3aed';this.style.background='#fff'" onblur="this.style.borderColor='#e2e8f0';this.style.background='#f8fafc'">
                            <option value="">هەڵبژێرە...</option>
                            <option value="blood">پشکنینی خوێنی گشتی (CBC)</option>
                            <option value="sugar">پشکنینی شەکرە (FBS)</option>
                            <option value="vitamin_d">پشکنینی ڤیتامین D</option>
                            <option value="urine">پشکنینی میز (GUE)</option>
                            <option value="thyroid">هۆرمۆنی تایرۆید (TSH)</option>
                            <option value="other">تر...</option>
                        </select>
                    </div>

                    <!-- Priority -->
                    <div>
                        <label style="display:block;font-size:0.9rem;font-weight:700;color:#1e293b;margin-bottom:8px;">ئاستی پێویستی (Priority)</label>
                        <select style="width:100%;padding:14px 16px;border-radius:12px;border:1px solid #e2e8f0;background:#f8fafc;font-family:inherit;font-size:0.95rem;font-weight:600;color:#475569;outline:none;transition:border 0.2s;box-sizing:border-box;cursor:pointer;" onfocus="this.style.borderColor='#7c3aed';this.style.background='#fff'" onblur="this.style.borderColor='#e2e8f0';this.style.background='#f8fafc'">
                            <option value="normal">ئاسایی</option>
                            <option value="urgent">بەپەلە</option>
                            <option value="top_urgent">زۆر بەپەلە (Emergency)</option>
                        </select>
                    </div>
                </div>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                    <!-- Date -->
                    <div>
                        <label style="display:block;font-size:0.9rem;font-weight:700;color:#1e293b;margin-bottom:8px;">بەرواری وەرگرتنی نموونە</label>
                        <input type="date" value="{{ date('Y-m-d') }}" style="width:100%;padding:13px 16px;border-radius:12px;border:1px solid #e2e8f0;background:#f8fafc;font-family:inherit;font-size:0.95rem;color:#475569;outline:none;transition:border 0.2s;box-sizing:border-box;" onfocus="this.style.borderColor='#7c3aed';this.style.background='#fff'" onblur="this.style.borderColor='#e2e8f0';this.style.background='#f8fafc'">
                    </div>
                    <!-- Time -->
                    <div>
                        <label style="display:block;font-size:0.9rem;font-weight:700;color:#1e293b;margin-bottom:8px;">کاتی وەرگرتنی نموونە</label>
                        <input type="time" value="{{ date('H:i') }}" style="width:100%;padding:13px 16px;border-radius:12px;border:1px solid #e2e8f0;background:#f8fafc;font-family:inherit;font-size:0.95rem;color:#475569;outline:none;transition:border 0.2s;box-sizing:border-box;" onfocus="this.style.borderColor='#7c3aed';this.style.background='#fff'" onblur="this.style.borderColor='#e2e8f0';this.style.background='#f8fafc'">
                    </div>
                </div>

                <!-- Doctor Referral -->
                <div>
                    <label style="display:block;font-size:0.9rem;font-weight:700;color:#1e293b;margin-bottom:8px;">ناوی پزیشکی نێرەر (ئارەزوومەندانە)</label>
                    <input type="text" placeholder="بۆ نموونە: دکتۆر سامان عەلی..." style="width:100%;padding:14px 16px;border-radius:12px;border:1px solid #e2e8f0;background:#f8fafc;font-family:inherit;font-size:0.95rem;outline:none;transition:border 0.2s;box-sizing:border-box;" onfocus="this.style.borderColor='#7c3aed';this.style.background='#fff'" onblur="this.style.borderColor='#e2e8f0';this.style.background='#f8fafc'">
                </div>

                <!-- Notes -->
                <div>
                    <label style="display:block;font-size:0.9rem;font-weight:700;color:#1e293b;margin-bottom:8px;">تێبینییەکان</label>
                    <textarea rows="4" placeholder="هەر زانیارییەکی زیاتر دەربارەی پشکنینەکە لێرە بنووسە..." style="width:100%;padding:14px 16px;border-radius:12px;border:1px solid #e2e8f0;background:#f8fafc;font-family:inherit;font-size:0.95rem;outline:none;transition:border 0.2s;box-sizing:border-box;resize:vertical;" onfocus="this.style.borderColor='#7c3aed';this.style.background='#fff'" onblur="this.style.borderColor='#e2e8f0';this.style.background='#f8fafc'"></textarea>
                </div>

            </div>

            <!-- Footer Buttons -->
            <div style="padding:20px 28px;background:#f8fafc;border-top:1px solid #e2e8f0;display:flex;justify-content:flex-end;gap:12px;">
                <button type="button" style="padding:12px 24px;border-radius:12px;background:#fff;border:1px solid #cbd5e1;color:#64748b;font-weight:700;font-size:0.95rem;cursor:pointer;transition:all 0.2s;font-family:inherit;" onmouseover="this.style.background='#f1f5f9';this.style.color='#0f172a'" onmouseout="this.style.background='#fff';this.style.color='#64748b'">
                    پاشگەزبوونەوە
                </button>
                <button type="button" onclick="alert('پشکنینەکە بە سەرکەوتوویی تۆمارکرا!')" style="padding:12px 28px;border-radius:12px;background:#7c3aed;border:none;color:#fff;font-weight:700;font-size:0.95rem;cursor:pointer;transition:all 0.2s;font-family:inherit;display:flex;align-items:center;gap:8px;" onmouseover="this.style.background='#6d28d9'" onmouseout="this.style.background='#7c3aed'">
                    <svg width="18" height="18" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                    پاشەکەوتکردن
                </button>
            </div>
        </form>
    </div>
</div>
@endsection
