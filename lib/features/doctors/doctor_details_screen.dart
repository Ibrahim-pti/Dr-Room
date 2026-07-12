import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/providers/favorite_provider.dart';
import 'chat_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String name;
  final String specialty;
  final String image;

  const DoctorDetailsScreen({
    super.key,
    required this.name,
    required this.specialty,
    required this.image,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;

  final List<Map<String, String>> _dates = [
    {'day': 'Mon', 'date': '12'},
    {'day': 'Tue', 'date': '13'},
    {'day': 'Wed', 'date': '14'},
    {'day': 'Thu', 'date': '15'},
    {'day': 'Fri', 'date': '16'},
    {'day': 'Sat', 'date': '17'},
  ];

  final List<String> _times = [
    '09:00 AM',
    '10:30 AM',
    '11:00 AM',
    '01:00 PM',
    '02:30 PM',
    '04:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.getSurface(context).withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 20,
                color: AppColors.getTextTitle(context),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.getSurface(context).withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, _) {
                  final isFavorite = favoriteProvider.isFavorite(widget.name);
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Iconsax.heart,
                      color: isFavorite ? const Color(0xFFEF4444) : AppColors.getTextTitle(context),
                    ),
                    onPressed: () {
                      favoriteProvider.toggleFavorite({
                        'doctor': widget.name,
                        'specialty': widget.specialty,
                        'image': widget.image,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite ? 'Removed from favorites' : 'Added to favorites',
                          ),
                          backgroundColor: isFavorite ? Colors.red : const Color(0xFF10B981),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Profile ──
                Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        top: 70,
                        bottom: 20,
                        left: 24,
                        right: 24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.getSurface(context),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Hero(
                            tag: widget.name,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF3B82F6),
                                  width: 3,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(widget.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.name,
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextTitle(context),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.specialty,
                            style: GoogleFonts.poppins(
                              color: AppColors.textLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem(
                                'Patients',
                                '1.5k+',
                                Iconsax.people,
                              ),
                              _buildStatItem(
                                'Experience',
                                '8 yr+',
                                Iconsax.briefcase,
                              ),
                              _buildStatItem('Rating', '4.9', Iconsax.star),
                            ],
                          ),
                        ],
                      ),
                    )
                    .animate()
                    .slideY(begin: -0.2, end: 0)
                    .fadeIn(duration: 500.ms),

                const SizedBox(height: 24),

                // ── About Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Doctor',
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextTitle(context),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.name} is one of the most professional doctors in the region. Specializing in ${widget.specialty}, providing excellent care and precise diagnostics for all patients.',
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextSubtitle(context),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.1, end: 0),

                const SizedBox(height: 24),

                // ── Calendar Selection ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Select Date',
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextTitle(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate(delay: 300.ms).fadeIn(),
                const SizedBox(height: 12),
                SizedBox(
                  height: 76,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _dates.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedDateIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDateIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : AppColors.getSurface(context),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.getBorder(context),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _dates[index]['day']!,
                                style: GoogleFonts.poppins(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : AppColors.getTextSubtitle(context),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _dates[index]['date']!,
                                style: GoogleFonts.poppins(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.getTextTitle(context),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ).animate(delay: 400.ms).fadeIn().slideX(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // ── Time Slots ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Available Time',
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextTitle(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate(delay: 500.ms).fadeIn(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(_times.length, (index) {
                      final isSelected = _selectedTimeIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTimeIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF3B82F6).withValues(alpha: 0.1)
                                : AppColors.getSurface(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.getBorder(context),
                            ),
                          ),
                          child: Text(
                            _times[index],
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.getTextTitle(context),
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.1, end: 0),
              ],
            ),
          ),

          // ── Bottom Action Bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: 0,
                left: 24,
                right: 24,
                bottom: 0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.message,
                        color: Color(0xFF10B981),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              doctorName: widget.name,
                              doctorImage: widget.image,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _selectedTimeIndex != -1
                            ? () {
                                // Booking Action
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Appointment booked successfully!',
                                    ),
                                    backgroundColor: Color(0xFF10B981),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          disabledBackgroundColor: const Color(
                            0xFF3B82F6,
                          ).withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Book Appointment',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF3B82F6), size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: AppColors.getTextTitle(context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 11),
        ),
      ],
    );
  }
}
