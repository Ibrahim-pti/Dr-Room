import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'doctor_details_screen.dart';
import '../notifications/notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF0F4FD,
      ), // Very light blue-grey background
      body: SingleChildScrollView(
        child: Padding(
          // Extra bottom padding for the floating navigation bar
          padding: const EdgeInsets.only(bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Section with Blue Background ──
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Blue Gradient Background
                  Container(
                    height: 380,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF3B82F6), // Strong Blue
                          Color(0xFF8BB5F8), // Lighter Blue
                          Color(0xFFE2EAF8), // Fades to background
                        ],
                        stops: [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // Content over background
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          // ── App Bar ──
                          Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // User Avatar
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                              'assets/images/doctor2.png',
                                            ), // placeholder user image
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // User Greeting
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Hi, Sara',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Good morning',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Notification Icon
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const NotificationsScreen(),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 46,
                                          height: 46,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Iconsax.notification,
                                            color: Color(0xFF0F172A),
                                            size: 22,
                                          ),
                                        ),
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Colors.redAccent,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: -0.2, end: 0),

                          const SizedBox(height: 32),

                          // ── Hero Text ──
                          Text(
                                'Your Health Starts With\nThe Right Doctor',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 100.ms, duration: 400.ms)
                              .slideX(begin: -0.1, end: 0),

                          const SizedBox(height: 24),

                          // ── Search Bar ──
                          Container(
                                height: 60,
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Iconsax.search_normal_1,
                                      color: Color(0xFF94A3B8),
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Search your doctor',
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF94A3B8),
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF3B82F6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Iconsax.microphone,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 200.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),

                          const SizedBox(height: 28),

                          // ── Upcoming Appointment Card ──
                          Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF3B82F6,
                                      ).withValues(alpha: 0.1),
                                      blurRadius: 24,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Doctor Info Row
                                    Row(
                                      children: [
                                        Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                'assets/images/doctor1.png',
                                              ), // placeholder
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topCenter,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Dr. Ayesha Rahman',
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFF0F172A),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Skin Specialist',
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFF64748B),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    // Date & Time Row
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Iconsax.calendar_1,
                                              size: 18,
                                              color: Color(0xFF64748B),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '13 Nov, Thursday',
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
                                            const Icon(
                                              Iconsax.clock,
                                              size: 18,
                                              color: Color(0xFF64748B),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '6:30 PM',
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
                                    // Buttons Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Update Time',
                                                style: GoogleFonts.poppins(
                                                  color: const Color(
                                                    0xFF64748B,
                                                  ),
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
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Update Time',
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
                              )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Categories Section ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Choose Category',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 16),

              // Horizontal Scroll Categories
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildCategoryPill('Dermatologist', true),
                    const SizedBox(width: 12),
                    _buildCategoryPill('Dermatologist', false),
                    const SizedBox(width: 12),
                    _buildCategoryPill('Dentist', false),
                  ],
                ),
              ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.2, end: 0),

              const SizedBox(height: 28),

              // ── Doctor List Card ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DoctorDetailsScreen(),
                      ),
                    );
                  },
                  child: Container(
                    height: 160,
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
                  child: Stack(
                    children: [
                      // Text Info on the left
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. Nusrat\nJahan',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF0F172A),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pediatrician Specialist',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontSize: 13,
                              ),
                            ),
                            const Spacer(),
                            // Rating
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Color(0xFFFBBF24),
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '4.9',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF0F172A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Doctor Image on the right
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(24),
                          ),
                          child: Image.asset(
                            'assets/images/doctor3.png',
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Heart Icon
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F4FD),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Color(0xFF3B82F6),
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPill(String title, bool isFirst) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F4FD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFirst ? Iconsax.activity : Iconsax.health,
              color: const Color(0xFF3B82F6),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: const Color(0xFF0F172A),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
