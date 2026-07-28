import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/providers/appointment_provider.dart';
import '../../core/models/appointment_model.dart' show Doctor;
import 'doctor_profile_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedSpeciality;
  double? _selectedRating;

  final List<String> _specialities = [
    'All',
    'Cardiology',
    'Neurology',
    'Dermatology',
    'Pediatrics',
    'Orthopedics',
    'General',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen: false).fetchDoctors();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged() {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    provider.fetchDoctors(
      search: _searchController.text.isEmpty ? null : _searchController.text,
      speciality: _selectedSpeciality == 'All' ? null : _selectedSpeciality,
      minRating: _selectedRating,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Doctors', style: AppTypography.headingSm),
        elevation: 0,
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Search bar
                _buildSearchBar(),

                // Speciality filter
                _buildSpecialityFilter(),

                // Rating filter
                _buildRatingFilter(),

                // Doctors list
                if (appointmentProvider.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  )
                else if (appointmentProvider.doctors.isEmpty)
                  _buildEmptyState()
                else
                  _buildDoctorsList(appointmentProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => _onFilterChanged(),
        decoration: InputDecoration(
          hintText: 'Search doctors...',
          hintStyle: AppTypography.bodySm.copyWith(
            color: AppColors.textMedium,
          ),
          prefixIcon: Icon(
            Iconsax.search_normal,
            color: AppColors.textMedium,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    _onFilterChanged();
                  },
                  child: Icon(
                    Iconsax.close_circle,
                    color: AppColors.textMedium,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8ECF4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E86DE)),
          ),
          filled: true,
          fillColor: AppColors.surfaceLightSecondary,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSpecialityFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _specialities.map((speciality) {
            final isSelected = _selectedSpeciality == speciality;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSpeciality =
                        isSelected ? null : speciality;
                  });
                  _onFilterChanged();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceLightSecondary,
                    borderRadius: BorderRadius.circular(20),
                    border: !isSelected
                        ? Border.all(color: AppColors.cardBorderLight)
                        : null,
                  ),
                  child: Text(
                    speciality,
                    style: AppTypography.labelSm.copyWith(
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRatingFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              'Rating: ',
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textDark,
              ),
            ),
            ...([null, 3.0, 4.0, 4.5, 5.0].map((rating) {
              final isSelected = _selectedRating == rating;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = isSelected ? null : rating;
                    });
                    _onFilterChanged();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceLightSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: !isSelected
                          ? Border.all(color: AppColors.cardBorderLight)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.star,
                          size: 14,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating == null ? 'All' : rating.toString(),
                          style: AppTypography.bodySm.copyWith(
                            color:
                                isSelected ? Colors.white : AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorsList(AppointmentProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: provider.doctors.length,
      itemBuilder: (context, index) {
        final doctor = provider.doctors[index];
        return _buildDoctorCard(context, doctor);
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, Doctor doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfileScreen(
              doctorId: doctor.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBorderLight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Doctor image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceLightSecondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: doctor.profileImage.isNotEmpty
                  ? Image.network(
                      doctor.profileImage,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Iconsax.user,
                      color: AppColors.primary,
                      size: 32,
                    ),
            ),
            const SizedBox(width: 12),
            // Doctor info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: AppTypography.labelMd.copyWith(
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.speciality,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Iconsax.star,
                        size: 14,
                        color: const Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${doctor.rating} (${doctor.reviewCount})',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Fee
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${doctor.consultationFee.toStringAsFixed(0)}',
                  style: AppTypography.labelMd.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(
                  Iconsax.arrow_right_3,
                  size: 20,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Iconsax.user,
            size: 64,
            color: AppColors.textMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'No doctors found',
            style: AppTypography.labelMd.copyWith(
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textMedium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
