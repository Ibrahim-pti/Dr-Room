import 'dart:math' as math;
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
  String selectedSystem = 'All';
  String? selectedOrgan;
  double _rotationY = 0.0; // Interactive 360-degree Y-axis rotation in radians

  final TransformationController _transformationController =
      TransformationController();

  final Color primaryColor = const Color(0xFF6C4DFF);

  final List<Map<String, dynamic>> systems = [
    {'name': 'All', 'icon': Icons.apps, 'color': const Color(0xFF6C4DFF)},
    {
      'name': 'Muscular',
      'icon': Icons.fitness_center,
      'color': const Color(0xFF6366F1),
    },
    {
      'name': 'Skeletal',
      'icon': Icons.accessibility_new,
      'color': const Color(0xFF64748B),
    },
    {
      'name': 'Nervous',
      'icon': Icons.psychology,
      'color': const Color(0xFFF59E0B),
    },
    {
      'name': 'Circulatory',
      'icon': Icons.favorite,
      'color': const Color(0xFFEF4444),
    },
    {
      'name': 'Respiratory',
      'icon': Icons.air,
      'color': const Color(0xFFEC4899),
    },
    {
      'name': 'Digestive',
      'icon': Icons.restaurant,
      'color': const Color(0xFFF97316),
    },
    {
      'name': 'Urinary',
      'icon': Icons.water_drop,
      'color': const Color(0xFF3B82F6),
    },
    {'name': 'Endocrine', 'icon': Icons.hub, 'color': const Color(0xFFA855F7)},
    {
      'name': 'Lymphatic',
      'icon': Icons.account_tree,
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'Reproductive',
      'icon': Icons.transgender,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'name': 'Integumentary',
      'icon': Icons.layers,
      'color': const Color(0xFF8D6E63),
    },
  ];

  final Map<String, Map<String, dynamic>> organQuickData = {
    'head': {
      'title': 'Brain & Nervous System',
      'imageUrl': 'https://pngimg.com/d/brain_PNG20.png',
      'description':
          'The brain regulates cognition, memory, sensory interpretation, and involuntary physiological controls.',
      'latin': 'Encephalon & Systema Nervosum',
      'stats': [
        {
          'value': '1.4 kg',
          'label': 'Avg Weight',
          'icon': Icons.scale_outlined,
        },
        {'value': '86 Billion', 'label': 'Neurons', 'icon': Icons.psychology},
        {'value': '20%', 'label': 'Energy', 'icon': Icons.bolt},
        {'value': 'Central', 'label': 'Nervous', 'icon': Icons.hub},
      ],
      'functions': [
        'Regulates cognitive processing & memory storage',
        'Controls sensory perception & motor movements',
        'Manages involuntary autonomic nervous functions',
        'Coordinates balance & neuromuscular feedback',
      ],
      'fact':
          'Your brain generates about 20 watts of electrical power—enough to power a small LED light bulb!',
    },
    'chest': {
      'title': 'Heart & Circulatory',
      'imageUrl': 'https://pngimg.com/d/heart_PNG51334.png',
      'description':
          'Pumps oxygenated blood through a 100,000 km network of blood vessels throughout the body.',
      'latin': 'Cor & Systema Cardiovasculare',
      'stats': [
        {
          'value': '70-100',
          'label': 'Beats / Min',
          'icon': Icons.favorite_border,
        },
        {
          'value': '250-350',
          'label': 'grams Weight',
          'icon': Icons.scale_outlined,
        },
        {
          'value': 'Left Side',
          'label': 'of Chest',
          'icon': Icons.location_on_outlined,
        },
        {
          'value': 'Life Long',
          'label': 'Duration',
          'icon': Icons.access_time_rounded,
        },
      ],
      'functions': [
        'Pumps oxygenated blood to body tissues',
        'Pumps deoxygenated blood to the lungs',
        'Maintains blood pressure and vascular flow',
        'Supports overall cardiovascular circulation',
      ],
      'fact':
          'Your heart beats about 100,000 times a day and pumps over 7,500 liters of blood through your body!',
    },
    'abdomen': {
      'title': 'Digestive Organs',
      'imageUrl': 'https://pngimg.com/d/stomach_PNG34.png',
      'description':
          'Houses the stomach and intestines responsible for nutrient breakdown, metabolism, and filtration.',
      'latin': 'Systema Digestorium',
      'stats': [
        {
          'value': '1.5 Liters',
          'label': 'Capacity',
          'icon': Icons.water_drop_outlined,
        },
        {
          'value': 'pH 1.5 - 3.5',
          'label': 'Acidity',
          'icon': Icons.science_outlined,
        },
        {
          'value': 'Abdominal',
          'label': 'Cavity',
          'icon': Icons.location_on_outlined,
        },
        {
          'value': '24-72 hrs',
          'label': 'Transit',
          'icon': Icons.timer_outlined,
        },
      ],
      'functions': [
        'Breaks down complex nutrients into absorbable compounds',
        'Secretes gastric acid & digestive enzymes',
        'Filters metabolic waste via hepatic pathways',
        'Maintains gut microbiome & immune defense',
      ],
      'fact':
          'The lining of your stomach replaces itself every few days to prevent digestive acids from dissolving it!',
    },
    'arms': {
      'title': 'Upper Extremity Musculature',
      'imageUrl': 'https://pngimg.com/d/muscle_PNG35.png',
      'description':
          'Composed of biceps, triceps, and humerus assemblies enabling motor articulation and upper body strength.',
      'latin': 'Musculi Membri Superioris',
      'stats': [
        {
          'value': '30+ Muscles',
          'label': 'Upper Arm',
          'icon': Icons.fitness_center,
        },
        {'value': 'Humerus', 'label': 'Main Bone', 'icon': Icons.accessibility},
        {
          'value': 'Full 360°',
          'label': 'Rotator Cuff',
          'icon': Icons.rotate_right,
        },
        {
          'value': 'Motor Power',
          'label': 'Articulation',
          'icon': Icons.pan_tool,
        },
      ],
      'functions': [
        'Enables upper extremity motor extension & flexion',
        'Supports precise manual dexterity & grip strength',
        'Provides structural stability to the shoulder girdle',
        'Facilitates heavy lifting & kinetic movement',
      ],
      'fact':
          'The muscles in your forearm control the complex movements of your fingers through a network of tendons!',
    },
    'legs': {
      'title': 'Lower Extremity & Knee Joint',
      'imageUrl': 'https://pngimg.com/d/skeleton_PNG18.png',
      'description':
          'Femur, tibia, and knee cartilage provide primary locomotion power, weight balance, and shock absorption.',
      'latin': 'Membrum Inferium & Articulatio Genus',
      'stats': [
        {'value': 'Femur', 'label': 'Longest Bone', 'icon': Icons.straighten},
        {
          'value': 'Patella',
          'label': 'Knee Cap',
          'icon': Icons.shield_outlined,
        },
        {'value': '3x Body Wt', 'label': 'Load Capacity', 'icon': Icons.speed},
        {
          'value': 'Bipedal',
          'label': 'Locomotion',
          'icon': Icons.directions_walk,
        },
      ],
      'functions': [
        'Bears overall body weight during standing & running',
        'Absorbs ground kinetic impact through cartilage',
        'Enables bipedal stride & posture equilibrium',
        'Facilitates explosive lower extremity propulsion',
      ],
      'fact':
          'The femur bone in your leg is stronger than concrete and can support up to 30 times your body weight!',
    },
  };

  void _resetCamera() {
    setState(() {
      _rotationY = 0.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  void _rotate360Step() {
    setState(() {
      _rotationY += math.pi / 2; // Spin 90 degrees
    });
  }

  void _openOrganDetails(Map<String, dynamic> organData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrganDetailsScreen(organData: organData),
      ),
    );
  }

  void _handleSystemTap(String systemName) {
    setState(() {
      selectedSystem = systemName;
      switch (systemName) {
        case 'Nervous':
          selectedOrgan = 'head';
          break;
        case 'Circulatory':
        case 'Respiratory':
          selectedOrgan = 'chest';
          break;
        case 'Digestive':
        case 'Urinary':
        case 'Endocrine':
          selectedOrgan = 'abdomen';
          break;
        case 'Muscular':
          selectedOrgan = 'arms';
          break;
        case 'Skeletal':
          selectedOrgan = 'legs';
          break;
        case 'All':
        default:
          selectedOrgan = null;
      }
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeOrganData = selectedOrgan != null
        ? organQuickData[selectedOrgan]
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Top Systems Horizontal Filter Bar
            _buildTopSystemsFilter(),

            // Main Interactive Anatomy Viewport
            Expanded(
              child: Stack(
                children: [
                  // Centered 3D Human Body Model Canvas with Interactive 360 Rotation
                  Positioned.fill(
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      panEnabled: false,
                      scaleEnabled: false,
                      minScale: 1.0,
                      maxScale: 1.0,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 80, top: 10),
                          child: GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              setState(() {
                                _rotationY += details.primaryDelta! * 0.008;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // 3D Perspective Y-Axis Rotation Model
                                Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(_rotationY),
                                  alignment: Alignment.center,
                                  child: Hero(
                                    tag: 'anatomy_model',
                                    child: Image.asset(
                                      'assets/images/anatomy.png',
                                      fit: BoxFit.contain,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.65,
                                    ),
                                  ),
                                ),

                                // Interactive Touch Regions over Body Organs
                                Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.02,
                                  width: 70,
                                  height: 70,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () =>
                                        setState(() => selectedOrgan = 'head'),
                                    child: Center(
                                      child: selectedOrgan == 'head'
                                          ? _buildPlusHotspot('head')
                                          : const SizedBox(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.13,
                                  width: 90,
                                  height: 80,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () =>
                                        setState(() => selectedOrgan = 'chest'),
                                    child: Center(
                                      child: selectedOrgan == 'chest'
                                          ? _buildPlusHotspot('chest')
                                          : const SizedBox(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width: 90,
                                  height: 80,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () => setState(
                                      () => selectedOrgan = 'abdomen',
                                    ),
                                    child: Center(
                                      child: selectedOrgan == 'abdomen'
                                          ? _buildPlusHotspot('abdomen')
                                          : const SizedBox(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.27,
                                  left:
                                      MediaQuery.of(context).size.width * 0.22,
                                  width: 80,
                                  height: 90,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () =>
                                        setState(() => selectedOrgan = 'arms'),
                                    child: Center(
                                      child: selectedOrgan == 'arms'
                                          ? _buildPlusHotspot('arms')
                                          : const SizedBox(),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top:
                                      MediaQuery.of(context).size.height * 0.42,
                                  width: 90,
                                  height: 110,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () =>
                                        setState(() => selectedOrgan = 'legs'),
                                    child: Center(
                                      child: selectedOrgan == 'legs'
                                          ? _buildPlusHotspot('legs')
                                          : const SizedBox(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Organ Quick Card (Appears smoothly when an organ is selected)
                  if (activeOrganData != null)
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 75,
                      child: _buildOrganQuickCard(activeOrganData),
                    ),

                  // Bottom Floating Navigation Toolbar
                  Positioned(
                    left: 14,
                    right: 14,
                    bottom: 12,
                    child: _buildBottomToolbar(),
                  ),
                ],
              ),
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

  // Top Systems Horizontal Filter Bar
  Widget _buildTopSystemsFilter() {
    return Container(
      height: 42,
      margin: const EdgeInsets.only(top: 4, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: systems.length,
        itemBuilder: (context, index) {
          final system = systems[index];
          final isSelected = selectedSystem == system['name'];
          final color = system['color'] as Color;

          return GestureDetector(
            onTap: () => _handleSystemTap(system['name']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? primaryColor : Colors.grey.shade200,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    system['icon'],
                    size: 15,
                    color: isSelected ? Colors.white : color,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    system['name'],
                    style: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlusHotspot(String key) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.45),
            blurRadius: 12,
            spreadRadius: 3,
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 16),
    );
  }

  // Sleek, ultra-modern Organ Quick Card with Close X button and solid purple Read More button
  Widget _buildOrganQuickCard(Map<String, dynamic> organData) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: primaryColor.withValues(alpha: 0.12)),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Left: 3D Organ Thumbnail Container
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.1),
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.network(
                  organData['imageUrl'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.favorite, size: 40, color: primaryColor),
                ),
              ),
              const SizedBox(width: 14),

              // Right: Organ Details & Read More Button
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 24),
                      child: Text(
                        organData['title'],
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      organData['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _openOrganDetails(organData),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read More',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
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

          // Close X button to dismiss card
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => setState(() => selectedOrgan = null),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 14, color: Colors.grey.shade600),
              ),
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
          _buildCircularNavButton(
            Iconsax.rotate_left_copy,
            'Rotate',
            true,
            onTap: _rotate360Step,
          ),
          _buildCircularNavButton(Iconsax.search_zoom_in_copy, 'Zoom', false),
          _buildCircularNavButton(Icons.label_outline, 'Labels', false),
          _buildCircularNavButton(
            Iconsax.refresh_copy,
            'Reset',
            false,
            onTap: _resetCamera,
          ),
          _buildCircularNavButton(Icons.fullscreen, 'Fullscreen', false),
        ],
      ),
    );
  }

  Widget _buildCircularNavButton(
    IconData icon,
    String label,
    bool isActive, {
    VoidCallback? onTap,
  }) {
    final color = isActive ? primaryColor : Colors.grey.shade600;
    return InkWell(
      onTap: onTap ?? () {},
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
