import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HealthProfileScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const HealthProfileScreen({super.key, required this.onFinished});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  String? _selectedGender;
  String? _selectedBloodType;
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  Future<void> _completeSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_setup', true);

    // Save local health data
    if (_selectedGender != null)
      await prefs.setString('guest_gender', _selectedGender!);
    if (_selectedBloodType != null)
      await prefs.setString('guest_blood_type', _selectedBloodType!);
    if (_ageController.text.isNotEmpty)
      await prefs.setString('guest_age', _ageController.text);
    if (_weightController.text.isNotEmpty)
      await prefs.setString('guest_weight', _weightController.text);
    if (_heightController.text.isNotEmpty)
      await prefs.setString('guest_height', _heightController.text);

    widget.onFinished();
  }

  Future<void> _skipSetup() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_completed_setup', true);
    widget.onFinished();
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E293B),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _skipSetup,
            child: Text(
              'skip'.tr(),
              style: GoogleFonts.poppins(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'health_profile_title'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

              const SizedBox(height: 8),

              Text(
                'health_profile_subtitle'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 100.ms),

              const SizedBox(height: 32),

              // Gender Selection
              Text(
                'gender'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildGenderCard(
                      'male'.tr(),
                      Icons.male_rounded,
                      'Male',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildGenderCard(
                      'female'.tr(),
                      Icons.female_rounded,
                      'Female',
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 24),

              // Age & Blood Type
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'age'.tr(),
                      controller: _ageController,
                      icon: Iconsax.calendar_1,
                      keyboardType: TextInputType.number,
                      delay: 400,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildBloodTypeDropdown(delay: 500)),
                ],
              ),

              const SizedBox(height: 24),

              // Weight & Height
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'weight_kg'.tr(),
                      controller: _weightController,
                      icon: Iconsax.weight,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      delay: 600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      label: 'height_cm'.tr(),
                      controller: _heightController,
                      icon: Iconsax.ruler,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      delay: 700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _completeSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'save_and_continue'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard(String title, IconData icon, String value) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : const Color(0xFFE2E8F0),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : const Color(0xFF64748B),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required TextInputType keyboardType,
    required int delay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(color: const Color(0xFF1E293B)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: delay.ms);
  }

  Widget _buildBloodTypeDropdown({required int delay}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'blood_type'.tr(),
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedBloodType,
              hint: Text(
                'select'.tr(),
                style: GoogleFonts.poppins(color: const Color(0xFF94A3B8)),
              ),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF94A3B8),
              ),
              items: _bloodTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(
                    type,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedBloodType = newValue;
                });
              },
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: delay.ms);
  }
}
