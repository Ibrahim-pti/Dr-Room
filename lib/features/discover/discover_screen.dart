import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import '../../core/theme/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import '../../core/utils/api_client.dart';
import 'article_details_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  List<dynamic> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    try {
      final response = await ApiClient.get('/articles');
      if (response.statusCode == 200 && mounted) {
        setState(() {
          _articles = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getTranslated(dynamic article, String field, String langCode) {
    if (langCode == 'en' && article['${field}_en'] != null) {
      return article['${field}_en'];
    }
    if (langCode == 'ar' && article['${field}_ar'] != null) {
      return article['${field}_ar'];
    }
    return article[field] ?? '';
  }

  final List<Map<String, String>> _categories = const [
    {'name': 'All', 'icon': 'All'},
    {'name': 'Nutrition', 'icon': '🍏'},
    {'name': 'Fitness', 'icon': '💪'},
    {'name': 'Mental', 'icon': '🧠'},
    {'name': 'Sleep', 'icon': '😴'},
  ];

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(context),
        elevation: 0,
        title: Text(
          'discover'.tr(),
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
                    margin: const EdgeInsetsDirectional.only(end: 12),
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

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_articles.isNotEmpty) ...[
              // ── Featured Article ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'trending'.tr(),
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
                                'FEATURED',
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
                              _getTranslated(_articles[0], 'title', langCode),
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
                'articles'.tr(),
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
              itemCount: _articles.length > 1 ? _articles.length - 1 : 0,
              itemBuilder: (context, index) {
                final article = _articles[index + 1];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => ArticleDetailsScreen(article: article)));
                  },
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(bottom: 20),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: article['color'] ?? const Color(0xFF3B82F6),
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
                                (article['category'] ?? 'ARTICLE').toString().toUpperCase(),
                                style: GoogleFonts.poppins(
                                  color: article['color'] ?? const Color(0xFF3B82F6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getTranslated(article, 'title', langCode),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: AppColors.getTextTitle(context),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
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
                                    article['author'] ?? 'Dr. Room',
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
            ],
            
            const SizedBox(height: 80), // Padding for bottom nav
          ],
        ),
      ),
    );
  }
}
