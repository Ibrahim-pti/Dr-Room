import 'package:dr_room/features/orders/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import 'home_screen.dart';
import '../records/medical_records_screen.dart';
import '../discover/discover_screen.dart';
import '../settings/settings_screen.dart';
import '../appointments/all_schedules_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MedicalRecordsScreen(),
    AllSchedulesScreen(),
    DiscoverScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF1F5F9,
      ), // Light background to match Home
      endDrawer: _buildDrawer(context),
      body: Stack(
        children: [
          // Main Content
          IndexedStack(index: _currentIndex, children: _screens),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 30, // Floats above the bottom
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(0, Iconsax.home_2),
                  _buildNavItem(1, Iconsax.folder_2),
                  _buildNavItem(2, Iconsax.calendar_1),
                  _buildNavItem(3, Iconsax.book),
                  _buildNavItem(4, Iconsax.user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isActive
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
            : const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE0EEFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF94A3B8),
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                _getLabelForIndex(index),
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Records';
      case 2:
        return 'Schedule';
      case 3:
        return 'Discover';
      case 4:
        return 'Profile';
      default:
        return '';
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // Ultra pure white
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.getBorder(context),
                          width: 2,
                        ),
                        image: const DecorationImage(
                          image: AssetImage(
                            'assets/images/doctor2.png',
                          ), // Placeholder
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Close Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.getSurface(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.getBorder(context),
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.getTextTitle(context),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sara Ahmed',
                  style: GoogleFonts.poppins(
                    color: AppColors.getTextTitle(context),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+964 750 123 4567',
                  style: GoogleFonts.poppins(
                    color: AppColors.getTextSubtitle(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                // DrRoom Plus Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Iconsax.star_1, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'DrRoom Plus Member',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.receipt_2,
                    title: 'My Orders',
                    color: const Color(0xFF3B82F6),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.heart,
                    title: 'Favorites',
                    color: const Color(0xFFEF4444),
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.wallet_2,
                    title: 'Wallet & Payments',
                    color: const Color(0xFF10B981),
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.setting_2,
                    title: 'Settings',
                    color: const Color(0xFF64748B),
                    onTap: () {
                      Navigator.pop(context);
                      // Let the user handle where to go, or go to Profile.
                      setState(() {
                        _currentIndex = 4;
                      });
                    },
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.message_question,
                    title: 'Help & Support',
                    color: const Color(0xFFF59E0B),
                    onTap: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Divider(color: AppColors.getBorder(context)),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Iconsax.logout,
                    title: 'Logout',
                    color: const Color(0xFFEF4444),
                    isLogout: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isLogout
                      ? color.withValues(alpha: 0.1)
                      : AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(14),
                  border: isLogout
                      ? null
                      : Border.all(color: AppColors.getBorder(context)),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: isLogout ? color : AppColors.getTextTitle(context),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!isLogout)
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.getTextSubtitle(context),
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
