import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'admin_banners_screen.dart';
import 'admin_articles_screen.dart';
import 'admin_notifications_screen.dart';
import 'admin_appointments_screen.dart';

class AdminMenuScreen extends StatelessWidget {
  const AdminMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'title': 'چاوپێکەوتنەکان',
        'subtitle': 'بەڕێوەبردنی چاوپێکەوتنەکان',
        'icon': Iconsax.calendar_tick,
        'color': const Color(0xFF8B5CF6),
        'screen': const AdminAppointmentsScreen(),
      },
      {
        'title': 'ڕیکلامەکان',
        'subtitle': 'بانەرەکانی ئەپ',
        'icon': Iconsax.picture_frame,
        'color': const Color(0xFF3B82F6),
        'screen': const AdminBannersScreen(),
      },
      {
        'title': 'وتارەکان',
        'subtitle': 'بابەتە تەندروستییەکان',
        'icon': Iconsax.book_1,
        'color': const Color(0xFF10B981),
        'screen': const AdminArticlesScreen(),
      },
      {
        'title': 'ئاگادارکەرەوەکان',
        'subtitle': 'ناردنی نۆتیفیکەیشن',
        'icon': Iconsax.notification,
        'color': const Color(0xFFF59E0B),
        'screen': const AdminNotificationsScreen(),
      },
    ];

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Iconsax.category,
                    color: Color(0xFF8B5CF6),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مێنیو',
                      style: TextStyle(
                        fontFamily: 'Rabar',
                        color: const Color(0xFF1E293B),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'هەڵبژاردەی زیاتر',
                      style: TextStyle(
                        fontFamily: 'Rabar',
                        color: const Color(0xFF64748B),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ).animate().fadeIn().slideY(begin: -0.1, end: 0),
          ),

          // ── Grid Items ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final color = item['color'] as Color;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Directionality(
                          textDirection: TextDirection.rtl,
                          child: item['screen'] as Widget,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: color,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] as String,
                                style: TextStyle(
                                  fontFamily: 'Rabar',
                                  color: const Color(0xFF1E293B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['subtitle'] as String,
                                style: TextStyle(
                                  fontFamily: 'Rabar',
                                  color: const Color(0xFF94A3B8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: const Color(0xFFCBD5E1),
                          size: 18,
                        ),
                      ],
                    ),
                  )
                      .animate(delay: Duration(milliseconds: index * 80))
                      .fadeIn()
                      .slideX(begin: 0.1, end: 0),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
