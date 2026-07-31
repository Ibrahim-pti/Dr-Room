import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BodyMapScreen extends StatefulWidget {
  const BodyMapScreen({super.key});

  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen> {
  String selectedSystem = 'Muscular';
  String selectedView = 'Front';

  final List<Map<String, dynamic>> systems = [
    {'name': 'Muscular', 'icon': Icons.fitness_center, 'color': Colors.purple},
    {'name': 'Skeletal', 'icon': Icons.accessibility_new, 'color': Colors.grey.shade700},
    {'name': 'Circulatory', 'icon': Iconsax.heart_copy, 'color': Colors.red},
    {'name': 'Nervous', 'icon': Icons.psychology, 'color': Colors.orangeAccent.shade400},
    {'name': 'Respiratory', 'icon': Icons.air, 'color': Colors.redAccent},
    {'name': 'Digestive', 'icon': Icons.restaurant_menu, 'color': Colors.pinkAccent},
    {'name': 'Urinary', 'icon': Icons.water_drop_outlined, 'color': Colors.brown.shade400},
    {'name': 'Reproductive', 'icon': Icons.transgender, 'color': Colors.blue},
    {'name': 'Lymphatic', 'icon': Icons.bubble_chart_outlined, 'color': Colors.green},
    {'name': 'Integumentary', 'icon': Icons.layers_outlined, 'color': Colors.orange.shade300},
  ];

  final List<Map<String, dynamic>> views = [
    {'name': 'Front', 'icon': Icons.person},
    {'name': 'Side', 'icon': Icons.directions_walk},
    {'name': 'Back', 'icon': Icons.accessibility},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            // Center Image Placeholder
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  'assets/images/body_map.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.accessibility_new, size: 200, color: Colors.grey);
                  },
                ),
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
              top: 180,
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
      bottomNavigationBar: _buildBottomToolbar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FA),
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
      title: const Text('Human Body', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Systems', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            system['name'],
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8, top: 4, bottom: 8),
            child: Text('View', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          ...views.map((view) {
            final isSelected = selectedView == view['name'];
            return GestureDetector(
              onTap: () => setState(() => selectedView = view['name']),
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$selectedSystem System',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The ${selectedSystem.toLowerCase()} system consists of various parts that enable the body to function properly, maintain posture and circulate blood.',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 12, height: 1.4),
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
                    fontSize: 13,
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
      height: 70,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
