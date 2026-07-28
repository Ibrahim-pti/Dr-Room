import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/appointment_provider.dart';
import 'booking_slot_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final String doctorId;

  const DoctorProfileScreen({
    super.key,
    required this.doctorId,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppointmentProvider>(context, listen: false);
      provider.fetchDoctorDetails(widget.doctorId);
      provider.fetchDoctorReviews(widget.doctorId);
      provider.fetchAvailableSlots(widget.doctorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile', style: AppTypography.headingSm),
        elevation: 0,
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.selectedDoctor == null) {
            return Center(
              child: Text('Doctor not found', style: AppTypography.labelMd),
            );
          }

          final doctor = provider.selectedDoctor!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDoctorHeader(doctor),
                _buildStatsRow(doctor),
                _buildAboutSection(doctor),
                _buildQualificationSection(doctor),
                _buildReviewsSection(provider),
                _buildBookButton(context, doctor),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorHeader(dynamic doctor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: doctor.profileImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      doctor.profileImage,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Iconsax.user,
                    size: 64,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            doctor.name,
            style: AppTypography.headingSm.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            doctor.speciality,
            style: AppTypography.bodySm.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.star,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  '${doctor.rating} • ${doctor.reviewCount} reviews',
                  style: AppTypography.bodySm.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(dynamic doctor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Iconsax.star,
              value: '${doctor.rating}',
              label: 'Rating',
              valueColor: const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Iconsax.briefcase,
              value: '${doctor.yearsExperience}',
              label: 'Years',
              valueColor: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Iconsax.moneys,
              value: '\$${doctor.consultationFee.toStringAsFixed(0)}',
              label: 'Fee',
              valueColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: valueColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.labelMd.copyWith(color: valueColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.bodySm.copyWith(color: AppColors.textMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(dynamic doctor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: AppTypography.headingSm.copyWith(color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            doctor.bio,
            style: AppTypography.bodySm.copyWith(color: AppColors.textMedium),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLightSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Iconsax.location, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clinic',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                      Text(
                        doctor.clinicName,
                        style: AppTypography.labelSm.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationSection(dynamic doctor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Qualification',
            style: AppTypography.headingSm.copyWith(color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Text(
            doctor.qualification,
            style: AppTypography.bodySm.copyWith(color: AppColors.textMedium),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Iconsax.tick_circle,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Verified Doctor',
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(AppointmentProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: AppTypography.headingSm.copyWith(
                  color: AppColors.textDark,
                ),
              ),
              Text(
                'See all',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (provider.doctorReviews.isEmpty)
            Text(
              'No reviews yet',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textMedium,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (provider.doctorReviews.length > 3
                  ? 3
                  : provider.doctorReviews.length),
              itemBuilder: (context, index) {
                final review = provider.doctorReviews[index];
                return _buildReviewCard(review);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.user,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: AppTypography.labelSm.copyWith(
                        color: AppColors.textDark,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Iconsax.star,
                          size: 12,
                          color: i < review.rating.toInt()
                              ? const Color(0xFFF59E0B)
                              : AppColors.textMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.review,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textMedium,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(BuildContext context, dynamic doctor) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingSlotScreen(
                  doctor: doctor,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Book Appointment - \$${doctor.consultationFee.toStringAsFixed(0)}',
            style: AppTypography.button.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
