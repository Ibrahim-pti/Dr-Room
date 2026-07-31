import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyMapScreen extends StatefulWidget {
  const BodyMapScreen({super.key});

  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen> {
  String selectedSystem = 'Muscular';
  String selectedView = 'Front';
  
  final TransformationController _transformationController = TransformationController();

  final Color primaryColor = const Color(0xFF6C4DFF);

  final List<Map<String, dynamic>> systems = [
    {'name': 'Muscular', 'icon': Icons.fitness_center, 'color': Colors.redAccent},
    {'name': 'Skeletal', 'icon': Icons.accessibility_new, 'color': Colors.grey.shade600},
    {'name': 'Nervous', 'icon': Icons.psychology, 'color': Colors.orange.shade400},
    {'name': 'Circulatory', 'icon': Icons.favorite, 'color': Colors.red},
    {'name': 'Respiratory', 'icon': Icons.air, 'color': Colors.pink.shade300},
    {'name': 'Digestive', 'icon': Icons.restaurant, 'color': Colors.orange.shade300},
    {'name': 'Urinary', 'icon': Icons.water_drop, 'color': Colors.blue.shade300},
    {'name': 'Endocrine', 'icon': Icons.hub, 'color': Colors.purple.shade300},
    {'name': 'Lymphatic', 'icon': Icons.account_tree, 'color': Colors.green.shade400},
    {'name': 'Reproductive', 'icon': Icons.transgender, 'color': Colors.indigo.shade300},
    {'name': 'Integumentary', 'icon': Icons.layers, 'color': Colors.brown.shade300},
  ];

  final List<Map<String, dynamic>> views = [
    {'name': 'Front', 'icon': Icons.person},
    {'name': 'Side', 'icon': Icons.directions_walk},
    {'name': 'Back', 'icon': Icons.accessibility},
  ];

  void _resetCamera() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            // Center 3D Model (Interactive Viewer)
            Positioned.fill(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: Center(
                  child: Hero(
                    tag: 'anatomy_model',
                    child: CachedNetworkImage(
                      imageUrl: 'https://www.pngmart.com/files/7/Anatomy-PNG-Transparent.png',
                      errorWidget: (context, url, error) => Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Human_anatomy.svg/800px-Human_anatomy.svg.png',
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.accessibility_new, size: 200, color: Colors.grey),
                        fit: BoxFit.contain,
                      ),
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height * 0.75,
                    ),
                  ),
                ),
              ),
            ),

            // Left Sidebar (Systems)
            Positioned(
              left: 16,
              top: 16,
              bottom: 110, // Leave space for bottom bar
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

            // Bottom Right (Info Card with Glassmorphism)
            Positioned(
              right: 16,
              bottom: 110, // Leave space for bottom bar
              child: _buildInfoCard(),
            ),

            // Bottom Navigation Toolbar
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
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
          child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black87),
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        'Human Body', 
        style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)
      ),
      centerTitle: true,
      actions: [
        IconButton(icon: const Icon(Iconsax.search_normal_copy, color: Colors.black87), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert, color: Colors.black87), onPressed: () {}),
      ],
    );
  }

  Widget _buildSystemsSidebar() {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 12),
            child: Text('Systems', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15)),
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
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
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 12,
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4, bottom: 8),
            child: Text('View', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          ...views.map((view) {
            final isSelected = selectedView == view['name'];
            return GestureDetector(
              onTap: () => setState(() => selectedView = view['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
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
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.grey.shade800,
                        fontSize: 12,
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
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87, size: 20), 
            onPressed: () {
              _transformationController.value *= Matrix4.diagonal3Values(1.2, 1.2, 1.0);
            }
          ),
          Container(height: 1, width: 24, color: Colors.grey.shade200),
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.black87, size: 20), 
            onPressed: () {
              _transformationController.value *= Matrix4.diagonal3Values(0.8, 0.8, 1.0);
            }
          ),
          Container(height: 1, width: 24, color: Colors.grey.shade200),
          IconButton(
            icon: const Icon(Iconsax.refresh_copy, color: Colors.black87, size: 20), 
            onPressed: _resetCamera
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 240,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Column(
              key: ValueKey<String>(selectedSystem),
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedSystem System',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The ${selectedSystem.toLowerCase()} system consists of vital components that enable the body to function properly, maintain balance and support life.',
                  style: GoogleFonts.poppins(color: Colors.grey.shade800, fontSize: 11, height: 1.5),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Learn More',
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 10, color: primaryColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isActive ? primaryColor.withOpacity(0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
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

