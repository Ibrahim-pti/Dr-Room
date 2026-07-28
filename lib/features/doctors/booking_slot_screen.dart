import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/appointment_provider.dart';
import 'appointment_confirmation_screen.dart';

class BookingSlotScreen extends StatefulWidget {
  final dynamic doctor;

  const BookingSlotScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<BookingSlotScreen> createState() => _BookingSlotScreenState();
}

class _BookingSlotScreenState extends State<BookingSlotScreen> {
  late DateTime _selectedDate;
  String? _selectedTime;
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen: false)
          .fetchAvailableSlots(
        widget.doctor.id,
        fromDate: DateTime.now(),
        toDate: DateTime.now().add(const Duration(days: 30)),
      );
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Time', style: AppTypography.headingSm),
        elevation: 0,
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor summary
                _buildDoctorSummary(),
                const SizedBox(height: 24),

                // Date selection
                Text(
                  'Select Date',
                  style: AppTypography.headingSm.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDatePicker(),
                const SizedBox(height: 24),

                // Time slots
                Text(
                  'Select Time',
                  style: AppTypography.headingSm.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                if (provider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  _buildTimeSlots(provider),
                const SizedBox(height: 24),

                // Reason for visit
                Text(
                  'Reason for Visit',
                  style: AppTypography.headingSm.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    hintText: 'e.g., General checkup',
                    hintStyle: AppTypography.bodySm.copyWith(
                      color: AppColors.textMedium,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE8ECF4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE8ECF4),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLightSecondary,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Additional notes
                Text(
                  'Additional Notes (Optional)',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    hintText: 'Add any relevant medical history...',
                    hintStyle: AppTypography.bodySm.copyWith(
                      color: AppColors.textMedium,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE8ECF4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE8ECF4),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceLightSecondary,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _selectedTime == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AppointmentConfirmationScreen(
                                  doctor: widget.doctor,
                                  selectedDate: _selectedDate,
                                  selectedTime: _selectedTime!,
                                  reason: _reasonController.text,
                                  notes: _notesController.text,
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.textMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue to Payment',
                      style: AppTypography.button.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorSummary() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cardBorderLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
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
                    size: 24,
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
              ],
            ),
          ),
          Text(
            '\$${widget.doctor.consultationFee.toStringAsFixed(0)}',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(14, (index) {
          final date = DateTime.now().add(Duration(days: index + 1));
          final isSelected =
              _selectedDate.year == date.year &&
              _selectedDate.month == date.month &&
              _selectedDate.day == date.day;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.cardBorderLight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      _getWeekday(date.weekday),
                      style: AppTypography.labelSm.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textMedium,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${date.day}',
                      style: AppTypography.labelMd.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimeSlots(AppointmentProvider provider) {
    final slotsForDate = provider.availableSlots
        .where((slot) =>
            slot.date.year == _selectedDate.year &&
            slot.date.month == _selectedDate.month &&
            slot.date.day == _selectedDate.day &&
            slot.isAvailable)
        .toList();

    if (slotsForDate.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(
              Iconsax.clock,
              size: 48,
              color: AppColors.textMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'No slots available',
              style: AppTypography.labelMd.copyWith(
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: slotsForDate.length,
      itemBuilder: (context, index) {
        final slot = slotsForDate[index];
        final isSelected = _selectedTime == slot.time;

        return GestureDetector(
          onTap: () {
            setState(() => _selectedTime = slot.time);
            Provider.of<AppointmentProvider>(context, listen: false)
                .selectSlot(slot);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.cardBorderLight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  slot.time,
                  style: AppTypography.labelMd.copyWith(
                    color: isSelected ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${slot.maxPatients - slot.bookedPatients} slots',
                  style: AppTypography.bodySm.copyWith(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.8)
                        : AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getWeekday(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
