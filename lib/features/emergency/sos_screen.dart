import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _isTracking = false;
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isTracking = true;
        });
      }
    });
  }

  void _cancelSos() {
    _timer?.cancel();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isTracking ? AppColors.getBackground(context) : const Color(0xFFEF4444),
      body: _isTracking ? _buildTrackingView() : _buildCountdownView(),
    );
  }

  Widget _buildCountdownView() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 80)
                .animate(onPlay: (controller) => controller.repeat())
                .fade(duration: 500.ms)
                .then()
                .fade(duration: 500.ms, begin: 1, end: 0.3),
            const SizedBox(height: 32),
            Text(
              'Calling Ambulance in',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Center(
                child: Text(
                  '$_countdown',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate(key: ValueKey(_countdown)).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 200.ms),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: _cancelSos,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFEF4444),
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'CANCEL',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingView() {
    return Stack(
      children: [
        // Map Background Mockup
        Positioned.fill(
          child: Container(
            color: const Color(0xFFE2E8F0), // Map background color
            child: Stack(
              children: [
                // Grid lines to look like a map
                Positioned.fill(
                  child: GridPaper(
                    color: Colors.black.withValues(alpha: 0.05),
                    divisions: 1,
                    subdivisions: 1,
                    interval: 100,
                  ),
                ),
                // Route line
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: const Color(0xFF3B82F6), width: 4),
                        top: BorderSide(color: const Color(0xFF3B82F6), width: 4),
                      ),
                    ),
                  ),
                ),
                // Ambulance marker
                Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.local_hospital, color: Color(0xFFEF4444), size: 30),
                  ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 1000.ms),
                ),
                // Patient Marker
                Positioned(
                  bottom: MediaQuery.of(context).size.height / 2 - 100,
                  right: MediaQuery.of(context).size.width / 2 - 100,
                  child: const Icon(Icons.person_pin_circle, color: Color(0xFF3B82F6), size: 40),
                ),
              ],
            ),
          ),
        ),
        
        // Back button
        Positioned(
          top: 50,
          left: 20,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),

        // Bottom Sheet Info
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.getSurface(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ambulance Dispatched',
                          style: GoogleFonts.poppins(
                            color: AppColors.getTextTitle(context),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Unit #402 is on the way',
                          style: GoogleFonts.poppins(
                            color: AppColors.getTextSubtitle(context),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '5 MIN',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFEF4444),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFE2E8F0),
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Paramedic: Ahmed Ali',
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextTitle(context),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFBBF24), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: GoogleFonts.poppins(
                                  color: AppColors.getTextSubtitle(context),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ).animate().slideY(begin: 1, end: 0, duration: 400.ms, curve: Curves.easeOut),
        ),
      ],
    );
  }
}
