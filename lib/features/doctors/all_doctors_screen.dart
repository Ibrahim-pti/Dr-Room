import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'doctor_details_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import '../../core/utils/api_client.dart';

class AllDoctorsScreen extends StatefulWidget {
  const AllDoctorsScreen({super.key});

  @override
  State<AllDoctorsScreen> createState() => _AllDoctorsScreenState();
}

class _AllDoctorsScreenState extends State<AllDoctorsScreen> {
  bool _isLoading = true;
  List<dynamic> _doctors = [];

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiClient.get('/doctors');
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _doctors = jsonDecode(response.body);
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching doctors: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF0F172A),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'top_doctors'.tr(),
          style: GoogleFonts.poppins(
            color: const Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _doctors.isEmpty
              ? Center(child: Text('No doctors found.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  itemCount: _doctors.length,
                  itemBuilder: (context, index) {
                    final doc = _doctors[index];
                    // Handle dynamic backend mapping
                    final name = doc['user'] != null ? doc['user']['name'] : 'Doctor';
                    final specialty = doc['specialty'] ?? 'Specialist';
                    final rating = doc['rating']?.toString() ?? '5.0';
                    final image = (doc['image_path'] != null)
                        ? 'http://127.0.0.1:8000/storage/${doc['image_path']}'
                        : 'assets/images/doctor1.png'; // Fallback
                    final doctorId = doc['id'];

                    return Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDetailsScreen(
                                doctorId: doctorId,
                                name: name,
                                specialty: specialty,
                                image: image, // In real app, we need to pass a network image flag or handle NetworkImage
                              ),
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
                                      name.replaceFirst(' ', '\n'), // Split into two lines like design
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF0F172A),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      specialty,
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
                                          rating,
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
                              PositionedDirectional(
                                end: 0,
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadiusDirectional.only(
                                    bottomEnd: Radius.circular(24),
                                  ),
                                  child: doc['image_path'] != null
                                      ? Image.network(
                                          image,
                                          height: 150,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          image,
                                          height: 150,
                                          width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              PositionedDirectional(
                                top: 16,
                                end: 16,
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
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (100 * index).ms)
                    .slideY(begin: 0.1, end: 0);
                  },
                ),
    );
  }
}
