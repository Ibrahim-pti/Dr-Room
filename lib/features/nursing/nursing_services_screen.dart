import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class NursingServicesScreen extends StatefulWidget {
  const NursingServicesScreen({super.key});

  @override
  State<NursingServicesScreen> createState() => _NursingServicesScreenState();
}

class _NursingServicesScreenState extends State<NursingServicesScreen> {
  final List<Map<String, dynamic>> _services = [
    {
      'title': 'Injection',
      'subtitle': 'IM, IV, or Subcutaneous injections at home',
      'icon': Iconsax.health,
      'color': const Color(0xFF3B82F6),
      'selected': false,
    },
    {
      'title': 'Cannula Insertion',
      'subtitle': 'Professional IV cannula insertion and care',
      'icon': Iconsax.activity,
      'color': const Color(0xFF10B981),
      'selected': false,
    },
    {
      'title': 'Wound Dressing',
      'subtitle': 'Cleaning and dressing for wounds and post-surgery',
      'icon': Icons.healing_outlined,
      'color': const Color(0xFFF59E0B),
      'selected': false,
    },
    {
      'title': 'Quick Care',
      'subtitle': 'Basic checkup, blood pressure, and vitals monitoring',
      'icon': Iconsax.heart,
      'color': const Color(0xFFEF4444),
      'selected': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    int selectedCount = _services.where((s) => s['selected']).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF0F172A), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Nursing Services',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What do you need?',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0F172A),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Select the nursing services you require. Our professional nurses will come to your home.',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64748B),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                final isSelected = service['selected'] as bool;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      service['selected'] = !isSelected;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: service['color'].withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            service['icon'],
                            color: service['color'],
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service['title'],
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF0F172A),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                service['subtitle'],
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF64748B),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                              width: 2,
                            ),
                            color: isSelected ? const Color(0xFF3B82F6) : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : null,
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (200 + index * 100).ms).slideY(begin: 0.1, end: 0),
                );
              },
            ),
          ),
          
          // Bottom Container
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selected',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF64748B),
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '$selectedCount Services',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0F172A),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 56,
                    width: 160,
                    child: ElevatedButton(
                      onPressed: selectedCount > 0
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Request sent successfully!',
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  backgroundColor: const Color(0xFF10B981),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        disabledBackgroundColor: const Color(0xFF94A3B8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
