import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SelectTestsScreen extends StatefulWidget {
  const SelectTestsScreen({super.key});

  @override
  State<SelectTestsScreen> createState() => _SelectTestsScreenState();
}

class _SelectTestsScreenState extends State<SelectTestsScreen> {
  final List<Map<String, dynamic>> _tests = [
    {'name': 'Complete Blood Count (CBC)', 'price': '\$15', 'selected': false},
    {'name': 'Lipid Profile', 'price': '\$25', 'selected': false},
    {'name': 'Blood Sugar (Fasting)', 'price': '\$10', 'selected': false},
    {'name': 'Thyroid Profile (T3, T4, TSH)', 'price': '\$35', 'selected': false},
    {'name': 'Vitamin D', 'price': '\$40', 'selected': false},
    {'name': 'Liver Function Test (LFT)', 'price': '\$30', 'selected': false},
    {'name': 'Kidney Function Test (KFT)', 'price': '\$28', 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    int selectedCount = _tests.where((t) => t['selected']).length;

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
          'Select Tests',
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
                  'Choose your tests',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0F172A),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ).animate().fadeIn().slideX(begin: -0.1, end: 0),
                const SizedBox(height: 8),
                Text(
                  'Select one or more tests you want to include in your request.',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64748B),
                    fontSize: 15,
                    height: 1.5,
                  ),
                ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              itemCount: _tests.length,
              itemBuilder: (context, index) {
                final test = _tests[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: test['selected'] ? const Color(0xFF3B82F6) : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CheckboxListTile(
                    value: test['selected'],
                    onChanged: (val) {
                      setState(() {
                        test['selected'] = val;
                      });
                    },
                    activeColor: const Color(0xFF3B82F6),
                    checkboxShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    title: Text(
                      test['name'],
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF0F172A),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      test['price'],
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF3B82F6),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: (150 + index * 50).ms).slideY(begin: 0.1, end: 0);
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
                        '$selectedCount Tests',
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
                              // Navigate to next step
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
