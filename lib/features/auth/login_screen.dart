import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dr_widgets.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const LoginScreen({super.key, required this.onLogin, required this.onSignUp});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(
        0xFFF8FAFC,
      ), // Very light cool grey/blue background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Header Section ──
            SizedBox(
              height: size.height * 0.42,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Gradient Background at top
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFE0EEFF),
                            const Color(0xFFF8FAFC),
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Soft blue glow behind doctor
                  Positioned(
                    right: 0,
                    top: size.height * 0.05,
                    child: Container(
                      width: size.width * 0.6,
                      height: size.width * 0.6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF93C5FD).withValues(alpha: 0.3),
                            const Color(0xFFDBEAFE).withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Doctor Image (Aligned tightly to the right, fading at bottom)
                  Positioned(
                    right: -20,
                    top: 90,
                    bottom: 0,
                    width: size.width * 0.65,
                    child:
                        ShaderMask(
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black,
                                    Colors.black,
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.85, 1.0],
                                ).createShader(rect);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.asset(
                                'assets/images/doctor2.png',
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .slideX(begin: 0.2, end: 0, curve: Curves.easeOut),
                  ),

                  // Back Button
                  Positioned(
                    top: 60, // Adjusted to match status bar
                    left: 24,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFE2E8F0,
                              ).withValues(alpha: 0.8),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          size: 26,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ),

                  // DrRoom Logo & Welcome Text
                  Positioned(
                    left: 28,
                    top: 120,
                    child: SizedBox(
                      width:
                          size.width *
                          0.40,
                      child:
                          Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Logo Custom Design
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF60A5FA),
                                          Color(0xFF2563EB),
                                          Color(0xFF1D4ED8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Decorative circle
                                        Positioned(
                                          top: -8,
                                          right: -8,
                                          child: Container(
                                            width: 28,
                                            height: 28,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white.withValues(alpha: 0.15),
                                            ),
                                          ),
                                        ),
                                        // Medical cross icon
                                        const Center(
                                          child: Icon(
                                            Icons.local_hospital_rounded,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Logo Text
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Dr',
                                          style: GoogleFonts.poppins(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF2563EB),
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Room',
                                          style: GoogleFonts.poppins(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF0F172A),
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  // Welcome Text
                                  Text(
                                    'welcome_back'.tr(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                      height: 1.15,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'sign_in_continue'.tr(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideY(begin: 0.2, end: 0),
                    ),
                  ),
                ],
              ),
            ),

            // ── Form Section ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  // Email/Phone Input
                  _buildInputField(
                    hint: 'email_or_phone'.tr(),
                    icon: Icons.person_outline_rounded,
                    controller: _emailController,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  // Password Input
                  _buildInputField(
                    hint: 'password'.tr(),
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    controller: _passwordController,
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 12),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'forgot_password'.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF2563EB),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: 24),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: widget.onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: const Color(0xFF1D4ED8).withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'log_in'.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 32),

                  // Or Continue With
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or_continue_with'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Color(0xFFE2E8F0), thickness: 1),
                      ),
                    ],
                  ).animate().fadeIn(delay: 700.ms),

                  const SizedBox(height: 24),

                  // Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(_googleSvg),
                      const SizedBox(width: 16),
                      _buildSocialButton(_appleSvg),
                      const SizedBox(width: 16),
                      _buildSocialButton(_facebookSvg),
                    ],
                  ).animate().fadeIn(delay: 800.ms),

                  const SizedBox(height: 32),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont_have_account'.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onSignUp,
                        child: Text(
                          'sign_up'.tr(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 900.ms),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: const Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 15,
            color: const Color(0xFF94A3B8),
          ),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 22),
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF94A3B8),
                    size: 22,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String svgData) {
    return Expanded(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: SvgPicture.string(svgData, width: 28, height: 28)),
      ),
    );
  }
}

const String _googleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
  <path fill="#EA4335" d="M24 9.5c3.54 0 6.71 1.22 9.21 3.6l6.85-6.85C35.9 2.38 30.47 0 24 0 14.62 0 6.51 5.38 2.56 13.22l7.98 6.19C12.43 13.72 17.74 9.5 24 9.5z"/>
  <path fill="#4285F4" d="M46.98 24.55c0-1.57-.15-3.09-.38-4.55H24v9.02h12.94c-.58 2.96-2.26 5.48-4.78 7.18l7.73 6c4.51-4.18 7.09-10.36 7.09-17.65z"/>
  <path fill="#FBBC05" d="M10.53 28.59c-.48-1.45-.76-2.99-.76-4.59s.27-3.14.76-4.59l-7.98-6.19C.92 16.46 0 20.12 0 24c0 3.88.92 7.54 2.56 10.78l7.97-6.19z"/>
  <path fill="#34A853" d="M24 48c6.48 0 11.93-2.13 15.89-5.81l-7.73-6c-2.15 1.45-4.92 2.3-8.16 2.3-6.26 0-11.57-4.22-13.47-9.91l-7.98 6.19C6.51 42.62 14.62 48 24 48z"/>
</svg>
''';

const String _appleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512">
  <path d="M318.7 268.7c-.2-36.7 16.4-64.4 50-84.8-18.8-26.9-47.2-41.7-84.7-44.6-35.5-2.8-74.3 20.7-88.5 20.7-15 0-49.4-19.7-76.4-19.7C63.3 141.2 4 184.8 4 273.5q0 39.3 14.4 81.2c12.8 36.7 59 126.7 107.2 125.2 25.2-.6 43-17.9 75.8-17.9 31.8 0 48.3 17.9 76.4 17.9 48.6-.7 90.4-82.5 102.6-119.3-65.2-30.7-61.7-90-61.7-91.9zm-56.6-164.2c27.3-32.4 24.8-61.9 24-72.5-24.1 1.4-52 16.4-67.9 34.9-17.5 19.8-27.8 44.3-25.6 71.9 26.1 2 49.9-11.4 69.5-34.3z"/>
</svg>
''';

const String _facebookSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 512">
  <path fill="#1877F2" d="M279.14 288l14.22-92.66h-88.91v-60.13c0-25.35 12.42-50.06 52.24-50.06h40.42V6.26S260.43 0 225.36 0c-73.22 0-121.08 44.38-121.08 124.72v70.62H22.89V288h81.39v224h100.17V288z"/>
</svg>
''';

const String _drRoomIconSvg = '''
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<rect x="4" y="4" width="24" height="24" rx="6" fill="white" fill-opacity="0.2"/>
<path d="M16 9V23" stroke="white" stroke-width="3" stroke-linecap="round"/>
<path d="M9 16H23" stroke="white" stroke-width="3" stroke-linecap="round"/>
<circle cx="22" cy="10" r="4" fill="white" fill-opacity="0.25"/>
</svg>
''';
