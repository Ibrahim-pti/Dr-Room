<!DOCTYPE html>
<html lang="ckb" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DrRoom - سەکۆی ستافی تەندروستی</title>
    <!-- Kurdish Font (Rabar or Noto) -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Kufi+Arabic:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        kurdish: ['"Noto Kufi Arabic"', 'sans-serif'],
                    },
                    colors: {
                        brand: '#2563EB',
                        brandLight: '#DBEAFE',
                        dark: '#0F172A',
                        textMuted: '#64748B'
                    }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Noto Kufi Arabic', sans-serif; background-color: #F8FAFC; }
        .gradient-text {
            background: linear-gradient(90deg, #2563EB, #3B82F6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .hero-pattern {
            background-image: radial-gradient(#E2E8F0 1px, transparent 1px);
            background-size: 24px 24px;
        }
        .card-hover {
            transition: all 0.3s ease;
        }
        .card-hover:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px -10px rgba(37,99,235,0.15);
            border-color: #BFDBFE;
        }
    </style>
</head>
<body class="antialiased text-slate-800 selection:bg-brandLight selection:text-brand">

    <!-- Navigation -->
    <nav class="fixed w-full bg-white/80 backdrop-blur-lg z-50 border-b border-slate-100">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-20">
                <!-- Logo -->
                <div class="flex items-center gap-3">
                    <div class="w-12 h-12 bg-brandLight rounded-xl flex items-center justify-center text-brand">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                            <line x1="12" y1="9" x2="12" y2="15"></line>
                            <line x1="9" y1="12" x2="15" y2="12"></line>
                        </svg>
                    </div>
                    <div>
                        <h1 class="text-2xl font-bold text-dark tracking-tight font-sans" dir="ltr">DrRoom</h1>
                        <p class="text-[11px] text-textMuted font-medium uppercase tracking-widest font-sans" dir="ltr">Staff Portal</p>
                    </div>
                </div>

                <!-- Actions -->
                <div class="flex items-center gap-4">
                    <a href="{{ route('staff.login') }}" class="hidden sm:block text-slate-600 hover:text-brand font-bold transition">چوونەژوورەوە</a>
                    <a href="{{ route('staff.register') }}" class="bg-brand hover:bg-blue-700 text-white px-6 py-2.5 rounded-xl font-bold transition shadow-lg shadow-blue-600/20">
                        خۆتۆمارکردن
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="relative pt-32 pb-20 lg:pt-48 lg:pb-32 overflow-hidden hero-pattern min-h-screen flex items-center">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 w-full">
            <div class="grid lg:grid-cols-2 gap-12 lg:gap-8 items-center">
                
                <!-- Text Content -->
                <div class="text-center lg:text-right">
                    <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-blue-50 border border-blue-100 text-brand font-medium text-sm mb-8">
                        <span class="relative flex h-2 w-2">
                          <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-brand opacity-75"></span>
                          <span class="relative inline-flex rounded-full h-2 w-2 bg-brand"></span>
                        </span>
                        سەکۆی تایبەت بە پزیشکان و کارمەندان
                    </div>
                    
                    <h1 class="text-4xl sm:text-5xl lg:text-6xl font-extrabold text-dark leading-[1.2] mb-6">
                        بەڕێوەبردنی کارەکانت <br>
                        <span class="gradient-text">بە شێوەیەکی زیرەکتر</span>
                    </h1>
                    
                    <p class="text-lg text-textMuted mb-10 max-w-xl mx-auto lg:mx-0 leading-relaxed">
                        دکتۆر ڕووم سیستەمێکی پێشکەوتوویە بۆ پزیشکان، پەرستاران، وە تاقیگەکان. لە یەک جێگەوە نەخۆشەکانت ببینە، کاتەکانت ڕێکبخە و ڕاپۆرتەکان بەڕێوەببە.
                    </p>
                    
                    <div class="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4">
                        <a href="{{ route('staff.register') }}" class="w-full sm:w-auto bg-brand hover:bg-blue-700 text-white px-8 py-4 rounded-2xl font-bold text-lg transition shadow-xl shadow-blue-600/30 flex items-center justify-center gap-2">
                            دەستپێبکە ئێستا
                            <svg class="w-5 h-5 rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                        </a>
                        <a href="{{ route('staff.login') }}" class="w-full sm:w-auto bg-white hover:bg-slate-50 text-slate-700 border border-slate-200 px-8 py-4 rounded-2xl font-bold text-lg transition flex items-center justify-center">
                            چوونەژوورەوە
                        </a>
                    </div>
                </div>

                <!-- Image/Graphics -->
                <div class="relative lg:h-[500px] flex items-center justify-center lg:justify-start mt-12 lg:mt-0">
                    <!-- Decorative blur -->
                    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[120%] h-[120%] bg-blue-100 rounded-full blur-3xl opacity-50 -z-10"></div>
                    
                    <img src="{{ asset('images/doctor.png') }}" alt="Doctor" class="w-[90%] max-w-[400px] object-contain drop-shadow-2xl relative z-10" onerror="this.onerror=null; this.src='https://placehold.co/400x500/eff6ff/2563eb?text=Doctor+Image';">
                </div>
            </div>
        </div>
    </section>

    <!-- Services Grid -->
    <section class="py-24 bg-white border-t border-slate-100">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="text-center max-w-2xl mx-auto mb-16">
                <h2 class="text-3xl font-bold text-dark mb-4">خزمەتگوزارییەکانی ئێمە بۆ کێیە؟</h2>
                <p class="text-textMuted text-lg">سەکۆکەمان بەشێوەیەک دیزاین کراوە کە کارئاسانی بۆ هەموو جۆرە ستافێکی تەندروستی بکات.</p>
            </div>

            <div class="grid md:grid-cols-3 gap-8">
                <!-- Doctor -->
                <div class="bg-white border border-slate-100 p-8 rounded-[2rem] card-hover shadow-sm">
                    <div class="w-16 h-16 bg-blue-50 text-brand rounded-2xl flex items-center justify-center mb-6">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-dark mb-3">پزیشکان</h3>
                    <p class="text-textMuted mb-6 leading-relaxed">
                        کلینیکەکەت بە دیجیتاڵی بکە. بینینی نەخۆش، ناردنی ڕەچەتە بۆ دەرمانخانە، وە بینینی ئەنجامی تاقیگە ڕاستەوخۆ لەسەر شاشەکەت.
                    </p>
                    <ul class="space-y-3 text-sm font-medium text-slate-600">
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-brand"></div> ڕەچەتەی ئەلیکترۆنی</li>
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-brand"></div> ڕێکخستنی کاتەکان</li>
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-brand"></div> مەلەفی نەخۆش</li>
                    </ul>
                </div>

                <!-- Nurse -->
                <div class="bg-white border border-slate-100 p-8 rounded-[2rem] card-hover shadow-sm">
                    <div class="w-16 h-16 bg-pink-50 text-pink-500 rounded-2xl flex items-center justify-center mb-6">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-dark mb-3">پەرستاران</h3>
                    <p class="text-textMuted mb-6 leading-relaxed">
                        هاوکاری پزیشک بکە لە بەڕێوەبردنی کلینیک. تۆمارکردنی زانیارییە سەرەتاییەکانی نەخۆش وە ڕێکخستنی سەرەکان بە ئاسانی.
                    </p>
                    <ul class="space-y-3 text-sm font-medium text-slate-600">
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-pink-500"></div> تۆمارکردنی پشکنین</li>
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-pink-500"></div> ڕێکخستنی نەخۆش</li>
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-pink-500"></div> پەیوەندی بە پزیشک</li>
                    </ul>
                </div>

                <!-- Lab -->
                <div class="bg-white border border-slate-100 p-8 rounded-[2rem] card-hover shadow-sm">
                    <div class="w-16 h-16 bg-emerald-50 text-emerald-500 rounded-2xl flex items-center justify-center mb-6">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-dark mb-3">تاقیگەکان</h3>
                    <p class="text-textMuted mb-6 leading-relaxed">
                        وەرگرتنی داواکارییەکان ڕاستەوخۆ لە پزیشکەوە، و ناردنەوەی ئەنجامەکان بە شێوەیەکی پارێزراو بەبێ کاغەز.
                    </p>
                    <ul class="space-y-3 text-sm font-medium text-slate-600">
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-emerald-500"></div> وەرگرتنی داواکاری</li>
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-emerald-500"></div> ناردنی ئەنجام</li>
                        <li class="flex items-center gap-3"><div class="w-2 h-2 rounded-full bg-emerald-500"></div> ئەرشیفی تاقیگە</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="py-8 bg-slate-50 border-t border-slate-200 text-center">
        <p class="text-slate-500 text-sm font-medium font-sans">
            &copy; {{ date('Y') }} DrRoom Healthcare. All rights reserved.
        </p>
    </footer>
</body>
</html>
