import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dr_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverToBoxAdapter(child: _buildHeader(context)),

          // ── Search Bar ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder, width: 1),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 18),
                      Icon(Iconsax.search_normal, color: AppColors.textLight, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'گەڕان لە پزیشکەکان ...',
                        style: AppTypography.bodyMd.copyWith(color: AppColors.textLight),
                      ),
                      const Spacer(),
                      Container(
                        width: 42,
                        height: 42,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Iconsax.microphone, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 200.ms).fadeIn(duration: 400.ms).slideY(begin: 0.08, end: 0, duration: 400.ms),
            ),
          ),

          // ── Upcoming Appointment Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DrCard(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  borderColor: Colors.transparent,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      // Doctor avatar
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                        ),
                        child: Icon(Iconsax.user, color: Colors.white.withValues(alpha: 0.9), size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. ئەحمەد حسێن',
                              style: AppTypography.labelLg.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'پسپۆڕی ناوخۆیی',
                              style: AppTypography.bodySm.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Iconsax.calendar_1, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                                const SizedBox(width: 5),
                                Text(
                                  '١٣ تەمموز، پێنجشەممە',
                                  style: AppTypography.bodySm.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Iconsax.clock, size: 14, color: Colors.white.withValues(alpha: 0.7)),
                                const SizedBox(width: 5),
                                Text(
                                  '٦:٣٠ ئێوارە',
                                  style: AppTypography.bodySm.copyWith(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms).slideY(begin: 0.08, end: 0, duration: 400.ms),
            ),
          ),

          // ── Service Grid Title ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Text(
                      'خزمەتگوزارییەکان',
                      style: AppTypography.headingSm.copyWith(color: AppColors.textDark),
                    ),
                    const Spacer(),
                    Text(
                      'هەموو',
                      style: AppTypography.labelSm.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ).animate(delay: 350.ms).fadeIn(duration: 400.ms),
            ),
          ),

          // ── 6 Service Grid ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.92,
              ),
              delegate: SliverChildListDelegate(_serviceCards()),
            ),
          ),

          // ── Top Doctors Title ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Text(
                      'باشترین پزیشکەکان',
                      style: AppTypography.headingSm.copyWith(color: AppColors.textDark),
                    ),
                    const Spacer(),
                    Text(
                      'هەموو',
                      style: AppTypography.labelSm.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ).animate(delay: 600.ms).fadeIn(duration: 400.ms),
            ),
          ),

          // ── Doctor Cards ──
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildDoctorCard('Dr. سارا عەلی', 'پسپۆڕی منداڵان', '4.9', '١٠ ساڵ ئەزموون', 0),
                  const SizedBox(width: 14),
                  _buildDoctorCard('Dr. ئەحمەد حسێن', 'پسپۆڕی ناوخۆیی', '4.8', '١٥ ساڵ ئەزموون', 1),
                  const SizedBox(width: 14),
                  _buildDoctorCard('Dr. ڕەزا کەریم', 'پسپۆڕی پێست', '4.7', '٨ ساڵ ئەزموون', 2),
                ],
              ),
            ),
          ),

          // ── Active Orders ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 14),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  children: [
                    Text(
                      'داواکارییە چالاکەکان',
                      style: AppTypography.headingSm.copyWith(color: AppColors.textDark),
                    ),
                    const Spacer(),
                    Text(
                      'هەموو',
                      style: AppTypography.labelSm.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ).animate(delay: 800.ms).fadeIn(duration: 400.ms),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildActiveOrder(
                  'پشکنینی خوێن CBC',
                  'لە ڕێگادایە',
                  AppColors.info,
                  Iconsax.activity,
                  '٢٥,٠٠٠ د.ع',
                  0.65,
                  0,
                ),
                const SizedBox(height: 12),
                _buildActiveOrder(
                  'گەیاندنی دەرمان',
                  'تەواو بوو ✓',
                  AppColors.success,
                  Iconsax.box_1,
                  '١٢,٥٠٠ د.ع',
                  1.0,
                  1,
                ),
              ]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [AppColors.primarySoft, AppColors.primaryBg],
                      ),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
                    ),
                    child: const Icon(Iconsax.user, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'سڵاو، یەحیا 👋',
                          style: AppTypography.headingSm.copyWith(color: AppColors.textDark),
                        ),
                        Text(
                          'تەندروستیت چۆنە ئەمڕۆ؟',
                          style: AppTypography.bodySm.copyWith(color: AppColors.textMedium),
                        ),
                      ],
                    ),
                  ),
                  // Notification
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.surfaceLightSecondary,
                          border: Border.all(color: AppColors.cardBorder, width: 1),
                        ),
                        child: const Icon(Iconsax.notification, color: AppColors.textMedium, size: 22),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: AppColors.surfaceLight, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '3',
                              style: AppTypography.bodySm.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  List<Widget> _serviceCards() {
    return [
      DrServiceCard(
        title: 'تاقیگە',
        subtitle: 'Lab',
        icon: Iconsax.health,
        cardColor: AppColors.labCard,
        accentColor: AppColors.labCardAccent,
        index: 0,
      ),
      DrServiceCard(
        title: 'پەرستاری',
        subtitle: 'Nursing',
        icon: Iconsax.hospital,
        cardColor: AppColors.nursingCard,
        accentColor: AppColors.nursingCardAccent,
        index: 1,
      ),
      DrServiceCard(
        title: 'دکتۆر',
        subtitle: 'Doctor',
        icon: Iconsax.user_tag,
        cardColor: AppColors.doctorCard,
        accentColor: AppColors.doctorCardAccent,
        index: 2,
      ),
      DrServiceCard(
        title: 'سەیدەلیە',
        subtitle: 'Pharmacy',
        icon: Iconsax.box_1,
        cardColor: AppColors.pharmacyCard,
        accentColor: AppColors.pharmacyCardAccent,
        index: 3,
      ),
      DrServiceCard(
        title: 'ئاشیمە',
        subtitle: 'X-Ray',
        icon: Iconsax.scan,
        cardColor: AppColors.xrayCard,
        accentColor: AppColors.xrayCardAccent,
        index: 4,
      ),
      DrServiceCard(
        title: 'زیاتر',
        subtitle: 'More',
        icon: Iconsax.element_plus,
        cardColor: AppColors.moreCard,
        accentColor: AppColors.moreCardAccent,
        index: 5,
      ),
    ];
  }

  Widget _buildDoctorCard(String name, String specialty, String rating, String exp, int index) {
    return SizedBox(
      width: 170,
      child: DrCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primarySoft,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 1.5),
              ),
              child: const Icon(Iconsax.user, color: AppColors.primary, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: AppTypography.labelMd.copyWith(color: AppColors.textDark),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 3),
            Text(
              specialty,
              style: AppTypography.bodySm.copyWith(color: AppColors.textMedium, fontSize: 11),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 16),
                const SizedBox(width: 3),
                Text(
                  rating,
                  style: AppTypography.labelSm.copyWith(color: AppColors.textDark, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 12, color: AppColors.divider),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    exp,
                    style: AppTypography.bodySm.copyWith(color: AppColors.textLight, fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 650 + (index * 100)))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1, end: 0, duration: 400.ms);
  }

  Widget _buildActiveOrder(
    String title,
    String status,
    Color statusColor,
    IconData icon,
    String price,
    double progress,
    int index,
  ) {
    return DrCard(
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: statusColor.withValues(alpha: 0.08),
              ),
              child: Icon(icon, color: statusColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelMd.copyWith(color: AppColors.textDark),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: statusColor.withValues(alpha: 0.08),
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
                      const Spacer(),
                      Text(
                        price,
                        style: AppTypography.labelMd.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 4,
                      color: statusColor,
                      backgroundColor: statusColor.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 850 + (index * 100)))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.06, end: 0, duration: 400.ms);
  }
}
