import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../categories/all_categories_screen.dart';
import '../appointments/all_schedules_screen.dart';
import '../doctors/all_doctors_screen.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../doctors/doctor_details_screen.dart';
import '../notifications/notifications_screen.dart';
import '../lab/lab_order_method_screen.dart';
import '../nursing/nursing_services_screen.dart';
import 'promo_carousel.dart';
import '../records/medical_records_screen.dart';
import '../emergency/sos_screen.dart';
import '../locator/clinic_locator_screen.dart';

import 'dart:convert';
import '../../core/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  List<dynamic> _banners = [];
  List<dynamic> _topDoctors = [];
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  Future<void> _fetchHomeData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final un = prefs.getString('user_name') ?? '';
      final userName = un.isNotEmpty ? un : 'guest_user'.tr();
      
      final response = await ApiClient.get('/home');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _banners = data['banners'] ?? [];
            _topDoctors = data['top_doctors'] ?? [];
            _userName = userName;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _fetchHomeData,
        child: SingleChildScrollView(
        child: Padding(
          // Extra bottom padding for the floating navigation bar
          padding: const EdgeInsetsDirectional.only(bottom: 120),
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
                    decoration: BoxDecoration(
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
                                            color: AppColors.getSurface(
                                              context,
                                            ),
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
                                            '${'hello'.tr()}، $_userName',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.getSurface(
                                                context,
                                              ),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'good_morning'.tr(),
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
                                  // Right Icons (Menu & Notification)
                                  Row(
                                    children: [
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
                                              decoration: BoxDecoration(
                                                color: AppColors.getSurface(
                                                  context,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Iconsax.notification,
                                                color: Color(0xFF0F172A),
                                                size: 22,
                                              ),
                                            ),
                                            PositionedDirectional(
                                              top: 12,
                                              end: 12,
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
                                      const SizedBox(width: 12),
                                      // Menu Icon
                                      GestureDetector(
                                        onTap: () {
                                          Scaffold.of(context).openEndDrawer();
                                        },
                                        child: Container(
                                          width: 46,
                                          height: 46,
                                          decoration: BoxDecoration(
                                            color: AppColors.getSurface(
                                              context,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Iconsax.menu_1,
                                            color: Color(0xFF0F172A),
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                  color: AppColors.getSurface(context),
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
                                padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                  end: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.getSurface(context),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: AppColors.getBorder(context),
                                  ),
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
                                      'search_doctors'.tr(),
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF94A3B8),
                                        fontSize: 15,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3B82F6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Iconsax.microphone,
                                        color: AppColors.getSurface(context),
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

              // ── Banners / Promo Carousel ──
              if (_isLoading)
                const SizedBox(height: 130, child: Center(child: CircularProgressIndicator()))
              else
                PromoCarousel(banners: _banners)
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),


              const SizedBox(height: 32),

              // ── Categories (Grid) ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'categories'.tr(),
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextTitle(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllCategoriesScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'see_all'.tr(),
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
                      'upcoming_appointments'.tr(),
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextTitle(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllSchedulesScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'see_all'.tr(),
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
                child:
                    GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AllSchedulesScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.getSurface(context),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.getBorder(context),
                              ),
                            ),
                            child: Column(
                              children: [
                                // Doctor Info Row
                                Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/doctor1.png',
                                          ),
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
                                            color: AppColors.getTextTitle(
                                              context,
                                            ),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Skin Specialist',
                                          style: GoogleFonts.poppins(
                                            color: AppColors.getTextSubtitle(
                                              context,
                                            ),
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
                                            color: AppColors.getTextSubtitle(
                                              context,
                                            ),
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
                                            color: AppColors.getTextSubtitle(
                                              context,
                                            ),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Actions Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF3B82F6,
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'cancel_appointment'.tr(),
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF3B82F6),
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
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'reschedule'.tr(),
                                            style: GoogleFonts.poppins(
                                              color: AppColors.getSurface(
                                                context,
                                              ),
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
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms, duration: 400.ms)
                        .slideY(begin: 0.2, end: 0),
              ),

              SizedBox(height: 32),

              // ── Top Doctors Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'top_doctors'.tr(),
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextTitle(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllDoctorsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'see_all'.tr(),
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
              if (_topDoctors.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text('No doctors available right now.')),
                )
              else
                ..._topDoctors.map((doc) {
                  final name = doc['user'] != null ? doc['user']['name'] : 'Doctor';
                  final specialty = doc['specialty'] ?? 'Specialist';
                  final rating = doc['rating']?.toString() ?? '5.0';
                  final image = (doc['image_path'] != null)
                      ? 'http://127.0.0.1:8000/storage/${doc['image_path']}'
                      : 'assets/images/doctor1.png';
                  final doctorId = doc['id'];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorDetailsScreen(
                              doctorId: doctorId,
                              name: name,
                              specialty: specialty,
                              image: image,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: AppColors.getSurface(context),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.getBorder(context)),
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
                                    name.replaceFirst(' ', '\n'),
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextTitle(context),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    specialty,
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextSubtitle(context),
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
                                        rating,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.getTextTitle(context),
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
                            PositionedDirectional(
                              end: 0,
                              bottom: 0,
                              child: ClipRRect(
                                borderRadius: const BorderRadiusDirectional.only(
                                  bottomEnd: Radius.circular(24),
                                ),
                                child: doc['image_path'] != null
                                    ? Image.network(
                                        image,
                                        height: 150,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        image,
                                        height: 150,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),

                            // Heart Icon
                            PositionedDirectional(
                              top: 16,
                              end: 16,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
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
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0);
                }),
            ],
          ),
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
          imagePath: 'assets/images/lab.png',
          titleKey: 'cat_lab',
          id: 'lab',
          isActive: true,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/doctor_bag.png',
          titleKey: 'cat_nursing',
          id: 'nursing',
          isActive: true,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/doctor.png',
          titleKey: 'cat_doctor',
          id: 'doctor',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/medicine.png',
          titleKey: 'cat_pharmacy',
          id: 'pharmacy',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/xray.png',
          titleKey: 'cat_xray',
          id: 'xray',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/report.png',
          titleKey: 'cat_news',
          id: 'news',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/add.png',
          titleKey: 'cat_ambulance',
          id: 'ambulance',
          isActive: false,
        ),
        _buildGridCard(
          context,
          imagePath: 'assets/images/apps.png',
          titleKey: 'cat_more',
          id: 'more',
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildGridCard(
    BuildContext context, {
    required String imagePath,
    required String titleKey,
    required String id,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Icon
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(imagePath, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      titleKey.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextTitle(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Description from translations (e.g., desc_doctor)
                    Text(
                      'desc_$id'.tr(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.getTextTitle(context),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Coming soon box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Color(0xFF3B82F6), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'coming_soon_msg'.tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: const Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // OK Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'ok'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          );
        } else {
          if (id == 'lab') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LabOrderMethodScreen(),
              ),
            );
          } else if (id == 'nursing') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NursingServicesScreen(),
              ),
            );
          } else if (id == 'doctor') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllDoctorsScreen()),
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
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                titleKey.tr(),
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
            PositionedDirectional(
              top: -6,
              end: -6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  'coming_soon'.tr(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
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
