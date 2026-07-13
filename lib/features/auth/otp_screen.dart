import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dr_widgets.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback onVerified;
  final VoidCallback onBack;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.onVerified,
    required this.onBack,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _pinController = TextEditingController();
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _isVerifying = false;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 54,
      height: 60,
      textStyle: AppTypography.headingMd.copyWith(
        color: AppColors.getTextTitle(context),
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceSecondary(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getBorder(context), width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.getSurface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // ── Back button ──
              Align(
                alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.getSurfaceSecondary(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: AppColors.getBorder(context), width: 1),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── SMS Icon ──
              Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.sms_rounded,
                      color: AppColors.primary,
                      size: 40,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),

              const SizedBox(height: 28),

              // ── Title ──
              Text(
                'verify_phone'.tr().replaceAll('\n', ' '),
                style: AppTypography.headingLg.copyWith(
                  color: AppColors.textDark,
                ),
              ).animate(delay: 200.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 8),

              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Text.rich(
                  TextSpan(
                    text: 'code_sent_to'.tr() + ' ',
                    style: AppTypography.bodyMd.copyWith(
                      color: AppColors.getTextSubtitle(context),
                      height: 1.5,
                      fontSize: 15,
                    ),
                    children: [
                      TextSpan(
                        text: '+964 ${widget.phoneNumber}',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 44),

              // ── PIN Input ──
              Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: Pinput(
                      length: 6,
                      controller: _pinController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      separatorBuilder: (i) => const SizedBox(width: 10),
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        setState(() => _isVerifying = true);
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          if (mounted) {
                            setState(() => _isVerifying = false);
                            widget.onVerified();
                          }
                        });
                      },
                      cursor: Container(
                        width: 2,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  )
                  .animate(delay: 400.ms)
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1, end: 0, duration: 400.ms),

              const SizedBox(height: 36),

              // ── Timer ──
              _buildTimer().animate(delay: 500.ms).fadeIn(duration: 400.ms),

              const SizedBox(height: 12),

              // ── Resend ──
              TextButton(
                onPressed: _canResend
                    ? () {
                        _startTimer();
                        _pinController.clear();
                      }
                    : null,
                child: Text(
                  'resend_code'.tr(),
                  style: AppTypography.labelMd.copyWith(
                    color: _canResend ? AppColors.primary : AppColors.textLight,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Verify Button ──
              DrButton(
                text: 'verify'.tr(),
                isLoading: _isVerifying,
                onPressed: _pinController.text.length == 6
                    ? () {
                        setState(() => _isVerifying = true);
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          if (mounted) {
                            setState(() => _isVerifying = false);
                            widget.onVerified();
                          }
                        });
                      }
                    : null,
              ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    final progress = _secondsRemaining / 60;
    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3,
              color: AppColors.primaryLight,
              backgroundColor: AppColors.getBorder(context),
            ),
          ),
          Text(
            '$_secondsRemaining',
            style: AppTypography.headingSm.copyWith(
              color: _secondsRemaining > 10
                  ? AppColors.getTextTitle(context)
                  : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
