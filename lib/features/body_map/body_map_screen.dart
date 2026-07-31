import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyMapScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const BodyMapScreen({super.key, this.onBack});

  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen> {
  String selectedSystem = 'Muscular';
  String selectedView = 'Front';
  bool _isSidebarExpanded = false;

  final TransformationController _transformationController =
      TransformationController();

  final Color primaryColor = const Color(0xFF6C4DFF);

  final List<Map<String, dynamic>> systems = [
    {
      'name': 'Muscular',
      'icon': Icons.fitness_center,
      'color': Colors.redAccent,
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
    {
      'name': 'Endocrine',
      'icon': Icons.hub,
      'color': const Color(0xFFA855F7),
    },
    {
      'name': 'Lymphatic',
      'icon': Icons.account_tree,
      'color': const Color(0xFF10B981),
    },
    {
      'name': 'Reproductive',
      'icon': Icons.transgender,
      'color': const Color(0xFF6366F1),
    },
    {
      'name': 'Integumentary',
      'icon': Icons.layers,
      'color': const Color(0xFF8D6E63),
    },
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60, top: 10),
                    child: Hero(
                      tag: 'anatomy_model',
                      child: Image.asset(
                        'assets/images/anatomy.png',
                        fit: BoxFit.contain,
                        height: MediaQuery.of(context).size.height * 0.76,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Left Sidebar (Systems) - Collapsible
            Positioned(
              left: 14,
              top: 12,
              bottom: 75,
              child: _buildSystemsSidebar(),
            ),

            // Top Right (Views)
            Positioned(right: 14, top: 12, child: _buildViewsSwitcher()),

            // Right side center (Zoom Controls)
            Positioned(right: 14, top: 180, child: _buildZoomControls()),


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

  Widget _buildSystemsSidebar() {
    final double sidebarWidth = _isSidebarExpanded ? 152 : 56;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              mainAxisAlignment: _isSidebarExpanded
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                if (_isSidebarExpanded)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      'Systems',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () =>
                      setState(() => _isSidebarExpanded = !_isSidebarExpanded),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isSidebarExpanded
                          ? Icons.chevron_left
                          : Icons.tune_rounded,
                      size: 18,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: systems.length,
              itemBuilder: (context, index) {
                final system = systems[index];
                final isSelected = selectedSystem == system['name'];
                return Tooltip(
                  message: system['name'],
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => selectedSystem = system['name']),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: _isSidebarExpanded ? 10 : 8,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: _isSidebarExpanded
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          Icon(
                            system['icon'],
                            size: 20,
                            color: isSelected ? Colors.white : system['color'],
                          ),
                          if (_isSidebarExpanded) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  system['name'],
                                  style: GoogleFonts.poppins(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
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
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 4, bottom: 6),
            child: Text(
              'View',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          ...views.map((view) {
            final isSelected = selectedView == view['name'];
            return GestureDetector(
              onTap: () => setState(() => selectedView = view['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
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
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
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
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87, size: 20),
            onPressed: () {
              _transformationController.value *= Matrix4.diagonal3Values(
                1.2,
                1.2,
                1.0,
              );
            },
          ),
          Container(height: 1, width: 22, color: Colors.grey.shade200),
          IconButton(
            icon: const Icon(Icons.remove, color: Colors.black87, size: 20),
            onPressed: () {
              _transformationController.value *= Matrix4.diagonal3Values(
                0.8,
                0.8,
                1.0,
              );
            },
          ),
          Container(height: 1, width: 22, color: Colors.grey.shade200),
          IconButton(
            icon: const Icon(
              Iconsax.refresh_copy,
              color: Colors.black87,
              size: 18,
            ),
            onPressed: _resetCamera,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: 215,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
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
                fontSize: 14,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'The ${selectedSystem.toLowerCase()} system consists of vital components that enable the body to function properly, maintain balance and support life.',
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
                fontSize: 11,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(20),
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
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 9,
                      color: primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
            color: Colors.black.withOpacity(0.06),
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
                  ? primaryColor.withOpacity(0.1)
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

