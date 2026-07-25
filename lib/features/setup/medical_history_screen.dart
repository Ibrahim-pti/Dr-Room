import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const MedicalHistoryScreen({super.key, required this.onFinished});

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  bool? _hasAllergies;
  bool? _hasChronicDiseases;
  bool? _takesMedications;
  bool? _smokes;

  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _chronicController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();

  Future<void> _completeSetup() async {
    if (_hasAllergies == null ||
        _hasChronicDiseases == null ||
        _takesMedications == null ||
        _smokes == null) {
      _showError();
      return;
    }

    if ((_hasAllergies == true && _allergiesController.text.trim().isEmpty) ||
        (_hasChronicDiseases == true && _chronicController.text.trim().isEmpty) ||
        (_takesMedications == true && _medicationsController.text.trim().isEmpty)) {
      _showError();
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('guest_has_allergies', _hasAllergies!);
    if (_hasAllergies == true) {
      await prefs.setString('guest_allergies_details', _allergiesController.text.trim());
    }

    await prefs.setBool('guest_has_chronic', _hasChronicDiseases!);
    if (_hasChronicDiseases == true) {
      await prefs.setString('guest_chronic_details', _chronicController.text.trim());
    }

    await prefs.setBool('guest_takes_meds', _takesMedications!);
    if (_takesMedications == true) {
      await prefs.setString('guest_meds_details', _medicationsController.text.trim());
    }

    await prefs.setBool('guest_smokes', _smokes!);

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
    widget.onFinished();
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'fill_all_fields'.tr(),
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    _chronicController.dispose();
    _medicationsController.dispose();
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Iconsax.clipboard_text_copy,
                    size: 48,
                    color: Color(0xFF3B82F6),
                  ),
                ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
              ),
              const SizedBox(height: 24),

              Center(
                child: Text(
                  'medical_history_title'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'medical_history_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 100.ms),
              ),
              const SizedBox(height: 32),

              _buildQuestionSection(
                question: 'allergies_question'.tr(),
                value: _hasAllergies,
                onChanged: (val) => setState(() => _hasAllergies = val),
                controller: _allergiesController,
                hintText: 'allergies_hint'.tr(),
                inputIcon: Iconsax.danger_copy,
                delay: 200,
              ),

              _buildQuestionSection(
                question: 'chronic_diseases_question'.tr(),
                value: _hasChronicDiseases,
                onChanged: (val) => setState(() => _hasChronicDiseases = val),
                controller: _chronicController,
                hintText: 'chronic_diseases_hint'.tr(),
                inputIcon: Iconsax.activity_copy,
                delay: 300,
              ),

              _buildQuestionSection(
                question: 'medications_question'.tr(),
                value: _takesMedications,
                onChanged: (val) => setState(() => _takesMedications = val),
                controller: _medicationsController,
                hintText: 'medications_hint'.tr(),
                inputIcon: Iconsax.hospital_copy,
                delay: 400,
              ),

              _buildQuestionSection(
                question: 'smoking_question'.tr(),
                value: _smokes,
                onChanged: (val) => setState(() => _smokes = val),
                delay: 500,
              ),

              const SizedBox(height: 32),

              // Finish Button
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
                    elevation: 4,
                    shadowColor: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                  ),
                  child: Text(
                    'finish_setup'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection({
    required String question,
    required bool? value,
    required ValueChanged<bool> onChanged,
    TextEditingController? controller,
    String? hintText,
    IconData? inputIcon,
    required int delay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildChoiceCard(
                title: 'yes'.tr(),
                icon: Icons.check_circle_rounded,
                optionValue: true,
                currentValue: value,
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildChoiceCard(
                title: 'no'.tr(),
                icon: Icons.cancel_rounded,
                optionValue: false,
                currentValue: value,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        if (value == true && controller != null && hintText != null && inputIcon != null) ...[
          const SizedBox(height: 16),
          _buildInputField(
            hint: hintText,
            controller: controller,
            icon: inputIcon,
          ),
        ],
        const SizedBox(height: 32),
      ],
    ).animate().fadeIn(delay: delay.ms);
  }

  Widget _buildChoiceCard({
    required String title,
    required IconData icon,
    required bool optionValue,
    required bool? currentValue,
    required ValueChanged<bool> onChanged,
  }) {
    final isSelected = currentValue == optionValue;
    return GestureDetector(
      onTap: () => onChanged(optionValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
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
              size: 40,
              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(color: const Color(0xFF1E293B)),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF94A3B8),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF3B82F6).withValues(alpha: 0.7),
            size: 22,
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1);
  }
}
