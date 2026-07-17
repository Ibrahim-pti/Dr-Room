import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'dart:convert';
import '../../core/utils/api_client.dart';

class AdminAppointmentsScreen extends StatefulWidget {
  const AdminAppointmentsScreen({super.key});

  @override
  State<AdminAppointmentsScreen> createState() =>
      _AdminAppointmentsScreenState();
}

class _AdminAppointmentsScreenState extends State<AdminAppointmentsScreen> {
  List<dynamic> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClient.get('/admin/appointments');
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _appointments = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'cancelled':
        return const Color(0xFFEF4444);
      case 'confirmed':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Iconsax.calendar_tick,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'چاوپێکەوتنەکان',
                      style: TextStyle(
                        color: const Color(0xFF1E293B),
                        fontFamily: 'Rabar',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_appointments.length} total',
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontFamily: 'Rabar',
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: _fetchAppointments,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFF94A3B8),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn().slideY(begin: -0.1, end: 0),
          ),

          // List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                  )
                : _appointments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Iconsax.calendar_remove,
                          color: Color(0xFFE2E8F0),
                          size: 56,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No appointments yet',
                          style: TextStyle(
                            color: const Color(0xFF64748B),
                            fontFamily: 'Rabar',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchAppointments,
                    color: const Color(0xFF3B82F6),
                    backgroundColor: Colors.white,
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
                      itemCount: _appointments.length,
                      itemBuilder: (context, index) {
                        final appt = _appointments[index];
                        final userName = appt['user'] != null
                            ? appt['user']['name']
                            : 'Patient';
                        final doctorName =
                            (appt['doctor'] != null &&
                                appt['doctor']['user'] != null)
                            ? appt['doctor']['user']['name']
                            : 'Doctor';
                        final status = appt['status'] ?? 'pending';
                        final date = appt['appointment_date'] ?? '';
                        final time = appt['appointment_time'] ?? '';
                        final statusColor = _statusColor(status);

                        return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      Iconsax.calendar_1,
                                      color: statusColor,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          style: TextStyle(
                                            color: const Color(0xFF1E293B),
                                            fontFamily: 'Rabar',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Dr. $doctorName',
                                          style: TextStyle(
                                            color: const Color(0xFF64748B),
                                            fontFamily: 'Rabar',
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (date.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Iconsax.clock,
                                                size: 12,
                                                color: Color(0xFF475569),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '$date${time.isNotEmpty ? ' • $time' : ''}',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF475569,
                                                  ),
                                                  fontFamily: 'Rabar',
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontFamily: 'Rabar',
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate(delay: Duration(milliseconds: index * 60))
                            .fadeIn()
                            .slideX(begin: 0.05, end: 0);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
