import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dr_widgets.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Text(
                  'مەلەفی تەندروستی',
                  style: AppTypography.headingLg.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Profile Summary ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: DrCard(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.15),
                              AppColors.primaryLight.withValues(alpha: 0.15),
                            ],
                          ),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(Iconsax.user,
                            color: AppColors.primary, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'یەحیا ئەحمەد',
                              style: AppTypography.labelLg.copyWith(
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              'تەمەن: ٢٥ | جۆری خوێن: O+',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary.withValues(alpha: 0.08),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'O+',
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ),

              const SizedBox(height: 20),

              // ── Tabs ──
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _TabItem(label: 'هەموو', isActive: true),
                    const SizedBox(width: 8),
                    _TabItem(label: 'تاقیگە'),
                    const SizedBox(width: 8),
                    _TabItem(label: 'ڕەچەتە'),
                    const SizedBox(width: 8),
                    _TabItem(label: 'ئاشیمە'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Records List ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildRecordCard(
                      'پشکنینی خوێنی گشتی CBC',
                      '2026/06/15',
                      'ئاسایی',
                      AppColors.success,
                      Iconsax.health,
                      AppColors.labCardAccent,
                      0,
                    ),
                    _buildRecordCard(
                      'پشکنینی شەکرە FBS',
                      '2026/05/20',
                      'سەرنج — 126 mg/dl',
                      AppColors.warning,
                      Iconsax.health,
                      AppColors.labCardAccent,
                      1,
                    ),
                    _buildRecordCard(
                      'سۆناری سنگ',
                      '2026/04/10',
                      'ئاسایی',
                      AppColors.success,
                      Iconsax.scan,
                      AppColors.xrayCardAccent,
                      2,
                    ),
                    _buildRecordCard(
                      'ڕەچەتە — Dr. ئەحمەد',
                      '2026/03/05',
                      'Metformin 500mg',
                      AppColors.info,
                      Iconsax.document_text,
                      AppColors.doctorCardAccent,
                      3,
                    ),
                    _buildRecordCard(
                      'پشکنینی غودەکان Thyroid',
                      '2026/02/18',
                      'ئاسایی',
                      AppColors.success,
                      Iconsax.health,
                      AppColors.labCardAccent,
                      4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecordCard(
    String title,
    String date,
    String result,
    Color resultColor,
    IconData icon,
    Color iconColor,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DrCard(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: iconColor.withValues(alpha: 0.1),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: resultColor.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          result,
                          style: AppTypography.bodySm.copyWith(
                            color: resultColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textLight,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surfaceLightSecondary,
                border: Border.all(
                    color: AppColors.cardBorder, width: 1),
              ),
              child: const Icon(
                Iconsax.document_download,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
      )
          .animate(delay: Duration(milliseconds: 100 * index))
          .fadeIn(duration: 400.ms)
          .slideX(begin: 0.05, end: 0, duration: 400.ms),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;

  const _TabItem({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive ? AppColors.primary : AppColors.surfaceLight,
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelSm.copyWith(
          color: isActive ? Colors.white : AppColors.textMedium,
        ),
      ),
    );
  }
}
