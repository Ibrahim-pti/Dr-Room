<!DOCTYPE html>
<html lang="ckb" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DrRoom - Lab Dashboard</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    <style>
        body { font-family: 'Rabar', 'Inter', sans-serif; background-color: #F8FAFC; }
        ::-webkit-scrollbar { width: 6px; height: 6px; }
        ::-webkit-scrollbar-track { background: transparent; }
        ::-webkit-scrollbar-thumb { background: #A78BFA; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #8B5CF6; }
        
        .glass-panel {
            background: rgba(255, 255, 255, 0.7);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        .sidebar-transition { transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); }
    </style>
</head>
<body class="text-slate-800 antialiased overflow-x-hidden selection:bg-indigo-100 selection:text-indigo-900">

    @if(!request()->routeIs('staff.login') && !request()->routeIs('staff.register'))
        <!-- Mobile Overlay -->
        <div id="sidebarOverlay" class="fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-40 hidden lg:hidden transition-opacity" onclick="toggleSidebar()"></div>

        <!-- Sidebar -->
        <aside id="sidebar" class="sidebar-transition fixed top-0 right-0 h-screen w-72 bg-white/80 backdrop-blur-xl border-l border-slate-200/60 z-50 flex flex-col translate-x-full lg:translate-x-0 shadow-2xl lg:shadow-none">
            <!-- Logo -->
            <div class="h-20 flex items-center gap-3 px-8 border-b border-slate-100/80">
                <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center text-white shadow-lg shadow-indigo-500/20">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/></svg>
                </div>
                <span class="text-2xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-slate-800 to-slate-600">DrRoom</span>
            </div>

            <!-- Navigation -->
            <nav class="flex-1 overflow-y-auto py-6 px-4 space-y-2">
                <!-- Dashboard -->
                <a href="{{ route('lab.dashboard') }}" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 {{ request()->routeIs('lab.dashboard') ? 'bg-indigo-50 text-indigo-600 font-bold shadow-sm' : 'text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium' }}">
                    <svg class="w-5 h-5 {{ request()->routeIs('lab.dashboard') ? 'text-indigo-600' : 'text-slate-400' }}" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"/></svg>
                    داشبۆرد
                </a>

                <!-- Test Requests Dropdown -->
                <div>
                    <button type="button" onclick="document.getElementById('menu-test-requests').classList.toggle('hidden')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/></svg>
                            جۆرەکانی پشکنین
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-test-requests" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('lab.tests.blood') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">پشکنینی خوێن</a>
                        <a href="{{ route('lab.tests.urine') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">پشکنینی میز</a>
                        <a href="{{ route('lab.tests.hormone') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">پشکنینی هۆرمۆن</a>
                        <a href="{{ route('lab.tests.other') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">پشکنینەکانی تر</a>
                    </div>
                </div>

                <!-- Test Management Dropdown -->
                <div>
                    <button type="button" onclick="document.getElementById('menu-test-management').classList.toggle('hidden')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                            بەڕێوەبردنی پشکنین
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-test-management" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('lab.patients.index') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">داواکارییەکان</a>
                        <a href="{{ route('lab.management.approve') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">پەسەندکردن</a>
                        <a href="{{ route('lab.management.complete') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">تەواوکردن</a>
                    </div>
                </div>

                <!-- Results Dropdown -->
                <div>
                    <button type="button" onclick="document.getElementById('menu-results').classList.toggle('hidden')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/></svg>
                            ئەنجامەکان
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-results" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('lab.results.add') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">زیادکردنی ئەنجام</a>
                        <a href="{{ route('lab.results.edit') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">گۆڕانکاری</a>
                        <a href="{{ route('lab.results.upload') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">بەرزکردنەوەی PDF</a>
                    </div>
                </div>

                <!-- Reports -->
                <a href="{{ route('lab.reports.index') }}" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                    <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                    ڕاپۆرتەکان
                </a>

                <!-- Communication -->
                <a href="{{ route('lab.communication.index') }}" class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                    <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/></svg>
                    پەیوەندی
                </a>

                <!-- Profile Dropdown -->
                <div>
                    <button type="button" onclick="document.getElementById('menu-lab-profile').classList.toggle('hidden')" class="w-full flex items-center justify-between px-4 py-3 rounded-xl transition-all duration-200 text-slate-500 hover:bg-slate-50 hover:text-slate-900 font-medium">
                        <div class="flex items-center gap-3">
                            <svg class="w-5 h-5 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                            پرۆفایل
                        </div>
                        <svg class="w-4 h-4 text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div id="menu-lab-profile" class="hidden pr-12 pl-4 py-2 space-y-1">
                        <a href="{{ route('lab.profile.index') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">زانیاری تاقیگە</a>
                        <a href="{{ route('lab.profile.staff') }}" class="block text-sm text-slate-500 hover:text-indigo-600 hover:font-bold py-1.5 transition-all">ستافی تاقیگە</a>
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
                        <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-indigo-500 to-violet-500 flex items-center justify-center text-white">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/></svg>
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
                            <div class="text-sm font-bold text-slate-800">تاقیگەی {{ explode(' ', Auth::user()->name)[0] }}</div>
                            <div class="text-xs font-medium text-slate-500">سەرپەرشتیار</div>
                        </div>
                        <div class="w-10 h-10 rounded-full bg-gradient-to-br from-indigo-100 to-violet-100 border-2 border-white shadow-sm flex items-center justify-center overflow-hidden">
                            @if(Auth::user()->lab && Auth::user()->lab->profile_image)
                                <img src="{{ asset('storage/' . Auth::user()->lab->profile_image) }}" alt="Profile" class="w-full h-full object-cover">
                            @else
                                <span class="text-indigo-600 font-bold text-lg">{{ mb_substr(Auth::user()->name, 0, 1) }}</span>
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

            document.addEventListener('DOMContentLoaded', function() {
                const currentUrl = window.location.href.split('?')[0];
                const navLinks = document.querySelectorAll('nav a');
                const activeColor = 'text-indigo-600';
                const activeBg = 'bg-indigo-50';
                
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
            <div class="absolute top-[-20%] right-[-10%] w-[50%] h-[50%] rounded-full bg-indigo-500/10 blur-[100px] pointer-events-none"></div>
            <div class="absolute bottom-[-20%] left-[-10%] w-[40%] h-[60%] rounded-full bg-violet-500/10 blur-[100px] pointer-events-none"></div>
            
            <div class="w-full max-w-5xl mx-auto relative z-10">
                @yield('content')
            </div>
        </main>
    @endif
</body>
</html>
