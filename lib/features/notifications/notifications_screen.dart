import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF1F5F9),
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              color: Color(0xFF0F172A),
              size: 26,
            ),
          ),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all read',
              style: GoogleFonts.poppins(
                color: const Color(0xFF3B82F6),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // ── Today Section ──
          Text(
            'Today',
            style: GoogleFonts.poppins(
              color: const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(duration: 300.ms),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildNotificationItem(
                  icon: Iconsax.calendar_tick,
                  iconBgColor: const Color(0xFF10B981).withValues(alpha: 0.1),
                  iconColor: const Color(0xFF10B981),
                  title: 'Appointment Confirmed!',
                  description: 'Your appointment with Dr. Nusrat Jahan is confirmed for tomorrow at 10:00 AM.',
                  time: '1h ago',
                  isUnread: true,
                ),
                _buildDivider(),
                _buildNotificationItem(
                  icon: Iconsax.message,
                  iconBgColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'New Message',
                  description: 'Dr. Ahmad sent you a new message regarding your recent test results.',
                  time: '3h ago',
                  isUnread: true,
                ),
                _buildDivider(),
                _buildNotificationItem(
                  icon: Iconsax.card_pos,
                  iconBgColor: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                  iconColor: const Color(0xFF3B82F6),
                  title: 'Payment Successful',
                  description: 'Your payment of \$45.00 for the consultation has been processed successfully.',
                  time: '5h ago',
                  isUnread: false,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05, end: 0),

          const SizedBox(height: 24),

          // ── Yesterday Section ──
          Text(
            'Yesterday',
            style: GoogleFonts.poppins(
              color: const Color(0xFF64748B),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                _buildNotificationItem(
                  icon: Iconsax.calendar_remove,
                  iconBgColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
                  iconColor: const Color(0xFFEF4444),
                  title: 'Appointment Canceled',
                  description: 'Your appointment with Dr. Sarah has been canceled. Please reschedule.',
                  time: 'Yesterday',
                  isUnread: false,
                ),
                _buildDivider(),
                _buildNotificationItem(
                  icon: Iconsax.security_safe,
                  iconBgColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Security Update',
                  description: 'We have updated our privacy policy. Please review the changes in settings.',
                  time: 'Yesterday',
                  isUnread: false,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.05, end: 0),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
    required bool isUnread,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF0F172A),
                              fontSize: 14,
                              fontWeight: isUnread ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF475569),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Color(0xFFF1F5F9),
        height: 1,
        thickness: 1,
      ),
    );
  }
}
