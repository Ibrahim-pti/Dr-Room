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
    final title = widget.organData['title'] ?? 'Heart & Circulation';
    final imageUrl = widget.organData['imageUrl'] ??
        'https://pngimg.com/d/heart_PNG51334.png';
    final description = widget.organData['description'] ??
        'Pumps oxygenated blood through a 100,000 km vascular network throughout the body.';
    final latin = widget.organData['latin'] ?? 'Cor & Systema Cardiovasculare';
    final specialist = widget.organData['specialist'] ?? 'Cardiologist / Specialist';

    final stats = widget.organData['stats'] as List<dynamic>? ??
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

    final functions = widget.organData['functions'] as List<dynamic>? ??
        [
          'Pumps oxygenated blood to body tissues',
          'Pumps deoxygenated blood to the lungs',
          'Maintains blood pressure and vascular flow',
          'Supports overall cardiovascular circulation',
        ];

    final fact = widget.organData['fact'] as String? ??
        'Your heart beats about 100,000 times a day and pumps over 7,500 liters of blood through your body!';

    final anatomyDetails = widget.organData['anatomy_details'] as Map<String, dynamic>? ??
        {
          'Origin/Structure': 'Left & Right Atria, Ventricles, Myocardium, Aortic Valves',
          'Innervation': 'SA Node & Vagus Nerve (Autonomic Nervous Control)',
          'Blood Supply': 'Right Coronary & Left Anterior Descending (LAD) Arteries',
          'Clinical Note': 'Coronary artery occlusion causes myocardial infarction.',
        };

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
            fontSize: 17,
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
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? primaryColor
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tab,
                              style: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // 3D Organ Illustration Header
                    Center(
                      child: Container(
                        height: 220,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: primaryColor.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              imageUrl,
                              height: 140,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.favorite, size: 80, color: primaryColor),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              latin,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tab Content Switcher
                    if (selectedTab == 'Overview') ...[
                      // Description Card
                      _buildSectionCard(
                        title: 'Medical Overview',
                        icon: Icons.medical_information_outlined,
                        child: Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Medical Specialist Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.badge_outlined,
                                color: primaryColor, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              'Specialist Doctor: ',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                specialist,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Physiological Stats Grid
                      Row(
                        children: stats.map((stat) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    stat['icon'] is IconData
                                        ? stat['icon']
                                        : Icons.bubble_chart,
                                    size: 18,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    stat['value'].toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    stat['label'].toString(),
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
                    ] else if (selectedTab == 'Anatomy') ...[
                      // GetBodySmart Style Detailed Anatomy Card
                      _buildSectionCard(
                        title: 'GetBodySmart Anatomical Structure & Innervation',
                        icon: Icons.menu_book,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: anatomyDetails.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        entry.key,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 14),
                                    child: Text(
                                      entry.value.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ] else if (selectedTab == 'Function') ...[
                      // Functions Card
                      _buildSectionCard(
                        title: 'Physiological Functions',
                        icon: Icons.bolt,
                        child: Column(
                          children: functions.map((func) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withValues(alpha: 0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.check,
                                      size: 12,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      func.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ] else ...[
                      // Facts Card
                      _buildSectionCard(
                        title: 'Medical Did You Know?',
                        icon: Icons.lightbulb_outline,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.lightbulb,
                                size: 22,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                fact,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey.shade800,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white, size: 20),
                  label: Text(
                    'Back to Body Map',
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

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
