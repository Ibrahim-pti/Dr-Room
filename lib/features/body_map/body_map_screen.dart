import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'organ_details_screen.dart';

class BodyMapScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const BodyMapScreen({super.key, this.onBack});

  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen> {
  String selectedSystem = 'Muscular';
  String selectedView = 'Front';
  String selectedOrgan = 'chest'; // Default organ selection (Heart)

  final TransformationController _transformationController =
      TransformationController();

  final Color primaryColor = const Color(0xFF6C4DFF);

  final List<Map<String, dynamic>> systems = [
    {'name': 'Muscular', 'icon': Icons.fitness_center, 'color': Colors.white},
    {'name': 'Skeletal', 'icon': Icons.accessibility_new, 'color': const Color(0xFF64748B)},
    {'name': 'Nervous', 'icon': Icons.psychology, 'color': const Color(0xFFF59E0B)},
    {'name': 'Circulatory', 'icon': Icons.favorite, 'color': const Color(0xFFEF4444)},
    {'name': 'Respiratory', 'icon': Icons.air, 'color': const Color(0xFFEC4899)},
    {'name': 'Digestive', 'icon': Icons.restaurant, 'color': const Color(0xFFF97316)},
    {'name': 'Urinary', 'icon': Icons.water_drop, 'color': const Color(0xFF3B82F6)},
    {'name': 'Endocrine', 'icon': Icons.hub, 'color': const Color(0xFFA855F7)},
    {'name': 'Lymphatic', 'icon': Icons.account_tree, 'color': const Color(0xFF10B981)},
    {'name': 'Reproductive', 'icon': Icons.transgender, 'color': const Color(0xFF6366F1)},
    {'name': 'Integumentary', 'icon': Icons.layers, 'color': const Color(0xFF8D6E63)},
  ];

  final List<Map<String, dynamic>> views = [
    {'name': 'Front', 'icon': Icons.person},
    {'name': 'Side', 'icon': Icons.directions_walk},
    {'name': 'Back', 'icon': Icons.accessibility},
  ];

  final Map<String, Map<String, dynamic>> organQuickData = {
    'head': {
      'title': 'Brain & Nervous System',
      'imageUrl': 'https://pngimg.com/d/brain_PNG20.png',
      'description':
          'The brain is the central control organ of the body, regulating cognitive, sensory, and motor functions.',
    },
    'chest': {
      'title': 'Heart',
      'imageUrl': 'https://pngimg.com/d/heart_PNG51334.png',
      'description':
          'The heart is a muscular organ that pumps blood throughout the body through the circulatory system.',
    },
    'abdomen': {
      'title': 'Digestive Organs',
      'imageUrl': 'https://pngimg.com/d/stomach_PNG34.png',
      'description':
          'The stomach and intestines break down food, absorb nutrients, and filter metabolic waste.',
    },
    'arms': {
      'title': 'Musculature & Joints',
      'imageUrl': 'https://pngimg.com/d/muscle_PNG35.png',
      'description':
          'Upper limb muscular assemblies enable powerful motor movement and precise physical articulation.',
    },
    'legs': {
      'title': 'Knee & Joint Assembly',
      'imageUrl': 'https://pngimg.com/d/skeleton_PNG18.png',
      'description':
          'Femur, tibia, and knee cartilage provide primary locomotion power, weight balance, and shock absorption.',
    },
  };

  void _resetCamera() {
    _transformationController.value = Matrix4.identity();
  }

  void _openOrganDetails(Map<String, dynamic> organData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrganDetailsScreen(organData: organData),
      ),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeOrganData = organQuickData[selectedOrgan] ?? organQuickData['chest']!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            // Center 3D Model (Interactive Viewer with Purple + Hotspots)
            Positioned.fill(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 140, top: 10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Hero(
                          tag: 'anatomy_model',
                          child: Image.asset(
                            'assets/images/anatomy.png',
                            fit: BoxFit.contain,
                            height: MediaQuery.of(context).size.height * 0.72,
                          ),
                        ),

                        // Purple Circular + Hotspot Pins
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.05,
                          left: MediaQuery.of(context).size.width * 0.44,
                          child: _buildPlusHotspot('head'),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.16,
                          right: MediaQuery.of(context).size.width * 0.41,
                          child: _buildPlusHotspot('chest'),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.28,
                          left: MediaQuery.of(context).size.width * 0.48,
                          child: _buildPlusHotspot('abdomen'),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.32,
                          left: MediaQuery.of(context).size.width * 0.35,
                          child: _buildPlusHotspot('arms'),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.48,
                          right: MediaQuery.of(context).size.width * 0.40,
                          child: _buildPlusHotspot('legs'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Left Sidebar (Systems)
            Positioned(
              left: 14,
              top: 12,
              bottom: 210, // Leave space for bottom organ card
              child: _buildSystemsSidebar(),
            ),

            // Right side Controls Stack (Rotate, Zoom, Reset & Views)
            Positioned(
              right: 14,
              top: 12,
              child: Column(
                children: [
                  _buildZoomControls(),
                  const SizedBox(height: 12),
                  _buildViewsSwitcher(),
                ],
              ),
            ),

            // Bottom Organ Quick Card (Matches Reference Screen 1)
            Positioned(
              left: 14,
              right: 14,
              bottom: 75,
              child: _buildOrganQuickCard(activeOrganData),
            ),

            // Bottom Navigation Toolbar
            Positioned(
              left: 14,
              right: 14,
              bottom: 12,
              child: _buildBottomToolbar(),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
        onPressed: () {
          if (widget.onBack != null) {
            widget.onBack!();
          } else if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        'Human Body',
        style: GoogleFonts.poppins(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Iconsax.search_normal_copy, color: Colors.black87),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildPlusHotspot(String key) {
    final isSelected = selectedOrgan == key;
    return GestureDetector(
      onTap: () => setState(() => selectedOrgan = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 32 : 26,
        height: isSelected ? 32 : 26,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: isSelected ? 0.45 : 0.25),
              blurRadius: isSelected ? 12 : 6,
              spreadRadius: isSelected ? 3 : 1,
            ),
          ],
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildSystemsSidebar() {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14, top: 14, bottom: 8),
            child: Text(
              'Systems',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: systems.length,
              itemBuilder: (context, index) {
                final system = systems[index];
                final isSelected = selectedSystem == system['name'];
                return GestureDetector(
                  onTap: () => setState(() => selectedSystem = system['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2.5,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          system['icon'],
                          size: 16,
                          color: isSelected ? Colors.white : system['color'],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              system['name'],
                              style: GoogleFonts.poppins(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewsSwitcher() {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...views.map((view) {
            final isSelected = selectedView == view['name'];
            return GestureDetector(
              onTap: () => setState(() => selectedView = view['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      view['icon'],
                      size: 14,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      view['name'],
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.grey.shade800,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildZoomControls() {
    return Container(
      width: 90,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildZoomItem(Iconsax.rotate_left_copy, 'Rotate', () {}),
          _buildZoomItem(Icons.add, 'Zoom In', () {
            _transformationController.value *=
                Matrix4.diagonal3Values(1.2, 1.2, 1.0);
          }),
          _buildZoomItem(Icons.remove, 'Zoom Out', () {
            _transformationController.value *=
                Matrix4.diagonal3Values(0.8, 0.8, 1.0);
          }),
          _buildZoomItem(Iconsax.refresh_copy, 'Reset', _resetCamera),
        ],
      ),
    );
  }

  Widget _buildZoomItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 9,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganQuickCard(Map<String, dynamic> organData) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Left: Organ 3D Graphic
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 80,
              height: 80,
              color: primaryColor.withValues(alpha: 0.05),
              padding: const EdgeInsets.all(8),
              child: Image.network(
                organData['imageUrl'],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.favorite,
                  size: 44,
                  color: primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Right: Organ Details & Read More
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  organData['title'],
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  organData['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 10.5,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => _openOrganDetails(organData),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Read More',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCircularNavButton(Iconsax.rotate_left_copy, 'Rotate', true),
          _buildCircularNavButton(Iconsax.search_zoom_in_copy, 'Zoom', false),
          _buildCircularNavButton(Icons.label_outline, 'Labels', false),
          _buildCircularNavButton(Iconsax.refresh_copy, 'Reset', false),
          _buildCircularNavButton(Icons.fullscreen, 'Fullscreen', false),
        ],
      ),
    );
  }

  Widget _buildCircularNavButton(IconData icon, String label, bool isActive) {
    final color = isActive ? primaryColor : Colors.grey.shade600;
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
