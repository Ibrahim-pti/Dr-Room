import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'health_profile_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final VoidCallback onFinished;

  const LanguageSelectionScreen({super.key, required this.onFinished});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE6EDF5), Color(0xFFFFFFFF)],
              ),
            ),
          ),

          // Decorative Elements
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withValues(alpha: 0.05),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),

                  // Icon
                  Center(
                    child:
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF3B82F6,
                                ).withValues(alpha: 0.15),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.language_rounded,
                            size: 48,
                            color: Color(0xFF3B82F6),
                          ),
                        ).animate().scale(
                          duration: 500.ms,
                          curve: Curves.easeOutBack,
                        ),
                  ),

                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'Choose Language',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 60),

                  // Language Options
                  _buildLangCard(
                    context,
                    title: 'کوردی',
                    localeCode: 'ckb',
                    flag: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SvgPicture.asset('assets/images/kurdistan_flag.svg', width: 32, height: 22, fit: BoxFit.cover),
                    ),
                    delay: 400,
                  ),
                  const SizedBox(height: 16),
                  _buildLangCard(
                    context,
                    title: 'English',
                    localeCode: 'en',
                    flag: const Text('🇬🇧', style: TextStyle(fontSize: 28)),
                    delay: 500,
                  ),
                  const SizedBox(height: 16),
                  _buildLangCard(
                    context,
                    title: 'العربية',
                    localeCode: 'ar',
                    flag: const Text('🇸🇦', style: TextStyle(fontSize: 28)),
                    delay: 600,
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLangCard(
    BuildContext context, {
    required String title,
    required String localeCode,
    required Widget flag,
    required int delay,
  }) {
    return GestureDetector(
      onTap: () async {
        await context.setLocale(Locale(localeCode));
        if (!context.mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HealthProfileScreen(onFinished: onFinished),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Center(child: flag),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ],
        ),
      ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1, end: 0),
    );
  }
}
