import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> organData;

  const OrganDetailsScreen({super.key, required this.organData});

  @override
  State<OrganDetailsScreen> createState() => _OrganDetailsScreenState();
}

class _OrganDetailsScreenState extends State<OrganDetailsScreen> {
  String selectedTab = 'Overview';
  bool isFavorite = true;

  final Color primaryColor = const Color(0xFF6C4DFF);

  @override
  Widget build(BuildContext context) {
    final title = widget.organData['title'] ?? 'Heart';
    final imageUrl = widget.organData['imageUrl'] ??
        'https://pngimg.com/d/heart_PNG51334.png';
    final description = widget.organData['description'] ??
        'The heart is a muscular organ in most animals, which pumps blood through the blood vessels of the circulatory system.';

    final stats = widget.organData['stats'] as List<Map<String, dynamic>>? ??
        [
          {
            'value': '70-100',
            'label': 'Beats / Min',
            'icon': Icons.favorite_border
          },
          {
            'value': '250-350',
            'label': 'grams Weight',
            'icon': Icons.scale_outlined
          },
          {
            'value': 'Left Side',
            'label': 'of Chest',
            'icon': Icons.location_on_outlined
          },
          {
            'value': 'Life Long',
            'label': 'Duration',
            'icon': Icons.access_time_rounded
          },
        ];

    final functions = widget.organData['functions'] as List<String>? ??
        [
          'Pumps oxygenated blood to the body',
          'Pumps deoxygenated blood to the lungs',
          'Maintains blood pressure and flow',
          'Supports overall circulation',
        ];

    final fact = widget.organData['fact'] as String? ??
        'Your heart beats about 100,000 times a day and pumps over 7,500 liters of blood through your body.';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Colors.black87,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? primaryColor : Colors.grey.shade400,
            ),
            onPressed: () => setState(() => isFavorite = !isFavorite),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sub-navigation Chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['Overview', 'Anatomy', 'Function', 'Facts']
                          .map((tab) {
                        final isSelected = selectedTab == tab;
                        return GestureDetector(
                          onTap: () => setState(() => selectedTab = tab),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tab,
                              style: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // 3D Organ Illustration with Pointer Labels
                    Center(
                      child: SizedBox(
                        height: 260,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              imageUrl,
                              height: 220,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.favorite,
                                size: 160,
                                color: primaryColor,
                              ),
                            ),

                            // Pointers / Labels (e.g. Aorta, Left Atrium, etc.)
                            Positioned(
                              top: 20,
                              right: 20,
                              child: _buildPointerLabel('Aorta'),
                            ),
                            Positioned(
                              top: 80,
                              right: 10,
                              child: _buildPointerLabel('Left Atrium'),
                            ),
                            Positioned(
                              bottom: 50,
                              right: 15,
                              child: _buildPointerLabel('Left Ventricle'),
                            ),
                            Positioned(
                              top: 60,
                              left: 10,
                              child: _buildPointerLabel('Superior Vena Cava'),
                            ),
                            Positioned(
                              top: 120,
                              left: 15,
                              child: _buildPointerLabel('Right Atrium'),
                            ),
                            Positioned(
                              bottom: 60,
                              left: 20,
                              child: _buildPointerLabel('Right Ventricle'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // "About" Section Card
                    Container(
                      padding: const EdgeInsets.all(20),
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
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About the $title',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 4 Stat Cards Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: stats.map((stat) {
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 4),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(18),
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        stat['icon'] as IconData,
                                        size: 20,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        stat['value'] as String,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        stat['label'] as String,
                                        style: GoogleFonts.poppins(
                                          fontSize: 9,
                                          color: Colors.grey.shade600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // "Main Functions" Card
                    Container(
                      padding: const EdgeInsets.all(20),
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
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Main Functions',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...functions.map((func) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 14,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      func,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // "Did You Know?" Lightbulb Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: primaryColor.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Did You Know?',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withValues(alpha: 0.15),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.lightbulb_outline,
                                  size: 20,
                                  color: primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  fact,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                    height: 1.5,
                                  ),
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
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.view_in_ar,
                      color: Colors.white, size: 22),
                  label: Text(
                    'Explore in 3D',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointerLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        Container(width: 12, height: 1, color: primaryColor.withValues(alpha: 0.5)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
              ),
            ],
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
