import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dr_widgets.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String phone) onSendCode;

  const LoginScreen({super.key, required this.onSendCode});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _isValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validate);
  }

  void _validate() {
    final phone = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    setState(() {
      _isValid = phone.length == 11 || phone.length == 10;
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // ── Doctor Image ──
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/doctor3.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ).animate().fadeIn(duration: 500.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 32),

              // ── Title ──
              Text(
                'بەخێربێیت بۆ DrRoom',
                style: AppTypography.headingLg.copyWith(color: AppColors.textDark),
                textDirection: TextDirection.rtl,
              ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 8),

              Text(
                'ژمارەی مۆبایلت بنووسە بۆ چوونەژوورەوە',
                style: AppTypography.bodyMd.copyWith(color: AppColors.textMedium),
                textDirection: TextDirection.rtl,
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 48),

              // ── Phone Input ──
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _isValid
                          ? AppColors.success.withValues(alpha: 0.4)
                          : AppColors.cardBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Country code
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: AppColors.divider, width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 28,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: AppColors.divider, width: 0.5),
                              ),
                              child: Column(
                                children: [
                                  Expanded(child: Container(color: const Color(0xFFCE1126))),
                                  Expanded(child: Container(color: Colors.white)),
                                  Expanded(child: Container(color: Colors.black)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '+964',
                              style: AppTypography.labelMd.copyWith(color: AppColors.textDark),
                            ),
                          ],
                        ),
                      ),

                      // Input
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: AppTypography.bodyLg.copyWith(
                            color: AppColors.textDark,
                            letterSpacing: 1.5,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          decoration: InputDecoration(
                            hintText: '7XX XXX XXXX',
                            hintStyle: AppTypography.bodyLg.copyWith(
                              color: AppColors.textLight,
                              letterSpacing: 1.5,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),

                      if (_isValid)
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.success,
                            size: 22,
                          ).animate().fadeIn(duration: 300.ms).scale(
                                begin: const Offset(0.5, 0.5),
                                end: const Offset(1, 1),
                                duration: 300.ms,
                              ),
                        ),
                    ],
                  ),
                ),
              ).animate(delay: 400.ms).fadeIn(duration: 400.ms).slideY(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                  ),

              const SizedBox(height: 12),

              // ── Operator chips ──
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    _operatorChip('ئاسیاسێل', '077'),
                    const SizedBox(width: 8),
                    _operatorChip('کۆرەک', '075'),
                    const SizedBox(width: 8),
                    _operatorChip('زەین', '078'),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 40),

              // ── Send Code Button ──
              DrButton(
                text: 'ناردنی کۆدی پشتڕاستکردنەوە',
                isLoading: _isLoading,
                onPressed: _isValid
                    ? () {
                        setState(() => _isLoading = true);
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          if (mounted) {
                            setState(() => _isLoading = false);
                            widget.onSendCode(_phoneController.text);
                          }
                        });
                      }
                    : null,
              ).animate(delay: 600.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 24),

              Text(
                'بە ناردنی کۆد، ڕەزامەندیت بە مەرجەکانی بەکارهێنان دەدەیت',
                style: AppTypography.bodySm.copyWith(color: AppColors.textLight),
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ).animate(delay: 700.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _operatorChip(String name, String prefix) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.surfaceLight,
        border: Border.all(color: AppColors.cardBorder, width: 0.5),
      ),
      child: Text(
        '$name ($prefix)',
        style: AppTypography.bodySm.copyWith(
          color: AppColors.textLight,
          fontSize: 11,
        ),
      ),
    );
  }
}
