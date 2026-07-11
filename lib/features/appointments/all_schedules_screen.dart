import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AllSchedulesScreen extends StatelessWidget {
  const AllSchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = [
      {
        'doctor': 'Dr. Ayesha Rahman',
        'specialty': 'Skin Specialist',
        'date': '13 Nov, Thursday',
        'time': '6:30 PM',
        'image': 'assets/images/doctor1.png',
        'status': 'Upcoming',
      },
      {
        'doctor': 'Dr. Sarah Lee',
        'specialty': 'Dentist',
        'date': '15 Nov, Saturday',
        'time': '10:00 AM',
        'image': 'assets/images/doctor2.png',
        'status': 'Upcoming',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'All Schedules',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final s = schedules[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(s['image']!),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s['doctor']!,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF0F172A),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              s['specialty']!,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          s['status']!,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF3B82F6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Iconsax.calendar_1, size: 18, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(
                            s['date']!,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          const Icon(Iconsax.clock, size: 18, color: Color(0xFF64748B)),
                          const SizedBox(width: 8),
                          Text(
                            s['time']!,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              'Reschedule',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }
}
