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

  final List<String> _commonConditions = [
    'Diabetes',
    'Asthma',
    'Hypertension',
    'Allergies',
    'Thyroid',
    'Migraine',
    'Arthritis',
    'Heart Disease',
  ];
  final Set<String> _selectedConditions = {};

  static const Color primaryColor = Color(0xFF3B82F6);
  static const Color lightBlueSoft = Color(0xFFEFF6FF);
  static const Color darkSlate = Color(0xFF1E293B);
  static const Color secondarySlate = Color(0xFF64748B);
  static const Color bgSurface = Color(0xFFF8FAFC);

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
      String chronicText = _chronicController.text.trim();
      if (_selectedConditions.isNotEmpty) {
        chronicText = [
          ..._selectedConditions,
          if (chronicText.isNotEmpty) chronicText,
        ].join(', ');
      }
      await prefs.setString('guest_chronic_details', chronicText);
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

  void _skipSetup() {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _toggleConditionTag(String condition) {
    setState(() {
      if (_selectedConditions.contains(condition)) {
        _selectedConditions.remove(condition);
      } else {
        _selectedConditions.add(condition);
        _hasChronicDiseases = true;
      }
    });
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
      backgroundColor: bgSurface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(progress: 1.0),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    Center(
                      child: Text(
                        'medical_history_title'.tr(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: darkSlate,
                          height: 1.3,
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
                          color: secondarySlate,
                          height: 1.4,
                        ),
                      ).animate().fadeIn(delay: 100.ms),
                    ),

                    const SizedBox(height: 24),

                    _buildMedicalConditionTags().animate().fadeIn(delay: 150.ms),

                    const SizedBox(height: 24),

                    _buildQuestionCard(
                      question: 'allergies_question'.tr(),
                      value: _hasAllergies,
                      icon: Iconsax.danger_copy,
                      onChanged: (val) => setState(() => _hasAllergies = val),
                      controller: _allergiesController,
                      hintText: 'allergies_hint'.tr(),
                      delay: 200,
                    ),

                    _buildQuestionCard(
                      question: 'chronic_diseases_question'.tr(),
                      value: _hasChronicDiseases,
                      icon: Iconsax.activity_copy,
                      onChanged: (val) => setState(() => _hasChronicDiseases = val),
                      controller: _chronicController,
                      hintText: 'chronic_diseases_hint'.tr(),
                      delay: 300,
                    ),

                    _buildQuestionCard(
                      question: 'medications_question'.tr(),
                      value: _takesMedications,
                      icon: Iconsax.hospital_copy,
                      onChanged: (val) => setState(() => _takesMedications = val),
                      controller: _medicationsController,
                      hintText: 'medications_hint'.tr(),
                      delay: 400,
                    ),

                    _buildQuestionCard(
                      question: 'smoking_question'.tr(),
                      value: _smokes,
                      icon: Iconsax.warning_2_copy,
                      onChanged: (val) => setState(() => _smokes = val),
                      delay: 500,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Action Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _completeSetup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: primaryColor.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'finish_setup'.tr(),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader({required double progress}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: darkSlate,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: _skipSetup,
            style: TextButton.styleFrom(
              foregroundColor: secondarySlate,
              textStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Text('skip'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalConditionTags() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Iconsax.health_copy, size: 18, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                'Quick Select Conditions',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: darkSlate,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonConditions.map((condition) {
              final isSelected = _selectedConditions.contains(condition);
              return GestureDetector(
                onTap: () => _toggleConditionTag(condition),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? lightBlueSoft : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.check_rounded,
                            size: 14,
                            color: primaryColor,
                          ),
                        ),
                      Text(
                        condition,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? primaryColor : darkSlate,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required String question,
    required bool? value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
    TextEditingController? controller,
    String? hintText,
    required int delay,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value != null
              ? primaryColor.withValues(alpha: 0.3)
              : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: lightBlueSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: darkSlate,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildChoicePill(
                  title: 'yes'.tr(),
                  optionValue: true,
                  currentValue: value,
                  onTap: () => onChanged(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChoicePill(
                  title: 'no'.tr(),
                  optionValue: false,
                  currentValue: value,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
          if (value == true && controller != null && hintText != null) ...[
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              style: GoogleFonts.poppins(
                color: darkSlate,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: primaryColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                hintText: hintText,
                hintStyle: GoogleFonts.poppins(
                  color: const Color(0xFF94A3B8),
                  fontSize: 13,
                ),
              ),
            ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.1),
          ],
        ],
      ),
    ).animate().fadeIn(delay: delay.ms);
  }

  Widget _buildChoicePill({
    required String title,
    required bool optionValue,
    required bool? currentValue,
    required VoidCallback onTap,
  }) {
    final isSelected = currentValue == optionValue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              optionValue ? Icons.check_circle_rounded : Icons.cancel_rounded,
              size: 18,
              color: isSelected ? Colors.white : secondarySlate,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Colors.white : darkSlate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
