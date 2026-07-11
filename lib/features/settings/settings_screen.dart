import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../notifications/notifications_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section (Blue bg, Profile pic, Name)
            SizedBox(
              height: 270,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Blue Gradient
                  Container(
                    height: 190,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF4A90E2),
                          Color(0xFF82B1FF),
                        ],
                      ),
                    ),
                  ),

                  // White Curve
                  Positioned(
                    top: 155,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),

                  // App Bar
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                      child: Center(
                        child: Text(
                          'Profile',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Profile Picture & Name
                  Positioned(
                    top: 100,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE2E8F0),
                                border: Border.all(color: Colors.white, width: 4),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF82B1FF),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Sara Ahmad',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF0F172A),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'sar***@gmail.com',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF64748B),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Top Grid
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGridItem(
                          icon: Iconsax.calendar_1,
                          color: const Color(0xFF3B82F6),
                          label: 'My\nAppointments',
                        ),
                        _buildGridItem(
                          icon: Iconsax.document_text,
                          color: const Color(0xFF10B981),
                          label: 'Medical\nRecords',
                        ),
                        _buildGridItem(
                          icon: Icons.medication_outlined,
                          color: const Color(0xFF8B5CF6),
                          label: 'My\nPrescriptions',
                        ),
                        _buildGridItem(
                          icon: Iconsax.heart,
                          color: const Color(0xFFEF4444),
                          label: 'Health\nCheckups',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section 1
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildListItem(Iconsax.user, 'Personal Information'),
                        _buildDivider(),
                        _buildListItem(Iconsax.card, 'Payment Methods'),
                        _buildDivider(),
                        _buildListItem(Iconsax.location, 'Address'),
                        _buildDivider(),
                        _buildListItem(Iconsax.call, 'Emergency Contacts'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section 2
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildListItem(Iconsax.setting_2, 'Settings'),
                        _buildDivider(),
                        _buildListItem(Icons.help_outline_rounded, 'Help & Support'),
                        _buildDivider(),
                        _buildListItem(Iconsax.info_circle, 'About DrRoom'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Log Out
                  Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Iconsax.logout,
                              color: Color(0xFFEF4444),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Log Out',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFEF4444),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({required IconData icon, required Color color, required String label}) {
    return Column(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(IconData icon, String title) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF64748B),
                size: 20,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0F172A),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFCBD5E1),
                size: 22,
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
