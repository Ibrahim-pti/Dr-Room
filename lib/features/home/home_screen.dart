import 'package:dr_room/features/nursing/nursing_services_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../categories/all_categories_screen.dart';
import '../appointments/all_schedules_screen.dart';
import '../doctors/all_doctors_screen.dart';
import '../pharmacy/screens/pharmacies_screen.dart';
import '../pharmacy/screens/pharmacy_detail_screen.dart';
import '../pharmacy/models/pharmacy_model.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../doctors/doctor_details_screen.dart';
import '../notifications/notifications_screen.dart';
import '../lab/lab_order_method_screen.dart';
import '../lab/all_labs_screen.dart';
import 'promo_carousel.dart';
import '../records/medical_records_screen.dart';
import '../emergency/sos_screen.dart';
import '../lab/lab_details_screen.dart';
import '../search/global_search_screen.dart';

import 'dart:convert';
import '../../core/utils/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pharmacy/providers/cart_provider.dart';
import '../pharmacy/screens/cart_screen.dart';
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
  List<dynamic> _topPharmacies = [];
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
            _topDoctors = [
              {
                'id': 1,
                'user': {'name': 'Dr. Sara Ahmed'},
                'specialty': 'Cardiologist',
                'rating': '4.9',
                'reviews': '120+ Reviews',
                'image_path': null,
              },
              {
                'id': 2,
                'user': {'name': 'Dr. Hekmat Jalal'},
                'specialty': 'Dermatologist',
                'rating': '4.8',
                'reviews': '98+ Reviews',
                'image_path': null,
              },
              {
                'id': 3,
                'user': {'name': 'Dr. Ava Karim'},
                'specialty': 'General Physician',
                'rating': '4.8',
                'reviews': '76+ Reviews',
                'image_path': null,
              },
              {
                'id': 4,
                'user': {'name': 'Dr. Roni Yousif'},
                'specialty': 'Pediatrician',
                'rating': '4.7',
                'reviews': '60+ Reviews',
                'image_path': null,
              },
            ];
            _topPharmacies = data['top_pharmacies'] ?? [];
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
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
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
                                        // Cart Icon
                                        Consumer(
                                          builder: (context, ref, child) {
                                            final cartState = ref.watch(
                                              cartProvider,
                                            );
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CartScreen(),
                                                  ),
                                                );
                                              },
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.2,
                                                          ),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(
                                                      Iconsax.shopping_cart,
                                                      color: Colors.white,
                                                      size: 22,
                                                    ),
                                                  ),
                                                  if (cartState.totalItems > 0)
                                                    PositionedDirectional(
                                                      top: 8,
                                                      end: 8,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              4,
                                                            ),
                                                        decoration:
                                                            const BoxDecoration(
                                                              color: Colors
                                                                  .redAccent,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                        child: Text(
                                                          cartState.totalItems
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
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
                                                width: 44,
                                                height: 44,
                                                decoration: BoxDecoration(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.2),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Iconsax.notification,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                              ),
                                              PositionedDirectional(
                                                top: 12,
                                                end: 12,
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.redAccent,
                                                        shape: BoxShape.circle,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Menu Icon
                                        GestureDetector(
                                          onTap: () {
                                            Scaffold.of(
                                              context,
                                            ).openEndDrawer();
                                          },
                                          child: Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: 0.2,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Iconsax.menu_1,
                                              color: Colors.white,
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
                            GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const GlobalSearchScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 60,
                                    padding: const EdgeInsetsDirectional.only(
                                      start: 20,
                                      end: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.getSurface(context),
                                      borderRadius: BorderRadius.circular(30),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.08,
                                          ),
                                          blurRadius: 24,
                                          offset: const Offset(0, 12),
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
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF3B82F6),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Iconsax.microphone,
                                                color: AppColors.getSurface(
                                                  context,
                                                ),
                                                size: 20,
                                              ),
                                            )
                                            .animate(
                                              onPlay: (controller) =>
                                                  controller.repeat(),
                                            )
                                            .shimmer(
                                              duration: 2000.ms,
                                              color: Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                            ),
                                      ],
                                    ),
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
                  const SizedBox(
                    height: 130,
                    child: Center(child: CircularProgressIndicator()),
                  )
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
                    child: Center(
                      child: Text('No doctors available right now.'),
                    ),
                  )
                else
                  SizedBox(
                    height: 220, // Smaller height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _topDoctors.length,
                      itemBuilder: (context, index) {
                        final doc = _topDoctors[index];
                        final name = doc['user'] != null
                            ? doc['user']['name']
                            : 'Doctor';
                        final specialty = doc['specialty'] ?? 'Specialist';
                        final rating = doc['rating']?.toString() ?? '4.8';
                        final reviews =
                            doc['reviews']?.toString() ?? '120+ Reviews';
                            
                        final fallbackImages = [
                          'assets/images/doctor1.png',
                          'assets/images/doctor2.png',
                          'assets/images/doctor3.png',
                          'assets/images/doctor.png',
                        ];
                        final fallbackImage = fallbackImages[index % fallbackImages.length];

                        final image = (doc['image_path'] != null)
                            ? '${ApiClient.storageUrl}/${doc['image_path']}'
                            : fallbackImage;
                        final doctorId = doc['id'];

                        return GestureDetector(
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
                                width: 145, // Smaller width
                                margin: const EdgeInsetsDirectional.only(
                                  end: 14,
                                  bottom: 12,
                                  top: 4,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ), // Transparent effect
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(
                                              10,
                                            ), // Smaller padding
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Image
                                                Container(
                                                  width: 70, // Smaller image
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: const Color(
                                                      0xFFF8FAFC,
                                                    ),
                                                    image: doc['image_path'] != null
                                                    ? DecorationImage(
                                                        image: NetworkImage(image),
                                                        fit: BoxFit.cover,
                                                        alignment: Alignment.topCenter,
                                                      )
                                                    : DecorationImage(
                                                        image: AssetImage(image),
                                                        fit: BoxFit.cover,
                                                        alignment: Alignment.topCenter,
                                                      ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                // Name
                                                Text(
                                                  name,
                                                  style: GoogleFonts.poppins(
                                                    color: const Color(
                                                      0xFF1E293B,
                                                    ),
                                                    fontSize:
                                                        13, // Smaller font
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 2),
                                                // Specialty
                                                Text(
                                                  specialty,
                                                  style: GoogleFonts.poppins(
                                                    color: const Color(
                                                      0xFF64748B,
                                                    ),
                                                    fontSize:
                                                        11, // Smaller font
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 6),
                                                // Rating Row
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.star_rounded,
                                                      color: Color(0xFFF59E0B),
                                                      size: 12,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      rating,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: const Color(
                                                              0xFF1E293B,
                                                            ),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      reviews,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: const Color(
                                                              0xFF94A3B8,
                                                            ),
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                const Spacer(),
                                                // Book Now Button
                                                Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFEFF6FF,
                                                    ).withValues(alpha: 0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    'Book Now',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                        0xFF3B82F6,
                                                      ),
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Favorite Icon (Top Right)
                                          PositionedDirectional(
                                            top: 10,
                                            end: 10,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.favorite_border_rounded,
                                                color: Color(0xFF3B82F6),
                                                size: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: (500 + (index * 100)).ms)
                            .slideX(begin: 0.1, end: 0);
                      },
                    ),
                  ),

                const SizedBox(height: 32),

                // ── Top Labs Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'top_labs'.tr(),
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
                              builder: (context) => const AllLabsScreen(),
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
                ).animate().fadeIn(delay: 550.ms),

                const SizedBox(height: 16),

                // ── Top Labs Horizontal List ──
                SizedBox(
                  height: 180, // Even smaller height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final labs = [
                        {
                          'name': 'تاقیگەی ناوەندی هەولێر',
                          'city': 'Erbil',
                          'time': '25-35 min',
                          'image': 'assets/images/lab1.jpg',
                        },
                        {
                          'name': 'تاقیگەی سلێمانی نموونەیی',
                          'city': 'Sulaymaniyah',
                          'time': '30-40 min',
                          'image': 'assets/images/lab2.jpg',
                        },
                        {
                          'name': 'تاقیگەی دهۆک',
                          'city': 'Duhok',
                          'time': '20-30 min',
                          'image': 'assets/images/lab3.jpg',
                        },
                        {
                          'name': 'تاقیگەی کەرکوک مێدیکا',
                          'city': 'Kirkuk',
                          'time': '15-25 min',
                          'image': 'assets/images/lab4.jpg',
                        },
                      ];
                      final lab = labs[index];
                      return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LabDetailsScreen(lab: lab),
                                ),
                              );
                            },
                            child: Container(
                              width: 170, // Even smaller width
                              margin: const EdgeInsetsDirectional.only(
                                end: 14,
                                bottom: 12,
                                top: 4,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Top Image Section
                                        Container(
                                          height:
                                              80, // Even smaller image height
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(15),
                                                ),
                                            color: const Color(0xFFF8FAFC),
                                            image: DecorationImage(
                                              image: AssetImage(lab['image']!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              // Rating Badge
                                              Positioned(
                                                bottom: 6,
                                                right: 6,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withValues(
                                                              alpha: 0.1,
                                                            ),
                                                        blurRadius: 4,
                                                        offset: const Offset(
                                                          0,
                                                          2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star_rounded,
                                                        color: Color(
                                                          0xFFF59E0B,
                                                        ),
                                                        size: 12,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '4.8',
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  const Color(
                                                                    0xFF1E293B,
                                                                  ),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Details Section
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                lab['name']!,
                                                style: TextStyle(
                                                  fontFamily: 'Rabar',
                                                  fontSize:
                                                      12, // Even smaller font
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.getTextTitle(
                                                    context,
                                                  ),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Iconsax.location,
                                                    color: Color(0xFF3B82F6),
                                                    size: 10,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      lab['city']!,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: const Color(
                                                              0xFF64748B,
                                                            ),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Iconsax.clock,
                                                    color: Color(0xFF94A3B8),
                                                    size: 10,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    lab['time']!,
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                        0xFF94A3B8,
                                                      ),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  const Icon(
                                                    Iconsax.shield_tick,
                                                    color: Color(0xFF10B981),
                                                    size: 10,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    'Open',
                                                    style: GoogleFonts.poppins(
                                                      color: const Color(
                                                        0xFF10B981,
                                                      ),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (500 + (index * 100)).ms)
                          .slideY(begin: 0.1, end: 0);
                    },
                  ),
                ),

                // ── Top Pharmacies ──
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'top_pharmacies'.tr(),
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
                              builder: (context) => PharmaciesScreen(),
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
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: _topPharmacies.isEmpty
                      ? const Center(child: Text('بەم زووانە...'))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _topPharmacies.length,
                          itemBuilder: (context, index) {
                            final pharm = _topPharmacies[index];
                            final name = pharm['name'] ?? 'دەرمانخانە';
                            // We don't have city/time in DB yet, so placeholder:
                            final city = 'Erbil';
                            final time = '24 Hours';
                            final profileImage = pharm['profile_image'];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PharmacyDetailScreen(
                                      pharmacy: Pharmacy(
                                        id: pharm['id'] ?? 1,
                                        name: pharm['name'] ?? 'دەرمانخانە',
                                        rating:
                                            double.tryParse(
                                              pharm['rating']?.toString() ??
                                                  '4.8',
                                            ) ??
                                            4.8,
                                        deliveryFee:
                                            double.tryParse(
                                              pharm['delivery_fee']
                                                      ?.toString() ??
                                                  '1500.0',
                                            ) ??
                                            1500.0,
                                        profileImage: pharm['profile_image'],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 170,
                                margin: const EdgeInsetsDirectional.only(
                                  end: 14,
                                  bottom: 12,
                                  top: 4,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Top Image Section
                                          Container(
                                            height: 80,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(15),
                                                  ),
                                              color: const Color(0xFFF8FAFC),
                                              image: profileImage != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                        'http://127.0.0.1:8000/storage/$profileImage',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : DecorationImage(
                                                      image: AssetImage(
                                                        'assets/images/pharmacy1.jpg',
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            child: Stack(
                                              children: [
                                                // Rating Badge
                                                Positioned(
                                                  bottom: 6,
                                                  right: 6,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                            0,
                                                            2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.star_rounded,
                                                          color: Color(
                                                            0xFFF59E0B,
                                                          ),
                                                          size: 12,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          '4.9',
                                                          style:
                                                              GoogleFonts.poppins(
                                                                color:
                                                                    const Color(
                                                                      0xFF1E293B,
                                                                    ),
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Details Section
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  name,
                                                  style: TextStyle(
                                                    fontFamily: 'Rabar',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.getTextTitle(
                                                          context,
                                                        ),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Iconsax.location,
                                                      color: Color(0xFF3B82F6),
                                                      size: 10,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        city,
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  const Color(
                                                                    0xFF64748B,
                                                                  ),
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Iconsax.clock,
                                                      color: Color(0xFF94A3B8),
                                                      size: 10,
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      time,
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: const Color(
                                                              0xFF94A3B8,
                                                            ),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                    ),
                                                    const Spacer(),
                                                    const Icon(
                                                      Iconsax.verify,
                                                      color: Color(0xFF10B981),
                                                      size: 10,
                                                    ),
                                                    const SizedBox(width: 2),
                                                    Text(
                                                      'Verified',
                                                      style:
                                                          GoogleFonts.poppins(
                                                            color: const Color(
                                                              0xFF10B981,
                                                            ),
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: (650 + (index * 100)).ms).slideY(begin: 0.1, end: 0);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 86,
            child: _buildGridCard(
              context,
              imagePath: 'assets/images/lab.png',
              titleKey: 'cat_lab',
              id: 'lab',
              isActive: true,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 86,
            child: _buildGridCard(
              context,
              imagePath: 'assets/images/doctor_bag.png',
              titleKey: 'cat_nursing',
              id: 'nursing',
              isActive: true,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 86,
            child: _buildGridCard(
              context,
              imagePath: 'assets/images/doctor.png',
              titleKey: 'cat_doctor',
              id: 'doctor',
              isActive: false,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 86,
            child: _buildGridCard(
              context,
              imagePath: 'assets/images/medicine.png',
              titleKey: 'cat_pharmacy',
              id: 'pharmacy',
              isActive: false,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 86,
            child: _buildGridCard(
              context,
              imagePath: 'assets/images/xray.png',
              titleKey: 'cat_xray',
              id: 'xray',
              isActive: false,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 86,
            child: _buildGridCard(
              context,
              imagePath: 'assets/images/report.png',
              titleKey: 'cat_news',
              id: 'news',
              isActive: false,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 86,
            child: _buildGridCard(
              context,
              imagePath: 'assets/images/add.png',
              titleKey: 'cat_ambulance',
              id: 'ambulance',
              isActive: true,
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 86,
            child: _buildGridCard(
              context,
              imagePath: 'assets/images/apps.png',
              titleKey: 'cat_more',
              id: 'more',
              isActive: false,
            ),
          ),
        ],
      ),
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
                        color: Colors.grey.withValues(alpha: 0.3),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF3B82F6),
                            size: 20,
                          ),
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
          } else if (id == 'ambulance') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SosScreen()),
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
                width: 66,
                height: 66,
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
              top: -4,
              end: -8,
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
