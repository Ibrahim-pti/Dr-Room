@extends('doctor.layouts.app')

@section('content')
<div class="dashboard-container">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <div>
            <h1 class="welcome-title">Dashboard</h1>
            <p class="welcome-subtitle">Welcome back, Dr. {{ explode(' ', $user->name)[0] }}</p>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid">
        <!-- Today's Appointments -->
        <div class="stat-card">
            <div class="stat-card-content">
                <div class="stat-number">{{ $todayAppointments ?? 24 }}</div>
                <div class="stat-icon" style="background: #EFF6FF; color: #3B82F6;">
                    <svg width="22" height="22" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                    </svg>
                </div>
            </div>
            <div class="stat-label">Today's Appointments</div>
            <div class="stat-change positive">
                <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                </svg>
                12% from yesterday
            </div>
        </div>

        <!-- Completed -->
        <div class="stat-card">
            <div class="stat-card-content">
                <div class="stat-number">{{ $completedAppointments ?? 18 }}</div>
                <div class="stat-icon" style="background: #F0FDF4; color: #22C55E;">
                    <svg width="22" height="22" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
            </div>
            <div class="stat-label">Completed</div>
            <div class="stat-change positive">
                <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                </svg>
                8% from yesterday
            </div>
        </div>

        <!-- Pending -->
        <div class="stat-card">
            <div class="stat-card-content">
                <div class="stat-number">{{ $pendingAppointments ?? 6 }}</div>
                <div class="stat-icon" style="background: #FFF7ED; color: #F97316;">
                    <svg width="22" height="22" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
            </div>
            <div class="stat-label">Pending</div>
            <div class="stat-change negative">
                <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2" style="transform: rotate(180deg);">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                </svg>
                4% from yesterday
            </div>
        </div>

        <!-- Rating -->
        <div class="stat-card">
            <div class="stat-card-content">
                <div class="stat-number">{{ number_format($doctor->rating ?? 4.8, 1) }}</div>
                <div class="stat-icon" style="background: #FFFBEB; color: #EAB308;">
                    <svg width="22" height="22" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                    </svg>
                </div>
            </div>
            <div class="stat-label">Rating</div>
            <div class="stat-stars">
                @for($i = 0; $i < 5; $i++)
                    <svg width="14" height="14" fill="{{ $i < round($doctor->rating ?? 4.8) ? '#EAB308' : '#E2E8F0' }}" viewBox="0 0 24 24">
                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                    </svg>
                @endfor
            </div>
        </div>
    </div>

    <!-- Main Content Grid -->
    <div class="dashboard-grid">
        <!-- Today's Appointments List -->
        <div class="card appointments-card">
            <div class="card-header">
                <h3 class="card-title">Today's Appointments</h3>
                <a href="{{ route('doctor.appointments.index') }}" class="view-all-link">View All</a>
            </div>
            <div class="appointments-list">
                @if(isset($upcomingAppointments) && $upcomingAppointments->count() > 0)
                    @foreach($upcomingAppointments->take(4) as $appointment)
                        <div class="appointment-item">
                            <div class="appointment-time">{{ $appointment->appointment_date->format('h:i A') }}</div>
                            <div class="appointment-info">
                                <div class="appointment-avatar">
                                    @if($appointment->patient->profile_image)
                                        <img src="{{ asset('storage/' . $appointment->patient->profile_image) }}" alt="">
                                    @else
                                        {{ substr($appointment->patient->name, 0, 1) }}
                                    @endif
                                </div>
                                <div>
                                    <div class="appointment-name">{{ $appointment->patient->name }}</div>
                                    <div class="appointment-type">{{ $appointment->type == 'online' ? 'Online Consultation' : 'Follow-up' }}</div>
                                </div>
                            </div>
                            <span class="status-badge {{ $appointment->status == 'completed' ? 'completed' : ($appointment->status == 'pending' ? 'pending' : 'upcoming') }}">
                                {{ ucfirst($appointment->status) }}
                                <svg width="12" height="12" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/>
                                </svg>
                            </span>
                        </div>
                    @endforeach
                @else
                    <div class="appointment-item">
                        <div class="appointment-time">09:00 AM</div>
                        <div class="appointment-info">
                            <div class="appointment-avatar">A</div>
                            <div>
                                <div class="appointment-name">Ali Ahmed</div>
                                <div class="appointment-type">Online Consultation</div>
                            </div>
                        </div>
                        <span class="status-badge completed">Completed <svg width="12" height="12" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/></svg></span>
                    </div>
                    <div class="appointment-item">
                        <div class="appointment-time">10:30 AM</div>
                        <div class="appointment-info">
                            <div class="appointment-avatar" style="background: #FCE7F3; color: #EC4899;">S</div>
                            <div>
                                <div class="appointment-name">Sara Karim</div>
                                <div class="appointment-type">Follow-up</div>
                            </div>
                        </div>
                        <span class="status-badge upcoming">Upcoming <svg width="12" height="12" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/></svg></span>
                    </div>
                    <div class="appointment-item">
                        <div class="appointment-time">11:30 AM</div>
                        <div class="appointment-info">
                            <div class="appointment-avatar" style="background: #DBEAFE; color: #3B82F6;">H</div>
                            <div>
                                <div class="appointment-name">Hassan Qadir</div>
                                <div class="appointment-type">Online Consultation</div>
                            </div>
                        </div>
                        <span class="status-badge upcoming">Upcoming <svg width="12" height="12" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/></svg></span>
                    </div>
                    <div class="appointment-item">
                        <div class="appointment-time">01:00 PM</div>
                        <div class="appointment-info">
                            <div class="appointment-avatar" style="background: #FEF3C7; color: #D97706;">Z</div>
                            <div>
                                <div class="appointment-name">Zana Othman</div>
                                <div class="appointment-type">Follow-up</div>
                            </div>
                        </div>
                        <span class="status-badge pending">Pending <svg width="12" height="12" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"/></svg></span>
                    </div>
                @endif
            </div>
        </div>

        <!-- Appointments Overview Chart -->
        <div class="card chart-card">
            <div class="card-header">
                <h3 class="card-title">Appointments Overview</h3>
                <select class="chart-select">
                    <option>This Week</option>
                    <option>Last Week</option>
                    <option>This Month</option>
                </select>
            </div>
            <div class="chart-container">
                <canvas id="appointmentsChart"></canvas>
            </div>
        </div>

        <!-- Recent Patients -->
        <div class="card patients-card">
            <div class="card-header">
                <h3 class="card-title">Recent Patients</h3>
                <a href="{{ route('doctor.patients.index') }}" class="view-all-link">View All</a>
            </div>
            <div class="patients-list">
                @if(isset($recentPatients) && count($recentPatients) > 0)
                    @foreach($recentPatients as $patient)
                        <div class="patient-item">
                            <div class="patient-avatar">
                                @if($patient->profile_image)
                                    <img src="{{ asset('storage/' . $patient->profile_image) }}" alt="">
                                @else
                                    {{ substr($patient->name, 0, 1) }}
                                @endif
                            </div>
                            <div class="patient-info">
                                <div class="patient-name">{{ $patient->name }}</div>
                                <div class="patient-detail">{{ $patient->gender ?? 'Male' }}, {{ $patient->age ?? '30' }}</div>
                            </div>
                            <div class="patient-date">Today</div>
                        </div>
                    @endforeach
                @else
                    <div class="patient-item">
                        <div class="patient-avatar">A</div>
                        <div class="patient-info">
                            <div class="patient-name">Ali Ahmed</div>
                            <div class="patient-detail">Male, 38</div>
                        </div>
                        <div class="patient-date">Today</div>
                    </div>
                    <div class="patient-item">
                        <div class="patient-avatar" style="background: #FCE7F3; color: #EC4899;">S</div>
                        <div class="patient-info">
                            <div class="patient-name">Sara Karim</div>
                            <div class="patient-detail">Female, 35</div>
                        </div>
                        <div class="patient-date">Today</div>
                    </div>
                    <div class="patient-item">
                        <div class="patient-avatar" style="background: #DBEAFE; color: #3B82F6;">H</div>
                        <div class="patient-info">
                            <div class="patient-name">Hassan Qadir</div>
                            <div class="patient-detail">Male, 42</div>
                        </div>
                        <div class="patient-date">Yesterday</div>
                    </div>
                    <div class="patient-item">
                        <div class="patient-avatar" style="background: #FEF3C7; color: #D97706;">Z</div>
                        <div class="patient-info">
                            <div class="patient-name">Zana Othman</div>
                            <div class="patient-detail">Female, 29</div>
                        </div>
                        <div class="patient-date">Yesterday</div>
                    </div>
                @endif
            </div>
        </div>
    </div>
</div>

<style>
    .dashboard-container {
        animation: fadeIn 0.5s ease-out;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(15px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .welcome-section {
        margin-bottom: 28px;
    }

    .welcome-title {
        font-size: 26px;
        font-weight: 800;
        color: #1e293b;
        margin-bottom: 4px;
    }

    .welcome-subtitle {
        font-size: 14px;
        color: #94A3B8;
        font-weight: 500;
    }

    /* Stats Grid */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
        margin-bottom: 28px;
    }

    .stat-card {
        background: #fff;
        border-radius: 16px;
        padding: 22px;
        border: 1px solid #E2E8F0;
        transition: all 0.3s;
    }

    .stat-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 30px rgba(0,0,0,0.06);
    }

    .stat-card-content {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 8px;
    }

    .stat-number {
        font-size: 32px;
        font-weight: 800;
        color: #1e293b;
        line-height: 1;
    }

    .stat-icon {
        width: 44px;
        height: 44px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .stat-label {
        font-size: 13px;
        color: #94A3B8;
        font-weight: 500;
        margin-bottom: 8px;
    }

    .stat-change {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 12px;
        font-weight: 600;
    }

    .stat-change.positive {
        color: #22C55E;
    }

    .stat-change.negative {
        color: #EF4444;
    }

    .stat-stars {
        display: flex;
        gap: 2px;
    }

    /* Dashboard Grid */
    .dashboard-grid {
        display: grid;
        grid-template-columns: 1fr 1.2fr 0.8fr;
        gap: 20px;
    }

    .card {
        background: #fff;
        border-radius: 16px;
        border: 1px solid #E2E8F0;
        overflow: hidden;
    }

    .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 22px 16px;
    }

    .card-title {
        font-size: 16px;
        font-weight: 700;
        color: #1e293b;
    }

    .view-all-link {
        font-size: 13px;
        font-weight: 600;
        color: #3B82F6;
        text-decoration: none;
        transition: color 0.2s;
    }

    .view-all-link:hover {
        color: #2563EB;
    }

    .chart-select {
        padding: 6px 12px;
        border: 1px solid #E2E8F0;
        border-radius: 8px;
        font-size: 12px;
        font-weight: 500;
        color: #64748B;
        background: #fff;
        cursor: pointer;
        outline: none;
    }

    /* Appointments List */
    .appointments-list {
        padding: 0 22px 22px;
    }

    .appointment-item {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 14px 0;
        border-bottom: 1px solid #F1F5F9;
    }

    .appointment-item:last-child {
        border-bottom: none;
    }

    .appointment-time {
        font-size: 12px;
        font-weight: 600;
        color: #64748B;
        min-width: 70px;
    }

    .appointment-info {
        display: flex;
        align-items: center;
        gap: 10px;
        flex: 1;
    }

    .appointment-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background: #E0E7FF;
        color: #6366F1;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 14px;
        overflow: hidden;
        flex-shrink: 0;
    }

    .appointment-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .appointment-name {
        font-size: 13px;
        font-weight: 600;
        color: #1e293b;
    }

    .appointment-type {
        font-size: 11px;
        color: #94A3B8;
        font-weight: 500;
    }

    .status-badge {
        display: flex;
        align-items: center;
        gap: 4px;
        font-size: 11px;
        font-weight: 600;
        padding: 5px 12px;
        border-radius: 20px;
        white-space: nowrap;
    }

    .status-badge.completed {
        background: #F0FDF4;
        color: #22C55E;
    }

    .status-badge.upcoming {
        background: #EFF6FF;
        color: #3B82F6;
    }

    .status-badge.pending {
        background: #FFFBEB;
        color: #EAB308;
    }

    /* Chart */
    .chart-container {
        padding: 0 22px 22px;
        height: 250px;
    }

    /* Patients List */
    .patients-list {
        padding: 0 22px 22px;
    }

    .patient-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 0;
        border-bottom: 1px solid #F1F5F9;
    }

    .patient-item:last-child {
        border-bottom: none;
    }

    .patient-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: #E0E7FF;
        color: #6366F1;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 15px;
        overflow: hidden;
        flex-shrink: 0;
    }

    .patient-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .patient-info {
        flex: 1;
    }

    .patient-name {
        font-size: 13px;
        font-weight: 600;
        color: #1e293b;
    }

    .patient-detail {
        font-size: 11px;
        color: #94A3B8;
        font-weight: 500;
    }

    .patient-date {
        font-size: 11px;
        color: #94A3B8;
        font-weight: 500;
    }

    /* Responsive */
    @media (max-width: 1200px) {
        .stats-grid {
            grid-template-columns: repeat(2, 1fr);
        }
        .dashboard-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 640px) {
        .stats-grid {
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .stat-card {
            padding: 16px;
        }

        .stat-number {
            font-size: 26px;
        }

        .welcome-title {
            font-size: 22px;
        }
    }
</style>

<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('appointmentsChart');
        if (ctx) {
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    datasets: [{
                        label: 'Appointments',
                        data: [15, 22, 18, 25, 30, 35, 28],
                        borderColor: '#3B82F6',
                        backgroundColor: 'rgba(59, 130, 246, 0.08)',
                        borderWidth: 2.5,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: '#3B82F6',
                        pointBorderColor: '#fff',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: { color: '#94A3B8', font: { size: 12, weight: 500 } }
                        },
                        y: {
                            beginAtZero: true,
                            grid: { color: '#F1F5F9', drawBorder: false },
                            ticks: { color: '#94A3B8', font: { size: 12, weight: 500 } }
                        }
                    }
                }
            });
        }
    });
</script>
@endsection
