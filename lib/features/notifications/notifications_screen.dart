import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Nurse is arriving soon!',
        'message': 'Your nurse for the CBC test is 15 minutes away.',
        'time': 'Just now',
        'type': 'order',
        'isRead': false,
      },
      {
        'title': 'Lab Results Ready',
        'message': 'Good news! Your Vitamin D test results are available to download.',
        'time': '2 hours ago',
        'type': 'result',
        'isRead': false,
      },
      {
        'title': 'Appointment Confirmed',
        'message': 'Your video consultation with Dr. Jenny is set for tomorrow at 10:30 AM.',
        'time': 'Yesterday',
        'type': 'calendar',
        'isRead': true,
      },
      {
        'title': 'Special Offer 🎁',
        'message': 'Get 20% off on all comprehensive health checkups this weekend!',
        'time': '2 days ago',
        'type': 'promo',
        'isRead': true,
      },
      {
        'title': 'Order Completed',
        'message': 'Your recent Home Nursing visit has been completed successfully.',
        'time': '3 days ago',
        'type': 'success',
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppColors.getTextTitle(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: AppColors.getTextTitle(context),
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final type = notif['type'] as String;
          final isRead = notif['isRead'] as bool;

          IconData icon;
          Color iconColor;
          Color bgColor;

          switch (type) {
            case 'order':
              icon = Iconsax.truck;
              iconColor = const Color(0xFFF59E0B);
              bgColor = const Color(0xFFF59E0B).withValues(alpha: 0.1);
              break;
            case 'result':
              icon = Iconsax.document_text;
              iconColor = const Color(0xFF3B82F6);
              bgColor = const Color(0xFF3B82F6).withValues(alpha: 0.1);
              break;
            case 'calendar':
              icon = Iconsax.calendar_1;
              iconColor = const Color(0xFF8B5CF6);
              bgColor = const Color(0xFF8B5CF6).withValues(alpha: 0.1);
              break;
            case 'promo':
              icon = Iconsax.ticket_discount;
              iconColor = const Color(0xFFEC4899);
              bgColor = const Color(0xFFEC4899).withValues(alpha: 0.1);
              break;
            case 'success':
              icon = Iconsax.tick_circle;
              iconColor = const Color(0xFF10B981);
              bgColor = const Color(0xFF10B981).withValues(alpha: 0.1);
              break;
            default:
              icon = Iconsax.notification;
              iconColor = const Color(0xFF64748B);
              bgColor = const Color(0xFF64748B).withValues(alpha: 0.1);
          }

          return Container(
            color: isRead ? Colors.transparent : const Color(0xFF3B82F6).withValues(alpha: 0.05),
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  notif['title'] as String,
                                  style: GoogleFonts.poppins(
                                    color: AppColors.getTextTitle(context),
                                    fontSize: 16,
                                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (!isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(top: 6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3B82F6),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notif['message'] as String,
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextSubtitle(context),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            notif['time'] as String,
                            style: GoogleFonts.poppins(
                              color: AppColors.textLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.1, end: 0);
        },
      ),
    );
  }
}
