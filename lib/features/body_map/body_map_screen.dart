import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BodyMapScreen extends StatefulWidget {
  const BodyMapScreen({super.key});

  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen> {
  String selectedSystem = 'Muscular';
  String selectedView = 'Front';

  final List<Map<String, dynamic>> systems = [
    {'name': 'Muscular', 'icon': Icons.fitness_center, 'color': Colors.white},
    {'name': 'Skeletal', 'icon': Icons.person_outline, 'color': Colors.grey.shade600},
    {'name': 'Circulatory', 'icon': Icons.favorite, 'color': Colors.red.shade400},
    {'name': 'Nervous', 'icon': Icons.psychology, 'color': Colors.orange.shade300},
    {'name': 'Respiratory', 'icon': Icons.air, 'color': Colors.redAccent.shade200},
    {'name': 'Digestive', 'icon': Icons.restaurant, 'color': Colors.pink.shade300},
    {'name': 'Urinary', 'icon': Icons.water_drop, 'color': Colors.brown.shade400},
    {'name': 'Reproductive', 'icon': Icons.transgender, 'color': Colors.blue.shade400},
    {'name': 'Lymphatic', 'icon': Icons.account_tree, 'color': Colors.green.shade400},
    {'name': 'Integumentary', 'icon': Icons.layers, 'color': Colors.orange.shade200},
  ];

  final List<Map<String, dynamic>> views = [
    {'name': 'Front', 'icon': Icons.person},
    {'name': 'Side', 'icon': Icons.directions_walk},
    {'name': 'Back', 'icon': Icons.accessibility},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match the reference plain white background
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Center Image (Realistic Anatomy)
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: 'https://www.pngmart.com/files/7/Anatomy-PNG-Transparent.png',
                      errorWidget: (context, url, error) => Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Human_anatomy.svg/800px-Human_anatomy.svg.png',
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.accessibility_new, size: 200, color: Colors.grey),
                        fit: BoxFit.contain,
                      ),
                      fit: BoxFit.contain,
                      height: double.infinity,
                    ),
                  ),

                  // Left Sidebar (Systems)
                  Positioned(
                    left: 16,
                    top: 16,
                    bottom: 16,
                    child: _buildSystemsSidebar(),
                  ),

                  // Top Right (Views)
                  Positioned(
                    right: 16,
                    top: 16,
                    child: _buildViewsSwitcher(),
                  ),

                  // Right side center (Controls)
                  Positioned(
                    right: 16,
                    top: 170,
                    child: _buildZoomControls(),
                  ),

                  // Bottom Right (Info Card)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _buildInfoCard(),
                  ),
                ],
              ),
            ),
            // Bottom Toolbar for Body Map
            _buildBottomToolbar(),
            // Add padding so it floats above the main app's floating navigation bar
            const SizedBox(height: 100),
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
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black87),
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      title: const Text('Human Body', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Iconsax.search_normal_copy, color: Colors.black87), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert, color: Colors.black87), onPressed: () {}),
      ],
    );
  }

  Widget _buildSystemsSidebar() {
    return Container(
      width: 155,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 20, bottom: 12),
            child: Text('Systems', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: systems.length,
              itemBuilder: (context, index) {
                final system = systems[index];
                final isSelected = selectedSystem == system['name'];
                return GestureDetector(
                  onTap: () => setState(() => selectedSystem = system['name']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          system['icon'],
                          size: 20,
                          color: isSelected ? Colors.white : system['color'],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            system['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      width: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 4, bottom: 8),
            child: Text('View', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          ...views.map((view) {
            final isSelected = selectedView == view['name'];
            return GestureDetector(
              onTap: () => setState(() => selectedView = view['name']),
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      view['icon'],
                      size: 16,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      view['name'],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade800,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildZoomControls() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.add, color: Colors.black87, size: 20), onPressed: () {}),
          Container(height: 1, width: 24, color: Colors.grey.shade200),
          IconButton(icon: const Icon(Icons.remove, color: Colors.black87, size: 20), onPressed: () {}),
          Container(height: 1, width: 24, color: Colors.grey.shade200),
          IconButton(icon: const Icon(Icons.refresh, color: Colors.black87, size: 20), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$selectedSystem System',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The ${selectedSystem.toLowerCase()} system consists of muscles that enable the body to move, maintain posture and circulate blood.',
            style: TextStyle(color: Colors.grey.shade800, fontSize: 11, height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF8B5CF6)),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Learn More',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFF8B5CF6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomTool(Iconsax.rotate_left_copy, 'Rotate', true),
          _buildBottomTool(Iconsax.search_zoom_in_copy, 'Zoom', false),
          _buildBottomTool(Icons.local_offer_outlined, 'Labels', false),
          _buildBottomTool(Icons.refresh, 'Reset', false),
          _buildBottomTool(Icons.fullscreen, 'Fullscreen', false),
        ],
      ),
    );
  }

  Widget _buildBottomTool(IconData icon, String label, bool isActive) {
    final color = isActive ? const Color(0xFF8B5CF6) : Colors.grey.shade600;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
