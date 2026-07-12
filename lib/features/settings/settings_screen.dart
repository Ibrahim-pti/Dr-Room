import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import 'family_members_screen.dart';
import '../settings/saved_addresses_screen.dart';
import '../records/medical_records_screen.dart';
import '../prescriptions/pill_reminder_screen.dart';
import '../notifications/notifications_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section
            SizedBox(
              height: 270,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Blue Gradient
                  Container(
                    height: 190,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)]
                            : [const Color(0xFF4A90E2), const Color(0xFF82B1FF)],
                      ),
                    ),
                  ),

                  // Background Curve
                  Positioned(
                    top: 155,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
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
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                border: Border.all(
                                    color: Theme.of(context).scaffoldBackgroundColor, width: 4),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 2,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Theme.of(context).scaffoldBackgroundColor, width: 2),
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
                            color: AppColors.getTextTitle(context),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'sar***@gmail.com',
                          style: GoogleFonts.poppins(
                            color: AppColors.getTextSubtitle(context),
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
                      color: AppColors.getSurface(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.getBorder(context)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGridItem(
                          context,
                          imagePath: 'assets/images/settings_appointments.png',
                          label: 'My\nAppointments',
                        ),
                        _buildGridItem(
                          context,
                          imagePath: 'assets/images/drawer_orders.png',
                          label: 'Medical\nRecords',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MedicalRecordsScreen()),
                            );
                          },
                        ),
                        _buildGridItem(
                          context,
                          imagePath: 'assets/images/medicine.png',
                          label: 'My\nPrescriptions',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PillReminderScreen()),
                            );
                          },
                        ),
                        _buildGridItem(
                          context,
                          imagePath: 'assets/images/drawer_favorites.png',
                          label: 'Health\nCheckups',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Dark Mode Toggle Section
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.getSurface(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.getBorder(context)),
                    ),
                    child: _buildToggleItem(
                      context,
                      imagePath: 'assets/images/settings_theme.png',
                      title: 'Dark Mode',
                      value: isDark,
                      onChanged: (val) {
                        Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section 1
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.getSurface(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.getBorder(context)),
                    ),
                    child: Column(
                      children: [
                        _buildListItem(context, imagePath: 'assets/images/settings_personal.png', title: 'Personal Information', onTap: () {}),
                        _buildDivider(context),
                        _buildListItem(context, imagePath: 'assets/images/doctor.png', title: 'My Family', onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FamilyMembersScreen()),
                          );
                        }),
                        _buildDivider(context),
                        _buildListItem(context, imagePath: 'assets/images/settings_addresses.png', title: 'Address', onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SavedAddressesScreen()),
                          );
                        }),
                      ],
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

  Widget _buildGridItem(BuildContext context, {IconData? icon, String? imagePath, Color? color, required String label, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color != null ? color.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  )
                : Icon(
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
              color: AppColors.getTextTitle(context),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, {IconData? icon, String? imagePath, required String title, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (imagePath != null)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(imagePath, fit: BoxFit.cover),
                  ),
                )
              else if (icon != null)
                Icon(
                  icon,
                  color: AppColors.getTextSubtitle(context),
                  size: 20,
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: AppColors.getTextTitle(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).brightness == Brightness.dark 
                    ? const Color(0xFF475569) 
                    : const Color(0xFFCBD5E1),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(BuildContext context, {IconData? icon, String? imagePath, required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          if (imagePath != null)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            )
          else if (icon != null)
            Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.getTextTitle(context),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: AppColors.getDivider(context),
        height: 1,
        thickness: 1,
      ),
    );
  }
}
