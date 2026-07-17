import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'dart:convert';
import '../../core/utils/api_client.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClient.get('/admin/dashboard');
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _stats = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchStats,
          color: const Color(0xFF3B82F6),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                _buildHeader(),
                const SizedBox(height: 24),

                if (_isLoading)
                  _buildLoadingShimmer()
                else ...[
                  // ── Stats Grid ──
                  _buildStatsGrid(),
                  const SizedBox(height: 28),

                  // ── Recent Appointments ──
                  _buildRecentAppointments(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Admin icon
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.dashboard_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'پەنێڵی ئەدمین',
                style: TextStyle(
                  fontFamily: 'Rabar',
                  color: const Color(0xFF1E293B),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'بەڕێوەبردنی سیستم',
                style: TextStyle(
                  fontFamily: 'Rabar',
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0);
  }

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'کۆی بەکارهێنەران',
                value: '${_stats?['total_users'] ?? 0}',
                icon: Iconsax.people,
                color: const Color(0xFF3B82F6),
                delay: 0,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildStatCard(
                label: 'پزیشکی چاوەڕێکراو',
                value: '${_stats?['pending_doctors'] ?? 0}',
                icon: Iconsax.user_search,
                color: const Color(0xFFF59E0B),
                delay: 100,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                label: 'پەرستارەکان',
                value: '${_stats?['total_nurses'] ?? 0}',
                icon: Iconsax.profile_2user,
                color: const Color(0xFFEC4899),
                delay: 200,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildStatCard(
                label: 'چاوپێکەوتنەکان',
                value: '${_stats?['total_appointments'] ?? 0}',
                icon: Iconsax.calendar_1,
                color: const Color(0xFF8B5CF6),
                delay: 300,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Rabar',
              color: const Color(0xFF1E293B),
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Rabar',
              color: const Color(0xFF64748B),
              fontSize: 13,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: delay))
        .fadeIn()
        .slideY(begin: 0.15, end: 0);
  }

  Widget _buildRecentAppointments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'دوایین چاوپێکەوتنەکان',
          style: TextStyle(
            fontFamily: 'Rabar',
            color: const Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ).animate(delay: 400.ms).fadeIn(),
        const SizedBox(height: 14),

        if (_stats?['recent_appointments'] != null &&
            (_stats!['recent_appointments'] as List).isNotEmpty)
          ...((_stats!['recent_appointments'] as List)
              .asMap()
              .entries
              .map((entry) => _buildAppointmentRow(entry.value, entry.key)))
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                Icon(
                  Iconsax.calendar_remove,
                  color: const Color(0xFFCBD5E1),
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  'هیچ چاوپێکەوتنێک نییە',
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    color: const Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ).animate(delay: 400.ms).fadeIn(),
      ],
    );
  }

  Widget _buildAppointmentRow(dynamic appt, int index) {
    final userName = appt['user']?['name'] ?? 'بەکارهێنەر';
    final doctorName =
        (appt['doctor'] != null && appt['doctor']['user'] != null)
            ? appt['doctor']['user']['name']
            : 'پزیشک';
    final status = appt['status'] ?? 'pending';
    final statusColor = status == 'completed'
        ? const Color(0xFF10B981)
        : status == 'cancelled'
            ? const Color(0xFFEF4444)
            : const Color(0xFFF59E0B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Iconsax.calendar_1,
              color: Color(0xFF3B82F6),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    color: const Color(0xFF1E293B),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'د. $doctorName',
                  style: TextStyle(
                    fontFamily: 'Rabar',
                    color: const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status == 'completed'
                  ? 'تەواو'
                  : status == 'cancelled'
                      ? 'هەڵوەشێنراو'
                      : 'چاوەڕێ',
              style: TextStyle(
                fontFamily: 'Rabar',
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 400 + (index * 80)))
        .fadeIn()
        .slideX(begin: 0.1, end: 0);
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(
        4,
        (i) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .shimmer(duration: 1200.ms, color: const Color(0xFFE2E8F0)),
      ),
    );
  }
}
