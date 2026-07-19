@extends('nurse.layouts.app')

@section('content')
<div class="dashboard-container">
    <!-- Welcome Section -->
    <div class="welcome-section">
        <div>
            <h1 class="welcome-title">Dashboard</h1>
            <p class="welcome-subtitle">Welcome back, Nurse {{ explode(' ', $user->name)[0] }}</p>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid">
        <!-- Today's Requests -->
        <div class="stat-card">
            <div class="stat-card-content">
                <div class="stat-number">{{ $todayAppointments ?? 12 }}</div>
                <div class="stat-icon" style="background: #EFF6FF; color: #3B82F6;">
                    <svg width="22" height="22" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
                    </svg>
                </div>
            </div>
            <div class="stat-label">Today's Requests</div>
            <div class="stat-change positive">
                <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                </svg>
                15% from yesterday
            </div>
        </div>

        <!-- Completed -->
        <div class="stat-card">
            <div class="stat-card-content">
                <div class="stat-number">{{ $completedAppointments ?? 8 }}</div>
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
                10% from yesterday
            </div>
        </div>

        <!-- In Progress -->
        <div class="stat-card">
            <div class="stat-card-content">
                <div class="stat-number">{{ $inProgressAppointments ?? 3 }}</div>
                <div class="stat-icon" style="background: #FFF7ED; color: #F97316;">
                    <svg width="22" height="22" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="1.8">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                </div>
            </div>
            <div class="stat-label">In Progress</div>
            <div class="stat-change negative">
                <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2" style="transform: rotate(180deg);">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                </svg>
                2% from yesterday
            </div>
        </div>

        <!-- Rating -->
        <div class="stat-card">
            <div class="stat-card-content">
                <div class="stat-number">{{ number_format($nurse->rating ?? 4.9, 1) }}</div>
                <div class="stat-icon" style="background: #FFFBEB; color: #EAB308;">
                    <svg width="22" height="22" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                    </svg>
                </div>
            </div>
            <div class="stat-label">Rating</div>
            <div class="stat-stars">
                @for($i = 0; $i < 5; $i++)
                    <svg width="14" height="14" fill="{{ $i < round($nurse->rating ?? 4.9) ? '#EAB308' : '#E2E8F0' }}" viewBox="0 0 24 24">
                        <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                    </svg>
                @endfor
            </div>
        </div>
    </div>

    <!-- Main Content Grid -->
    <div class="dashboard-grid">
        <!-- Today's Schedule -->
        <div class="card schedule-card">
            <div class="card-header">
                <h3 class="card-title">Today's Schedule</h3>
                <a href="{{ route('nurse.appointments.index') }}" class="view-all-link">View All</a>
            </div>
            <div class="schedule-list">
                @if(isset($upcomingAppointments) && $upcomingAppointments->count() > 0)
                    @foreach($upcomingAppointments->take(4) as $appointment)
                        <div class="schedule-item">
                            <div class="schedule-time">{{ $appointment->appointment_date->format('h:i A') }}</div>
                            <div class="schedule-info">
                                <div class="schedule-avatar">
                                    @if($appointment->patient->profile_image)
                                        <img src="{{ asset('storage/' . $appointment->patient->profile_image) }}" alt="">
                                    @else
                                        {{ substr($appointment->patient->name, 0, 1) }}
                                    @endif
                                </div>
                                <div>
                                    <div class="schedule-name">{{ $appointment->type == 'online' ? 'Online Care' : 'Home Visit' }}</div>
                                    <div class="schedule-patient">{{ $appointment->patient->name }}</div>
                                </div>
                            </div>
                            <span class="status-badge {{ $appointment->status == 'completed' ? 'completed' : ($appointment->status == 'in_progress' ? 'in-progress' : 'upcoming') }}">
                                {{ ucfirst(str_replace('_', ' ', $appointment->status)) }}
                            </span>
                        </div>
                    @endforeach
                @else
                    <div class="schedule-item">
                        <div class="schedule-time">08:30 AM</div>
                        <div class="schedule-info">
                            <div class="schedule-avatar">A</div>
                            <div>
                                <div class="schedule-name">Blood Test</div>
                                <div class="schedule-patient">Ali Ahmed</div>
                            </div>
                        </div>
                        <span class="status-badge completed">Completed</span>
                    </div>
                    <div class="schedule-item">
                        <div class="schedule-time">10:00 AM</div>
                        <div class="schedule-info">
                            <div class="schedule-avatar" style="background: #FCE7F3; color: #EC4899;">S</div>
                            <div>
                                <div class="schedule-name">Injection (IV)</div>
                                <div class="schedule-patient">Sara Karim</div>
                            </div>
                        </div>
                        <span class="status-badge in-progress">In Progress</span>
                    </div>
                    <div class="schedule-item">
                        <div class="schedule-time">12:00 PM</div>
                        <div class="schedule-info">
                            <div class="schedule-avatar" style="background: #DBEAFE; color: #3B82F6;">H</div>
                            <div>
                                <div class="schedule-name">Dressing</div>
                                <div class="schedule-patient">Hassan Qadir</div>
                            </div>
                        </div>
                        <span class="status-badge upcoming">Upcoming</span>
                    </div>
                    <div class="schedule-item">
                        <div class="schedule-time">02:30 PM</div>
                        <div class="schedule-info">
                            <div class="schedule-avatar" style="background: #FEF3C7; color: #D97706;">Z</div>
                            <div>
                                <div class="schedule-name">Elderly Care</div>
                                <div class="schedule-patient">Zana Othman</div>
                            </div>
                        </div>
                        <span class="status-badge upcoming">Upcoming</span>
                    </div>
                @endif
            </div>
        </div>

        <!-- Earnings Overview -->
        <div class="card earnings-card">
            <div class="card-header">
                <h3 class="card-title">Earnings Overview</h3>
                <select class="chart-select">
                    <option>This Week</option>
                    <option>Last Week</option>
                    <option>This Month</option>
                </select>
            </div>
            <div class="earnings-total">
                <div class="earnings-label">Total Earnings</div>
                <div class="earnings-amount">320,000 <span class="earnings-currency">IQD</span></div>
                <div class="stat-change positive" style="margin-top: 4px;">
                    <svg width="14" height="14" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M5 10l7-7m0 0l7 7m-7-7v18"/>
                    </svg>
                    12% from last week
                </div>
            </div>
            <div class="chart-container">
                <canvas id="earningsChart"></canvas>
            </div>
        </div>

        <!-- Request Status -->
        <div class="card status-card">
            <div class="card-header">
                <h3 class="card-title">Request Status</h3>
            </div>
            <div class="donut-container">
                <canvas id="requestStatusChart"></canvas>
            </div>
            <div class="status-legend">
                <div class="legend-item">
                    <span class="legend-dot" style="background: #3B82F6;"></span>
                    <span class="legend-label">Completed</span>
                    <span class="legend-value">8 (57%)</span>
                </div>
                <div class="legend-item">
                    <span class="legend-dot" style="background: #F97316;"></span>
                    <span class="legend-label">In Progress</span>
                    <span class="legend-value">3 (25%)</span>
                </div>
                <div class="legend-item">
                    <span class="legend-dot" style="background: #EAB308;"></span>
                    <span class="legend-label">Pending</span>
                    <span class="legend-value">1 (8%)</span>
                </div>
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

    .stat-change.positive { color: #22C55E; }
    .stat-change.negative { color: #EF4444; }

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

    .view-all-link:hover { color: #2563EB; }

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

    /* Schedule List */
    .schedule-list {
        padding: 0 22px 22px;
    }

    .schedule-item {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 14px 0;
        border-bottom: 1px solid #F1F5F9;
    }

    .schedule-item:last-child { border-bottom: none; }

    .schedule-time {
        font-size: 12px;
        font-weight: 600;
        color: #64748B;
        min-width: 70px;
    }

    .schedule-info {
        display: flex;
        align-items: center;
        gap: 10px;
        flex: 1;
    }

    .schedule-avatar {
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

    .schedule-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .schedule-name {
        font-size: 13px;
        font-weight: 600;
        color: #1e293b;
    }

    .schedule-patient {
        font-size: 11px;
        color: #94A3B8;
        font-weight: 500;
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        font-size: 11px;
        font-weight: 600;
        padding: 5px 12px;
        border-radius: 20px;
        white-space: nowrap;
    }

    .status-badge.completed { background: #F0FDF4; color: #22C55E; }
    .status-badge.upcoming { background: #EFF6FF; color: #3B82F6; }
    .status-badge.in-progress { background: #FFF7ED; color: #F97316; }
    .status-badge.pending { background: #FFFBEB; color: #EAB308; }

    /* Earnings */
    .earnings-total {
        padding: 0 22px 16px;
    }

    .earnings-label {
        font-size: 12px;
        color: #94A3B8;
        font-weight: 500;
    }

    .earnings-amount {
        font-size: 28px;
        font-weight: 800;
        color: #1e293b;
    }

    .earnings-currency {
        font-size: 16px;
        font-weight: 600;
        color: #94A3B8;
    }

    .chart-container {
        padding: 0 22px 22px;
        height: 200px;
    }

    /* Donut Chart */
    .donut-container {
        padding: 10px 30px;
        height: 180px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .status-legend {
        padding: 0 22px 22px;
    }

    .legend-item {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 6px 0;
    }

    .legend-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        flex-shrink: 0;
    }

    .legend-label {
        font-size: 12px;
        font-weight: 500;
        color: #64748B;
        flex: 1;
    }

    .legend-value {
        font-size: 12px;
        font-weight: 600;
        color: #1e293b;
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

        .stat-card { padding: 16px; }
        .stat-number { font-size: 26px; }
        .welcome-title { font-size: 22px; }
    }
</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Earnings Bar Chart
        const earningsCtx = document.getElementById('earningsChart');
        if (earningsCtx) {
            new Chart(earningsCtx, {
                type: 'bar',
                data: {
                    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                    datasets: [{
                        label: 'Earnings',
                        data: [280000, 350000, 320000, 400000, 380000, 420000, 300000],
                        backgroundColor: [
                            '#3B82F6', '#6366F1', '#3B82F6', '#6366F1', '#3B82F6', '#6366F1', '#3B82F6'
                        ],
                        borderRadius: 8,
                        barPercentage: 0.6,
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
                            ticks: { color: '#94A3B8', font: { size: 11, weight: 500 } }
                        },
                        y: {
                            beginAtZero: true,
                            grid: { color: '#F1F5F9', drawBorder: false },
                            ticks: {
                                color: '#94A3B8',
                                font: { size: 11, weight: 500 },
                                callback: function(value) {
                                    return (value / 1000) + 'K';
                                }
                            }
                        }
                    }
                }
            });
        }

        // Request Status Donut Chart
        const statusCtx = document.getElementById('requestStatusChart');
        if (statusCtx) {
            new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Completed', 'In Progress', 'Pending'],
                    datasets: [{
                        data: [8, 3, 1],
                        backgroundColor: ['#3B82F6', '#F97316', '#EAB308'],
                        borderWidth: 0,
                        cutout: '65%',
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false },
                    },
                }
            });
        }
    });
</script>
@endsection
