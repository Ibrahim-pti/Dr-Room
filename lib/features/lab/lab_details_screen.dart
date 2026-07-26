import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'lab_order_method_screen.dart';

class LabDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> lab;

  const LabDetailsScreen({super.key, required this.lab});

  @override
  Widget build(BuildContext context) {
    final String name = lab['user']?['name'] ?? lab['name'] ?? 'Unknown Lab';
    final String city = lab['city'] ?? 'Unknown City';
    final String rating = lab['rating']?.toString() ?? '4.9';
    final String coverImage = lab['img'] ?? 'assets/images/lab1.jpg';

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: CustomScrollView(
        slivers: [
          // ── App Bar with Image ──
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.getSurface(context),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    coverImage,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for better text visibility (if we put text on it)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Lab Details Content ──
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.getBackground(context),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0, -20, 0), // Pull up over the image
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Name & Rating)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: 'Rabar',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.getTextTitle(context),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Iconsax.location, color: Color(0xFF3B82F6), size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    city,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF64748B),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFB45309),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 24),

                    // Quick Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoColumn(
                          context,
                          icon: Iconsax.clock,
                          title: 'working_hours'.tr(),
                          value: '8:00 AM - 10:00 PM',
                          color: const Color(0xFF3B82F6),
                        ),
                        Container(width: 1, height: 40, color: const Color(0xFFE2E8F0)),
                        _buildInfoColumn(
                          context,
                          icon: Iconsax.verify,
                          title: 'verified_lab'.tr(),
                          value: 'Dr. Room',
                          color: const Color(0xFF10B981),
                        ),
                      ],
                    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 24),

                    // About Lab
                    Text(
                      'about_lab'.tr(),
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextTitle(context),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 12),
                    Text(
                      "This laboratory is equipped with state-of-the-art medical testing equipment and provides highly accurate results. Our professional staff is dedicated to ensuring you get the best medical diagnostic services in a clean and safe environment.",
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextSubtitle(context),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 40), // Space for bottom button
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LabOrderMethodScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.health, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'book_test'.tr(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, {required IconData icon, required String title, required String value, required Color color}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.getTextSubtitle(context),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.getTextTitle(context),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
