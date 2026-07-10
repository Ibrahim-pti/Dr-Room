import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dr_widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

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
                  'داواکارییەکانم',
                  style: AppTypography.headingLg.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Filter Tabs ──
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _FilterChip(label: 'هەموو', isActive: true),
                    const SizedBox(width: 10),
                    _FilterChip(label: 'لە ڕێگادا', color: AppColors.info),
                    const SizedBox(width: 10),
                    _FilterChip(label: 'لە چاوەڕوانیدا', color: AppColors.warning),
                    const SizedBox(width: 10),
                    _FilterChip(label: 'تەواوبوو', color: AppColors.success),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Orders List ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildOrderItem(
                      'پشکنینی خوێنی گشتی CBC',
                      'لە ڕێگادایە',
                      AppColors.info,
                      Iconsax.health,
                      AppColors.labCardAccent,
                      '٢٥,٠٠٠ د.ع',
                      'ئەمڕۆ — ١٠:٣٠',
                      0,
                    ),
                    _buildOrderItem(
                      'ڕاوێژکاری ڤیدیۆیی — Dr. ئەحمەد',
                      'لە چاوەڕوانیدا',
                      AppColors.warning,
                      Iconsax.video,
                      AppColors.doctorCardAccent,
                      '٢٠,٠٠٠ د.ع',
                      'سبەینێ — ١٤:٠٠',
                      1,
                    ),
                    _buildOrderItem(
                      'گەیاندنی دەرمان — پارستامۆڵ',
                      'تەواو بوو ✓',
                      AppColors.success,
                      Iconsax.box_1,
                      AppColors.pharmacyCardAccent,
                      '١٢,٥٠٠ د.ع',
                      'دوێنێ — ١٨:٤٥',
                      2,
                    ),
                    _buildOrderItem(
                      'پەرستاری ماڵەوە — دەرزی',
                      'تەواو بوو ✓',
                      AppColors.success,
                      Iconsax.hospital,
                      AppColors.nursingCardAccent,
                      '١٥,٠٠٠ د.ع',
                      '٣ ڕۆژ پێش ئێستا',
                      3,
                    ),
                    _buildOrderItem(
                      'سۆناری سنگ',
                      'تەواو بوو ✓',
                      AppColors.success,
                      Iconsax.scan,
                      AppColors.xrayCardAccent,
                      '٤٥,٠٠٠ د.ع',
                      'هەفتەی ڕابردوو',
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

  Widget _buildOrderItem(
    String title,
    String status,
    Color statusColor,
    IconData icon,
    Color iconColor,
    String price,
    String date,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: statusColor.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          status,
                          style: AppTypography.bodySm.copyWith(
                            color: statusColor,
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
            Text(
              price,
              style: AppTypography.labelMd.copyWith(
                color: AppColors.primary,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color? color;

  const _FilterChip({
    required this.label,
    this.isActive = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isActive
            ? AppColors.primary
            : AppColors.surfaceLight,
        border: Border.all(
          color: isActive
              ? AppColors.primary
              : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (color != null && !isActive) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: isActive ? Colors.white : AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
