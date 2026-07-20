<!DOCTYPE html>
<html lang="ckb" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DrRoom - سەکۆی پزیشکان و ستافی تەندروستی</title>
    <!-- Use a nice Kurdish font -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Kufi+Arabic:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['"Noto Kufi Arabic"', 'sans-serif'],
                    },
                    colors: {
                        primary: '#2563EB',
                        secondary: '#3B82F6',
                        accent: '#DBEAFE'
                    }
                }
            }
        }
    </script>
    <style>
        body { font-family: 'Noto Kufi Arabic', sans-serif; background-color: #F8FAFC; }
        
        .hero-gradient {
            background: linear-gradient(135deg, #1E3A8A 0%, #2563EB 100%);
        }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.07);
        }

        .hover-lift {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .hover-lift:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px -5px rgba(0, 0, 0, 0.1);
        }
        
        .animated-bg {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            overflow: hidden;
            z-index: 0;
        }
        .circle {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
            animation: float 10s infinite linear;
        }
        @keyframes float {
            0% { transform: translateY(0) rotate(0deg); opacity: 0.8; }
            100% { transform: translateY(-800px) rotate(360deg); opacity: 0; }
        }
    </style>
</head>
<body class="antialiased text-slate-800 selection:bg-primary selection:text-white">

    <!-- Hero Section -->
    <section class="relative hero-gradient min-h-[600px] flex items-center justify-center overflow-hidden pb-20 pt-10">
        <!-- Background Animations -->
        <div class="animated-bg">
            <div class="circle w-64 h-64 left-[10%] bottom-[-20%] animate-[float_15s_infinite]"></div>
            <div class="circle w-96 h-96 right-[20%] bottom-[-40%] animate-[float_20s_infinite_reverse]"></div>
            <div class="circle w-32 h-32 right-[10%] top-[20%] animate-[float_10s_infinite]"></div>
        </div>

        <div class="relative z-10 container mx-auto px-6 text-center">
            <!-- Logo -->
            <div class="inline-flex items-center justify-center gap-3 bg-white/10 px-6 py-3 rounded-full backdrop-blur-md border border-white/20 mb-8">
                <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path>
                    <line x1="12" y1="9" x2="12" y2="15"></line>
                    <line x1="9" y1="12" x2="15" y2="12"></line>
                </svg>
                <span class="text-xl font-bold text-white tracking-wider font-sans" dir="ltr">DrRoom Portal</span>
            </div>

            <h1 class="text-4xl md:text-6xl font-extrabold text-white mb-6 leading-tight">
                بەشداربە لە باشترین سەکۆی <br> چاودێری تەندروستی
            </h1>
            <p class="text-lg md:text-xl text-blue-100 max-w-2xl mx-auto mb-10 leading-relaxed">
                ئەگەر پزیشک، پەرستار، یان تاقیگەی پزیشکیت، لێرەدا دەتوانیت بە ئاسانی کارەکانت ڕێکبخەیت، نەخۆشەکانت ببینیت و خزمەتگوزارییەکانت پێشکەش بکەیت.
            </p>

            <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
                <a href="{{ route('staff.register') }}" class="w-full sm:w-auto px-8 py-4 bg-white text-primary font-bold rounded-xl shadow-lg hover:bg-blue-50 transition-all hover:scale-105">
                    خۆتۆمارکردن ئێستا
                </a>
                <a href="{{ route('staff.login') }}" class="w-full sm:w-auto px-8 py-4 bg-primary/30 text-white border border-white/30 font-bold rounded-xl shadow-lg hover:bg-primary/40 backdrop-blur-md transition-all hover:scale-105">
                    چوونەژوورەوە
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="py-20 -mt-16 relative z-20">
        <div class="container mx-auto px-6">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                
                <!-- Doctor Card -->
                <div class="glass-card hover-lift rounded-2xl p-8">
                    <div class="w-14 h-14 bg-blue-100 rounded-2xl flex items-center justify-center mb-6 text-primary">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-3">بۆ پزیشکان</h3>
                    <p class="text-slate-600 leading-relaxed mb-6">
                        بەڕێوەبردنی کاتەکانی بینینی نەخۆش، بینینی مەلەفی پزیشکی نەخۆشەکان، وە ناردنی ڕەچەتە بە شێوەیەکی دیجیتاڵی. هەموو شتێک لە یەک جێگە.
                    </p>
                    <ul class="space-y-2 text-sm text-slate-500 font-medium">
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> ڕێکخستنی کاتەکان</li>
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> مەلەفی ئەلیکترۆنی نەخۆش</li>
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> بینینی ڕاپۆرتی تاقیگە ڕاستەوخۆ</li>
                    </ul>
                </div>

                <!-- Nurse Card -->
                <div class="glass-card hover-lift rounded-2xl p-8">
                    <div class="w-14 h-14 bg-pink-100 rounded-2xl flex items-center justify-center mb-6 text-pink-600">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-3">بۆ پەرستاران</h3>
                    <p class="text-slate-600 leading-relaxed mb-6">
                        یارمەتیدانی پزیشکان لە بەڕێوەبردنی کلینیک و نەخۆشەکان. تۆمارکردنی زانیارییە سەرەتاییەکان و ڕێکخستنی سەرەکان بە ئاسانی.
                    </p>
                    <ul class="space-y-2 text-sm text-slate-500 font-medium">
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> تۆمارکردنی پشکنینە سەرەتاییەکان</li>
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> ئاگادارکردنەوەی نەخۆشەکان</li>
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> پەیوەندی ڕاستەوخۆ لەگەڵ پزیشک</li>
                    </ul>
                </div>

                <!-- Lab Card -->
                <div class="glass-card hover-lift rounded-2xl p-8">
                    <div class="w-14 h-14 bg-emerald-100 rounded-2xl flex items-center justify-center mb-6 text-emerald-600">
                        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
                        </svg>
                    </div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-3">بۆ تاقیگەکان</h3>
                    <p class="text-slate-600 leading-relaxed mb-6">
                        وەرگرتنی داواکاری پشکنین ڕاستەوخۆ لە پزیشکەوە، وە ناردنەوەی ئەنجامەکان بە شێوەیەکی پارێزراو بۆ هەژماری نەخۆش و پزیشک.
                    </p>
                    <ul class="space-y-2 text-sm text-slate-500 font-medium">
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> سیستەمی زیرەک بۆ پشکنینەکان</li>
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> ناردنی ئەنجام ڕاستەوخۆ بە دیجیتاڵی</li>
                        <li class="flex items-center gap-2"><svg class="w-4 h-4 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg> داتابەیسی پارێزراو بۆ تاقیگە</li>
                    </ul>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="py-10 border-t border-slate-200 mt-10">
        <div class="container mx-auto px-6 text-center">
            <p class="text-slate-500 text-sm font-medium">© 2026 DrRoom. هەموو مافێکی پارێزراوە.</p>
        </div>
    </footer>
</body>
</html>
