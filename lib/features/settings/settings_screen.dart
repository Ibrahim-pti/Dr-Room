import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/dr_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              const SizedBox(height: 20),
              Text(
                'ڕێکخستنەکان',
                style: AppTypography.headingLg.copyWith(
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 24),

              // ── Profile Card ──
              DrCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                      ),
                      child: const Icon(Iconsax.user, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'یەحیا ئەحمەد',
                            style: AppTypography.headingSm.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            '+964 750 XXX XXXX',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textMedium,
                            ),
                            textDirection: TextDirection.ltr,
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
                        border: Border.all(color: AppColors.cardBorder, width: 1),
                      ),
                      child: const Icon(
                        Iconsax.edit_2,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 28),

              // ── Settings Items ──
              _settingItem(
                Iconsax.user,
                'پرۆفایلی من',
                trailing: _chevron(),
                index: 0,
              ),
              _settingItem(
                Iconsax.global,
                'زمان',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'کوردی',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _chevron(),
                  ],
                ),
                index: 1,
              ),
              _settingItem(
                Iconsax.moon,
                'دۆخی تاریک',
                trailing: Switch.adaptive(
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                  activeTrackColor: AppColors.primary,
                ),
                index: 2,
              ),
              _settingItem(
                Iconsax.notification,
                'ئاگادارکردنەوەکان',
                trailing: Switch.adaptive(
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                  activeTrackColor: AppColors.primary,
                ),
                index: 3,
              ),
              _settingItem(
                Iconsax.lock,
                'ئاسایش و پاسوۆرد',
                trailing: _chevron(),
                index: 4,
              ),
              _settingItem(
                Iconsax.health,
                'یادەوەری دەرمان',
                trailing: _chevron(),
                index: 5,
              ),
              _settingItem(
                Iconsax.people,
                'بنەماڵەکانم',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: Text(
                          '3',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _chevron(),
                  ],
                ),
                index: 6,
              ),
              _settingItem(
                Iconsax.document,
                'مافی تایبەتمەندی',
                trailing: _chevron(),
                index: 7,
              ),
              _settingItem(
                Iconsax.info_circle,
                'دەربارەی DrRoom',
                trailing: Text(
                  'v1.0.0',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                index: 8,
              ),

              const SizedBox(height: 8),

              // ── Logout ──
              _settingItem(
                Iconsax.logout,
                'چوونە دەرەوە',
                iconColor: AppColors.error,
                textColor: AppColors.error,
                trailing: _chevron(color: AppColors.error),
                index: 9,
              ),

              const SizedBox(height: 20),

              // ── DrRoom Prime Banner ──
              DrCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF9D976), Color(0xFFF39F86)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderColor: const Color(0xFFF9D976).withValues(alpha: 0.3),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Text('💎', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'بوو بە DrRoom Prime!',
                            style: AppTypography.labelLg.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'داشکاندنی ٢٠% و تایبەتمەندی زیادە',
                            style: AppTypography.bodySm.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withValues(alpha: 0.25),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'زانیاری',
                        style: AppTypography.labelSm.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate(delay: Duration(milliseconds: 100 * 10))
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.1, end: 0, duration: 500.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingItem(
    IconData icon,
    String title, {
    Widget? trailing,
    Color? iconColor,
    Color? textColor,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: (iconColor ?? AppColors.primary).withValues(alpha: 0.08),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.bodyLg.copyWith(
                      color: textColor ?? AppColors.textDark,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn(duration: 300.ms);
  }

  Widget _chevron({Color? color}) => Icon(
        Icons.chevron_left_rounded,
        color: color ?? AppColors.textLight,
        size: 22,
      );
}
