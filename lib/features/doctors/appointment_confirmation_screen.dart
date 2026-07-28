import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/appointment_provider.dart';
import '../checkout/payment_screen.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  final dynamic doctor;
  final DateTime selectedDate;
  final String selectedTime;
  final String reason;
  final String notes;

  const AppointmentConfirmationScreen({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.reason,
    required this.notes,
  });

  @override
  State<AppointmentConfirmationScreen> createState() =>
      _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen> {
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Appointment', style: AppTypography.headingSm),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor info card
            _buildDoctorCard(),
            const SizedBox(height: 24),

            // Appointment details
            Text(
              'Appointment Details',
              style: AppTypography.headingSm.copyWith(
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Iconsax.calendar,
              title: 'Date & Time',
              value: _formatDateTime(),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              icon: Iconsax.note,
              title: 'Reason for Visit',
              value: widget.reason.isEmpty ? 'Not specified' : widget.reason,
            ),
            if (widget.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailRow(
                icon: Iconsax.document,
                title: 'Notes',
                value: widget.notes,
              ),
            ],
            const SizedBox(height: 24),

            // Cost breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceLightSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Consultation Fee',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                      Text(
                        '\$${widget.doctor.consultationFee.toStringAsFixed(2)}',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Booking Fee',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                      Text(
                        '\$0.00',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '\$${widget.doctor.consultationFee.toStringAsFixed(2)}',
                        style: AppTypography.headingSm.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Terms agreement
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() => _agreeToTerms = value ?? false);
                  },
                  activeColor: AppColors.primary,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textMedium,
                        ),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Cancellation Policy',
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Book button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _agreeToTerms ? () => _proceedToPayment() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.textMedium,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Proceed to Payment',
                  style: AppTypography.button.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info text
            Center(
              child: Text(
                'You can cancel up to 24 hours before appointment',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surfaceLightSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.doctor.profileImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.doctor.profileImage,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Iconsax.user,
                    color: AppColors.primary,
                    size: 32,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor.name,
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  widget.doctor.speciality,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Iconsax.star,
                      size: 14,
                      color: const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.doctor.rating} (${widget.doctor.reviewCount})',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLightSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTypography.labelSm.copyWith(
                    color: AppColors.textDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime() {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final month = monthNames[widget.selectedDate.month - 1];
    final day = widget.selectedDate.day;
    final year = widget.selectedDate.year;
    return '$month $day, $year at ${widget.selectedTime}';
  }

  void _proceedToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          amount: widget.doctor.consultationFee,
          description: 'Appointment with ${widget.doctor.name}',
          type: 'appointment',
          metadata: {
            'doctorId': widget.doctor.id,
            'doctorName': widget.doctor.name,
            'date': widget.selectedDate.toIso8601String(),
            'time': widget.selectedTime,
            'reason': widget.reason,
            'notes': widget.notes,
          },
          onSuccess: () => _handlePaymentSuccess(),
          onError: (error) => _handlePaymentError(error),
        ),
      ),
    );
  }

  void _handlePaymentSuccess() {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    provider.bookAppointment(
      reason: widget.reason,
      notes: widget.notes,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Appointment booked successfully!'),
        backgroundColor: AppColors.success,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    });
  }

  void _handlePaymentError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
