<!DOCTYPE html>
<html lang="ckb" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DrRoom - Nurse Dashboard</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <style>
        body { font-family: 'Rabar', 'Inter', sans-serif; background-color: #F8FAFC; }
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #99F6E4; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #2DD4BF; }
        
        .glass-panel {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .sidebar-transition { transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
    </style>
</head>
<body class="text-slate-800 antialiased overflow-x-hidden selection:bg-teal-100 selection:text-teal-900">

    @if(!request()->routeIs('nurse.login') && !request()->routeIs('nurse.register'))
        <!-- Mobile Overlay -->
        <div id="sidebarOverlay" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-40 hidden lg:hidden transition-opacity" onclick="toggleSidebar()"></div>

        <!-- Sidebar -->
        <aside id="sidebar" class="sidebar-transition fixed top-0 right-0 h-screen w-72 bg-white/80 backdrop-blur-xl border-l border-slate-200/60 z-50 flex flex-col translate-x-full lg:translate-x-0 shadow-2xl lg:shadow-none">
            <!-- Logo -->
            <div class="h-20 flex items-center gap-3 px-8 border-b border-slate-100/80">
                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-teal-500 to-emerald-600 flex items-center justify-center text-white shadow-lg shadow-teal-500/20">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <span class="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-slate-800 to-slate-600">DrRoom</span>
            </div>

            <!-- Navigation -->
            <nav class="flex-1 overflow-y-auto py-6 px-4 space-y-2">
                <!-- Dashboard -->
                <a href="{{ route('nurse.dashboard') }}" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 {{ request()->routeIs('nurse.dashboard') ? 'bg-teal-50 text-teal-600 font-bold shadow-sm' : 'text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium' }}">
                    <svg class="w-5 h-5 {{ request()->routeIs('nurse.dashboard') ? 'text-teal-600' : 'text-slate-400' }}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"/></svg>
                    داشبۆرد
                </a>

                <!-- Patient Care Dropdown -->
                <div>
                    <button type="button" onclick="toggleMenu('menu-patient-care')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                            چاودێری نەخۆش
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-patient-care" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('nurse.patients.index') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">لیستی نەخۆشەکان</a>
                        <a href="{{ route('nurse.patients.symptoms') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">تۆمارکردنی نیشانەکان</a>
                        <a href="{{ route('nurse.patients.monitoring') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">چاودێریکردنی نەخۆش</a>
                        <a href="{{ route('nurse.patients.notes') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">تێبینی ڕۆژانە</a>
                        <a href="{{ route('nurse.patients.medication') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">پێدانی دەرمان</a>
                    </div>
                </div>

                <!-- Appointment Management Dropdown -->
                <div>
                    <button type="button" onclick="toggleMenu('menu-nurse-appointments')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                            بەڕێوەبردنی چاوپێکەوتن
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-nurse-appointments" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('nurse.appointments.index') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">بینینی چاوپێکەوتنەکان</a>
                        <a href="{{ route('nurse.appointments.confirm') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">دڵنیابوونەوە لە کات</a>
                        <a href="{{ route('nurse.appointments.prepare') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">ئامادەکردنی نەخۆش</a>
                    </div>
                </div>

                <!-- Communication -->
                <div>
                    <button type="button" onclick="toggleMenu('menu-communication')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/></svg>
                            پەیوەندی
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-communication" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('nurse.communication.doctor') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">چات لەگەڵ دکتۆر</a>
                        <a href="{{ route('nurse.communication.patient') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">چات لەگەڵ نەخۆش</a>
                    </div>
                </div>

                <!-- Reports -->
                <div>
                    <button type="button" onclick="toggleMenu('menu-reports')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                            ڕاپۆرتەکان
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-reports" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('nurse.reports.index') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">ڕاپۆرتی پەرستاری</a>
                        <a href="{{ route('nurse.reports.progress') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">بەرەوپێشچوونی نەخۆش</a>
                    </div>
                </div>

                <!-- Profile Dropdown -->
                <div>
                    <button type="button" onclick="toggleMenu('menu-nurse-profile')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                            پرۆفایل
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-nurse-profile" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('nurse.profile.index') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">زانیاری کەسی</a>
                        <a href="{{ route('nurse.profile.schedule') }}" class="block text-sm text-slate-500 hover:text-teal-600 hover:font-bold py-1.5 transition-all">خشتەی کارکردن</a>
                    </div>
                </div>
            </nav>

            <!-- Footer / Logout -->
            <div class="p-4 border-t border-slate-100/80">
                <form method="POST" action="{{ route('staff.logout') }}">
                    @csrf
                    <button type="submit" class="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-red-500 hover:bg-red-50 hover:text-red-600 font-medium transition-all duration-200 group">
                        <svg class="w-5 h-5 group-hover:translate-x-1 transition-transform rotate-180" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                        چوونەدەرەوە
                    </button>
                </form>
            </div>
        </aside>

        <!-- Main Wrapper -->
        <div id="mainWrapper" class="lg:mr-72 min-h-screen flex flex-col relative transition-all duration-300">
            <!-- Header -->
            <header class="h-20 glass-panel sticky top-0 z-30 px-4 sm:px-8 flex items-center justify-between shadow-sm">
                <div class="flex items-center gap-4">
                    <button onclick="toggleSidebar()" class="p-2 rounded-lg text-slate-500 hover:bg-slate-100 transition-colors">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg>
                    </button>
                    <!-- Small screen logo -->
                    <div id="mobileLogo" class="lg:hidden flex items-center gap-2">
                        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-teal-500 to-emerald-500 flex items-center justify-center text-white">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/></svg>
                        </div>
                        <span class="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-slate-800 to-slate-600">DrRoom</span>
                    </div>
                </div>

                <div class="flex items-center gap-4 sm:gap-6">
                    <!-- Notifications -->
                    <button class="relative p-2 rounded-full text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-all">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/></svg>
                        <span class="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-white"></span>
                    </button>

                    <!-- Profile -->
                    <div class="flex items-center gap-3 pr-2 sm:pr-0">
                        <div class="text-right hidden sm:block">
                            <div class="text-sm font-bold text-slate-800">پەرستار {{ explode(' ', Auth::user()->name)[0] }}</div>
                            <div class="text-xs font-medium text-slate-500">{{ Auth::user()->nurse->specialty ?? 'پەرستاری گشتی' }}</div>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-gradient-to-br from-teal-100 to-emerald-100 border-2 border-white shadow-sm flex items-center justify-center overflow-hidden">
                            @if(Auth::user()->nurse && Auth::user()->nurse->profile_image)
                                <img src="{{ asset('storage/' . Auth::user()->nurse->profile_image) }}" alt="Profile" class="w-full h-full object-cover">
                            @else
                                <span class="text-teal-600 font-bold text-lg">{{ mb_substr(Auth::user()->name, 0, 1) }}</span>
                            @endif
                        </div>
                    </div>
                </div>
            </header>

            <!-- Main Content Area -->
            <main class="flex-1 p-4 sm:p-8 w-full max-w-7xl mx-auto">
                @yield('content')
            </main>
        </div>

        <script>
            function toggleSidebar() {
                const sidebar = document.getElementById('sidebar');
                const overlay = document.getElementById('sidebarOverlay');
                const mainWrapper = document.getElementById('mainWrapper');
                const mobileLogo = document.getElementById('mobileLogo');
                
                if (window.innerWidth >= 1024) {
                    sidebar.classList.toggle('lg:translate-x-0');
                    mainWrapper.classList.toggle('lg:mr-72');
                    if(mobileLogo) mobileLogo.classList.toggle('lg:hidden');
                } else {
                    if (sidebar.classList.contains('translate-x-full')) {
                        sidebar.classList.remove('translate-x-full');
                        overlay.classList.remove('hidden');
                        setTimeout(() => overlay.classList.add('opacity-100'), 10);
                    } else {
                        sidebar.classList.add('translate-x-full');
                        overlay.classList.remove('opacity-100');
                        setTimeout(() => overlay.classList.add('hidden'), 300);
                    }
                }
            }

            function toggleMenu(menuId) {
                const allMenus = document.querySelectorAll('div[id^="menu-"]');
                allMenus.forEach(menu => {
                    if (menu.id !== menuId && !menu.classList.contains('hidden')) {
                        menu.classList.add('hidden');
                    }
                });
                document.getElementById(menuId).classList.toggle('hidden');
            }

            document.addEventListener('DOMContentLoaded', function() {
                const currentUrl = window.location.href.split('?')[0];
                const navLinks = document.querySelectorAll('nav a');
                const activeColor = 'text-teal-600';
                const activeBg = 'bg-teal-50';
                
                navLinks.forEach(link => {
                    if (link.href && link.href.split('?')[0] === currentUrl) {
                        link.classList.remove('text-slate-500');
                        link.classList.add(activeColor, 'font-bold');
                        
                        const dropdown = link.closest('div[id^="menu-"]');
                        if (dropdown) {
                            dropdown.classList.remove('hidden');
                            const btn = dropdown.previousElementSibling;
                            if (btn && btn.tagName === 'BUTTON') {
                                btn.classList.remove('text-slate-500');
                                btn.classList.add(activeBg, activeColor, 'font-bold');
                            }
                        }
                    }
                });
            });
        </script>
    @else
        <main class="min-h-screen w-full flex items-center justify-center bg-slate-50 p-4 relative overflow-hidden">
            <!-- Decorative Blobs -->
            <div class="absolute top-[-20%] right-[-10%] w-[50%] h-[50%] rounded-full bg-teal-500/10 blur-[100px] pointer-events-none"></div>
            <div class="absolute bottom-[-20%] left-[-10%] w-[40%] h-[60%] rounded-full bg-emerald-500/10 blur-[100px] pointer-events-none"></div>
            
            <div class="w-full max-w-5xl mx-auto relative z-10">
                @yield('content')
            </div>
        </main>
    @endif
</body>
</html>
