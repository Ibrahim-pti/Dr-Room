import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/coming_soon_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'doctor_details_screen.dart';
import '../notifications/notifications_screen.dart';
import '../lab/lab_order_method_screen.dart';
import '../nursing/nursing_services_screen.dart';

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
                    height: 280,
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
                                          builder: (context) =>
                                              const NotificationsScreen(),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Categories (Grid) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ComingSoonScreen(title: 'All Categories')),
                        );
                      },
                      child: Text(
                        'See All',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF3B82F6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 350.ms),

              const SizedBox(height: 16),

              _buildCategoryGrid(
                context,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 32),

              // ── Upcoming Schedule Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Schedule',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ComingSoonScreen(title: 'All Schedules')),
                        );
                      },
                      child: Text(
                        'See All',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF3B82F6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 450.ms),

              const SizedBox(height: 16),


                          // ── Upcoming Appointment Card ──
                          Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
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
                                                'Cancel',
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
                              )
                              .animate()
                              .fadeIn(delay: 300.ms, duration: 400.ms)
                              .slideY(begin: 0.2, end: 0),
              ),

              const SizedBox(height: 32),

              // ── Top Doctors Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Doctors',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF0F172A),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ComingSoonScreen(title: 'All Doctors')),
                        );
                      },
                      child: Text(
                        'See All',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF3B82F6),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 450.ms),

              const SizedBox(height: 16),

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
                ),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.9, // Adjust ratio to reduce vertical space
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _buildGridCard(
          context,
          imagePath: 'assets/images/doctor.png',
          title: 'Doctor',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/medicine.png',
          title: 'Pharmacy',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/lab.png',
          title: 'Lab',
          isActive: true,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/xray.png',
          title: 'X-Ray',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/doctor_bag.png',
          title: 'Nursing',
          isActive: true,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/report.png',
          title: 'Reports',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/apps.png',
          title: 'Specialty',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/add.png',
          title: 'Ambulance',
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildGridCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'ئەم بەشە لە قۆناغی ئامادەکارییە و بەم زووانە دەکەوێتە خزمەتت.',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              backgroundColor: const Color(0xFF0F172A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          if (title == 'Lab') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LabOrderMethodScreen()),
            );
          } else if (title == 'Nursing') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NursingServicesScreen()),
            );
          }
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Opacity(
                    opacity: isActive ? 1.0 : 0.6,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  color: isActive
                      ? const Color(0xFF0F172A)
                      : const Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
          if (!isActive)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Text(
                  'Soon',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF94A3B8),
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
