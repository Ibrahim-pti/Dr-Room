import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const SplashScreen({super.key, required this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _ecgController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _ecgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..forward();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ecgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A9FFF),
              Color(0xFF2E86DE),
              Color(0xFF1B6EC2),
            ],
          ),
        ),
        child: Stack(
          children: [
            // ── Background decorative circles ──
            Positioned(
              top: -size.width * 0.4,
              right: -size.width * 0.3,
              child: Container(
                width: size.width * 0.9,
                height: size.width * 0.9,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -size.width * 0.3,
              left: -size.width * 0.25,
              child: Container(
                width: size.width * 0.7,
                height: size.width * 0.7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),

            // ── ECG Line across middle ──
            Positioned(
              top: size.height * 0.38,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _ecgController,
                builder: (context, _) => CustomPaint(
                  size: Size(size.width, 60),
                  painter: _ECGPainter(progress: _ecgController.value),
                ),
              ),
            ).animate(delay: 400.ms).fadeIn(duration: 600.ms),

            // ── Floating medical icons ──
            ..._buildFloatingIcons(size),

            // ── Center content ──
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Doctor Image ──
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/doctor2.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ).animate(delay: 200.ms).fadeIn(duration: 800.ms).scaleXY(begin: 0.5, end: 1, duration: 800.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 24),

                  // ── App Name ──
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Dr',
                        style: GoogleFonts.poppins(
                          fontSize: 44,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withValues(alpha: 0.9),
                          letterSpacing: -1,
                          height: 1,
                        ),
                      ),
                      Text(
                        'Room',
                        style: GoogleFonts.poppins(
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -1,
                          height: 1,
                        ),
                      ),
                    ],
                  )
                      .animate(delay: 900.ms)
                      .fadeIn(duration: 700.ms)
                      .slideY(begin: 0.35, end: 0, duration: 700.ms, curve: Curves.easeOutCubic),

                  const SizedBox(height: 16),

                  // ── Tagline ──
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white.withValues(alpha: 0.12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'خزمەتگوزاری تەندروستی بۆ دەرگای ماڵتەوە',
                      style: GoogleFonts.notoNaskhArabic(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  )
                      .animate(delay: 1400.ms)
                      .fadeIn(duration: 600.ms)
                      .scaleXY(begin: 0.9, end: 1, duration: 600.ms),
                ],
              ),
            ),

            // ── Bottom loader ──
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'چاوەڕوان بە ...',
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ).animate(delay: 2000.ms).fadeIn(duration: 500.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoWithPulse() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing rings
        ...List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final delay = i * 0.25;
              final t = (_pulseController.value + delay) % 1.0;
              final scale = 1.0 + (t * 0.8);
              final opacity = (1.0 - t) * 0.12;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: opacity),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Logo container
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: AppColors.primary,
                size: 48,
              ),
              Positioned(
                bottom: 18,
                right: 18,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        )
            .animate(delay: 300.ms)
            .fadeIn(duration: 600.ms)
            .scale(
              begin: const Offset(0.3, 0.3),
              end: const Offset(1, 1),
              duration: 800.ms,
              curve: Curves.easeOutBack,
            ),
      ],
    );
  }

  List<Widget> _buildFloatingIcons(Size size) {
    final icons = [
      Icons.favorite_rounded,
      Icons.local_hospital_rounded,
      Icons.science_rounded,
      Icons.healing_rounded,
      Icons.monitor_heart_rounded,
      Icons.vaccines_rounded,
    ];
    final random = Random(42);

    return List.generate(icons.length, (i) {
      final x = 30.0 + random.nextDouble() * (size.width - 60);
      final y = 80.0 + random.nextDouble() * (size.height - 160);
      final iconSize = 16.0 + random.nextDouble() * 10;
      final delay = 500 + random.nextInt(2000);

      return Positioned(
        left: x,
        top: y,
        child: Icon(
          icons[i],
          size: iconSize,
          color: Colors.white.withValues(alpha: 0.06 + random.nextDouble() * 0.05),
        )
            .animate(
              delay: Duration(milliseconds: delay),
              onPlay: (c) => c.repeat(reverse: true),
            )
            .fadeIn(duration: 1500.ms)
            .moveY(begin: 0, end: -12 - random.nextDouble() * 18, duration: 3500.ms),
      );
    });
  }
}

class _ECGPainter extends CustomPainter {
  final double progress;
  _ECGPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height / 2;
    final totalW = size.width;
    final drawW = totalW * progress;

    final path = Path()..moveTo(0, midY);

    for (double x = 0; x < drawW; x += 0.8) {
      final r = x / totalW;
      double y = midY;

      if (r > 0.20 && r < 0.26) {
        y = midY - sin((r - 0.20) / 0.06 * pi) * 7;
      } else if (r > 0.30 && r < 0.34) {
        y = midY + sin((r - 0.30) / 0.04 * pi) * 5;
      } else if (r > 0.34 && r < 0.42) {
        y = midY - sin((r - 0.34) / 0.08 * pi) * 28;
      } else if (r > 0.42 && r < 0.47) {
        y = midY + sin((r - 0.42) / 0.05 * pi) * 8;
      } else if (r > 0.55 && r < 0.65) {
        y = midY - sin((r - 0.55) / 0.10 * pi) * 12;
      }

      path.lineTo(x, y);
    }

    // Glow
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.08)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Line
    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Tip
    if (progress > 0.01 && progress < 0.99) {
      final tx = drawW;
      final r = tx / totalW;
      double ty = midY;
      if (r > 0.20 && r < 0.26) ty = midY - sin((r - 0.20) / 0.06 * pi) * 7;
      else if (r > 0.30 && r < 0.34) ty = midY + sin((r - 0.30) / 0.04 * pi) * 5;
      else if (r > 0.34 && r < 0.42) ty = midY - sin((r - 0.34) / 0.08 * pi) * 28;
      else if (r > 0.42 && r < 0.47) ty = midY + sin((r - 0.42) / 0.05 * pi) * 8;
      else if (r > 0.55 && r < 0.65) ty = midY - sin((r - 0.55) / 0.10 * pi) * 12;

      canvas.drawCircle(Offset(tx, ty), 6, Paint()..color = Colors.white.withValues(alpha: 0.15)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
      canvas.drawCircle(Offset(tx, ty), 3, Paint()..color = Colors.white.withValues(alpha: 0.6));
    }
  }

  @override
  bool shouldRepaint(_ECGPainter old) => old.progress != progress;
}
