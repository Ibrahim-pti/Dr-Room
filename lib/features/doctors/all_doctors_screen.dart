import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../home/doctor_details_screen.dart';

class AllDoctorsScreen extends StatelessWidget {
  const AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctors = [
      {
        'name': 'Dr. Nusrat Jahan',
        'specialty': 'Pediatrician Specialist',
        'rating': '4.9',
        'image': 'assets/images/doctor3.png',
      },
      {
        'name': 'Dr. Ayesha Rahman',
        'specialty': 'Skin Specialist',
        'rating': '4.8',
        'image': 'assets/images/doctor1.png',
      },
      {
        'name': 'Dr. Sarah Lee',
        'specialty': 'Dentist',
        'rating': '4.7',
        'image': 'assets/images/doctor2.png',
      },
      {
        'name': 'Dr. John Doe',
        'specialty': 'Cardiologist',
        'rating': '4.9',
        'image': 'assets/images/doctor3.png', // reusing image
      },
    ];

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
          'Top Doctors',
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doc = doctors[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorDetailsScreen(),
                  ),
                );
              },
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['name']!.replaceFirst(' ', '\n'), // Split into two lines like design
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF0F172A),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doc['specialty']!,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFBBF24),
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                doc['rating']!,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF0F172A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(24),
                        ),
                        child: Image.asset(
                          doc['image']!,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF0F4FD),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Color(0xFF3B82F6),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0),
          );
        },
      ),
    );
  }
}
