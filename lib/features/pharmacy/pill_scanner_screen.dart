import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'dart:ui';
import 'widgets/holographic_medicine_card.dart';

class PillScannerScreen extends StatefulWidget {
  const PillScannerScreen({super.key});

  @override
  State<PillScannerScreen> createState() => _PillScannerScreenState();
}

class _PillScannerScreenState extends State<PillScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _laserController;
  bool _isScanning = true;
  bool _scanComplete = false;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Simulate scanning process
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _scanComplete = true;
          _laserController.stop();
        });
        _showMedicineDetails();
      }
    });
  }

  @override
  void dispose() {
    _laserController.dispose();
    super.dispose();
  }

  void _showMedicineDetails() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return HolographicMedicineCard(
          onAddPressed: () {
            Navigator.pop(context); // Close sheet
            Navigator.pop(context, true); // Return to previous screen with success
          },
        );
      },
    ).whenComplete(() {
      // If they dismiss the sheet, maybe restart scanning or just leave it.
      if (mounted && _scanComplete) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Camera simulation background
      body: Stack(
        children: [
          // Simulated Camera Feed (Dark blurred background)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF1E293B),
                    Colors.black,
                  ],
                  radius: 1.5,
                ),
              ),
            ),
          ),
          
          // Camera overlay UI (Darkened borders)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),

          // The clear cutout in the middle for the "scanner"
          Center(
            child: Container(
              width: 250,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.transparent, // Clear center
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _scanComplete ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_scanComplete ? const Color(0xFF10B981) : const Color(0xFF3B82F6)).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Corner indicators
                  _buildCorner(Alignment.topLeft),
                  _buildCorner(Alignment.topRight),
                  _buildCorner(Alignment.bottomLeft),
                  _buildCorner(Alignment.bottomRight),

                  // Pill bottle placeholder icon (simulating object in view)
                  if (!_scanComplete)
                    Center(
                      child: Icon(
                        Iconsax.glass,
                        color: Colors.white.withValues(alpha: 0.2),
                        size: 80,
                      ).animate(onPlay: (controller) => controller.repeat(reverse: true)).fade(begin: 0.2, end: 0.6, duration: 1.seconds),
                    ),

                  // Laser Animation
                  if (_isScanning)
                    AnimatedBuilder(
                      animation: _laserController,
                      builder: (context, child) {
                        return Positioned(
                          top: _laserController.value * 330, // 350 height - laser height
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6).withValues(alpha: 0.8),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Success icon
                    if (_scanComplete)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF10B981),
                            size: 60,
                          ),
                        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                      ),
                ],
              ),
            ),
          ),

          // Top App Bar Elements (Overlay)
          Positioned(
            top: 50,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
                Text(
                  'Smart Pill Scanner',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(Icons.flash_on, color: Colors.white, size: 24),
                ),
              ],
            ),
          ),

          // Bottom Instruction Text
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Text(
                  _scanComplete ? 'Medicine Identified!' : 'Scanning...',
                  style: GoogleFonts.poppins(
                    color: _scanComplete ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate(target: _scanComplete ? 1 : 0).fadeIn(),
                const SizedBox(height: 8),
                Text(
                  'Align the pill bottle within the frame.',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: _getCornerBorder(alignment),
        ),
      ),
    );
  }

  Border _getCornerBorder(Alignment alignment) {
    const color = Colors.white;
    const width = 4.0;
    if (alignment == Alignment.topLeft) {
      return const Border(top: BorderSide(color: color, width: width), left: BorderSide(color: color, width: width));
    } else if (alignment == Alignment.topRight) {
      return const Border(top: BorderSide(color: color, width: width), right: BorderSide(color: color, width: width));
    } else if (alignment == Alignment.bottomLeft) {
      return const Border(bottom: BorderSide(color: color, width: width), left: BorderSide(color: color, width: width));
    } else {
      return const Border(bottom: BorderSide(color: color, width: width), right: BorderSide(color: color, width: width));
    }
  }
}
