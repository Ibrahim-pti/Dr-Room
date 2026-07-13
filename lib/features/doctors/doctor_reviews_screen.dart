import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/theme/app_colors.dart';

class DoctorReviewsScreen extends StatefulWidget {
  final String doctorName;
  final String rating;

  const DoctorReviewsScreen({
    super.key,
    required this.doctorName,
    required this.rating,
  });

  @override
  State<DoctorReviewsScreen> createState() => _DoctorReviewsScreenState();
}

class _DoctorReviewsScreenState extends State<DoctorReviewsScreen> {
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Ahmed Ali',
      'date': 'Oct 12, 2026',
      'rating': 5,
      'comment': 'Dr. ${'Sarah'} is incredibly professional and caring. She took the time to listen to all my concerns and explained everything clearly. Highly recommended!',
      'image': 'https://i.pravatar.cc/150?img=11',
    },
    {
      'name': 'Fatima Hassan',
      'date': 'Oct 5, 2026',
      'rating': 4,
      'comment': 'Great experience overall. The clinic was clean and the staff was friendly. The wait time was a bit long, but the doctor was excellent.',
      'image': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'name': 'Omer Khalid',
      'date': 'Sep 28, 2026',
      'rating': 5,
      'comment': 'Very knowledgeable doctor. Diagnosed my issue immediately and prescribed the right medication. I feel much better now.',
      'image': 'https://i.pravatar.cc/150?img=12',
    },
    {
      'name': 'Zainab Qasim',
      'date': 'Sep 15, 2026',
      'rating': 5,
      'comment': 'Best doctor I have visited in the region. Truly cares about her patients.',
      'image': 'https://i.pravatar.cc/150?img=9',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'reviews_ratings'.tr(),
          style: GoogleFonts.poppins(
            color: AppColors.getTextTitle(context),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.getTextTitle(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                _buildRatingSummary(),
                const SizedBox(height: 16),
                _buildReviewList(),
              ],
            ),
          ),
          
          // ── Bottom Action ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: 16,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _showWriteReviewBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'write_review'.tr(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      color: AppColors.getSurface(context),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                widget.rating,
                style: GoogleFonts.poppins(
                  color: AppColors.getTextTitle(context),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Iconsax.star_1,
                    color: index < 4 ? const Color(0xFFF59E0B) : const Color(0xFFF59E0B).withValues(alpha: 0.3),
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 8),
              Text(
                'based_on_reviews'.tr(),
                style: GoogleFonts.poppins(
                  color: AppColors.getTextSubtitle(context),
                  fontSize: 12,
                ),
              ),
            ],
          ).animate().fadeIn().slideX(begin: -0.2, end: 0),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(5, 0.8),
                _buildRatingBar(4, 0.15),
                _buildRatingBar(3, 0.05),
                _buildRatingBar(2, 0.0),
                _buildRatingBar(1, 0.0),
              ],
            ).animate().fadeIn().slideX(begin: 0.2, end: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: GoogleFonts.poppins(
              color: AppColors.getTextTitle(context),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: AppColors.getBorder(context),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: _reviews.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final review = _reviews[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(review['image']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['name'],
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextTitle(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        review['date'],
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextSubtitle(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      Iconsax.star_1,
                      color: starIndex < review['rating'] ? const Color(0xFFF59E0B) : AppColors.getBorder(context),
                      size: 14,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              review['comment'],
              style: GoogleFonts.poppins(
                color: AppColors.getTextTitle(context),
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ).animate(delay: (100 * index).ms).fadeIn().slideY(begin: 0.1, end: 0);
      },
    );
  }

  void _showWriteReviewBottomSheet(BuildContext context) {
    int selectedRating = 5;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.getBorder(context),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'How was your experience?',
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextTitle(context),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rate Dr. ${widget.doctorName}',
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextSubtitle(context),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating ? Iconsax.star_1 : Iconsax.star,
                          color: const Color(0xFFF59E0B),
                          size: 36,
                        ),
                        onPressed: () {
                          setModalState(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.getBorder(context)),
                    ),
                    child: TextField(
                      maxLines: 4,
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextTitle(context),
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write your review here...',
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.getTextSubtitle(context),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Review submitted successfully!'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Submit Review',
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
            );
          }
        );
      },
    );
  }
}
