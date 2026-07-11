import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import 'home_screen.dart';
import '../orders/orders_screen.dart';
import '../records/records_screen.dart';
import '../settings/settings_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    OrdersScreen(),
    RecordsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Light background to match Home
      body: Stack(
        children: [
          // Main Content
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          
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
                  _buildNavItem(1, Iconsax.heart),
                  _buildNavItem(2, Iconsax.briefcase),
                  _buildNavItem(3, Iconsax.setting_2),
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
              color: isActive ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
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
            ]
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
        return 'Favorites';
      case 2:
        return 'Records';
      case 3:
        return 'Settings';
      default:
        return '';
    }
  }
}
