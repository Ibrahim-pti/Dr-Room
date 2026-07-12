import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'article_details_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  final List<Map<String, String>> _categories = const [
    {'name': 'All', 'icon': 'All'},
    {'name': 'Nutrition', 'icon': '🍏'},
    {'name': 'Fitness', 'icon': '💪'},
    {'name': 'Mental', 'icon': '🧠'},
    {'name': 'Sleep', 'icon': '😴'},
  ];

  final List<Map<String, dynamic>> _articles = const [
    {
      'title': 'The Hidden Benefits of Vitamin D',
      'author': 'Dr. Sara Ahmed',
      'category': 'Nutrition',
      'time': '5 min read',
      'image': 'assets/images/placeholder.png',
      'color': Color(0xFFFBBF24),
    },
    {
      'title': 'How to Build a Perfect Sleep Routine',
      'author': 'Dr. Zana Ali',
      'category': 'Sleep',
      'time': '8 min read',
      'image': 'assets/images/placeholder.png',
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'Mental Health in the Digital Age',
      'author': 'Dr. Niga Omar',
      'category': 'Mental',
      'time': '10 min read',
      'image': 'assets/images/placeholder.png',
      'color': Color(0xFF3B82F6),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        title: Text(
          'Discover Health',
          style: GoogleFonts.poppins(
            color: AppColors.getTextTitle(context),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.search_normal_1, color: AppColors.getTextTitle(context)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Categories ──
            SizedBox(
              height: 48,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = index == 0;
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF3B82F6) : AppColors.getSurface(context),
                      borderRadius: BorderRadius.circular(24),
                      border: isSelected ? null : Border.all(color: AppColors.getBorder(context)),
                    ),
                    child: Row(
                      children: [
                        if (cat['icon'] != 'All') ...[
                          Text(cat['icon']!, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          cat['name']!,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : AppColors.getTextSubtitle(context),
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (50 * index).ms).slideX(begin: 0.2, end: 0);
                },
              ),
            ),
            
            const SizedBox(height: 32),

            // ── Featured Article ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Featured Today',
                style: GoogleFonts.poppins(
                  color: AppColors.getTextTitle(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetailsScreen(article: _articles[0])));
                },
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFBBF24).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Using a simple gradient instead of an image mockup for the featured card
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'NUTRITION',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'The Hidden Benefits\nof Vitamin D',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Iconsax.clock, color: Colors.white70, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '5 min read',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
            ),

            const SizedBox(height: 32),

            // ── Recent Articles ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Recent Articles',
                style: GoogleFonts.poppins(
                  color: AppColors.getTextTitle(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),

            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _articles.length - 1,
              itemBuilder: (context, index) {
                final article = _articles[index + 1];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetailsScreen(article: article)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: article['color'],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Icon(Iconsax.document, color: Colors.white.withValues(alpha: 0.5), size: 40),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article['category'],
                                style: GoogleFonts.poppins(
                                  color: article['color'],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                article['title'],
                                style: GoogleFonts.poppins(
                                  color: AppColors.getTextTitle(context),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE2E8F0),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.person, size: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    article['author'],
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextSubtitle(context),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: (300 + (100 * index)).ms).slideX(begin: 0.1, end: 0);
              },
            ),
            
            const SizedBox(height: 80), // Padding for bottom nav
          ],
        ),
      ),
    );
  }
}
