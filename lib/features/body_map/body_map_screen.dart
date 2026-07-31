import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../doctors/all_doctors_screen.dart';

class BodyMapScreen extends StatefulWidget {
  const BodyMapScreen({super.key});

  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  final Map<String, Map<String, dynamic>> _organData = {
    'Brain & Head': {
      'function': 'Controls the nervous system, cognitive functions, and coordinates body actions.',
      'diseases': 'Migraine, Stroke, Epilepsy, Alzheimer\'s',
      'symptoms': 'Severe headache, dizziness, memory loss, numbness',
      'specialist': 'Neurologist',
      'icon': Icons.psychology, 
    },
    'Chest & Heart': {
      'function': 'Pumps blood and facilitates gas exchange (Heart & Lungs).',
      'diseases': 'Coronary Artery Disease, Asthma, Bronchitis',
      'symptoms': 'Chest pain, shortness of breath, chronic cough',
      'specialist': 'Cardiologist / Pulmonologist',
      'icon': Iconsax.heart,
    },
    'Stomach & Intestines': {
      'function': 'Digests food, absorbs nutrients, and expels waste.',
      'diseases': 'GERD, Peptic Ulcers, IBS, Crohn\'s Disease',
      'symptoms': 'Severe heartburn, abdominal pain, chronic diarrhea/constipation',
      'specialist': 'Gastroenterologist',
      'icon': Icons.restaurant,
    },
    'Arms': {
      'function': 'Provides upper body mobility and fine motor skills.',
      'diseases': 'Arthritis, Tendonitis, Fractures',
      'symptoms': 'Joint pain, weakness, numbness in fingers',
      'specialist': 'Orthopedist',
      'icon': Iconsax.link,
    },
    'Legs': {
      'function': 'Supports body weight and provides locomotion.',
      'diseases': 'Osteoarthritis, Sciatica, DVT',
      'symptoms': 'Knee pain, severe cramping, swelling',
      'specialist': 'Orthopedist',
      'icon': Icons.directions_walk,
    },
    'Spine': {
      'function': 'Supports the body and protects the spinal cord.',
      'diseases': 'Herniated Disc, Scoliosis, Spinal Stenosis',
      'symptoms': 'Chronic back pain, radiating nerve pain, numbness in legs',
      'specialist': 'Orthopedic Surgeon, Neurologist',
      'icon': Icons.accessibility,
    },
    'Joints & Bones': {
      'function': 'Provides structural support and facilitates movement.',
      'diseases': 'Arthritis, Osteoporosis, Fractures',
      'symptoms': 'Joint swelling, stiffness, severe localized bone pain',
      'specialist': 'Orthopedist, Rheumatologist',
      'icon': Iconsax.link,
    },
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showMedicalWikiSheet(String organ) {
    final data = _organData[organ]!;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.getSurface(context),
            borderRadius: const BorderRadiusDirectional.only(
              topStart: Radius.circular(32),
              topEnd: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.getBorder(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(data['icon'], color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'System Area',
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          organ,
                          style: GoogleFonts.poppins(
                            color: AppColors.getTextTitle(context),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWikiSection(context, 'Biological Function', data['function'], Icons.science_rounded),
                      const SizedBox(height: 24),
                      _buildWikiSection(context, 'Common Diseases', data['diseases'], Icons.coronavirus_rounded),
                      const SizedBox(height: 24),
                      _buildWikiSection(context, 'Warning Symptoms', data['symptoms'], Icons.warning_amber_rounded, color: Colors.orange),
                      const SizedBox(height: 32),

                      // Specialist Box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Iconsax.verify, color: AppColors.success, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Required Specialist',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.success,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data['specialist'],
                                    style: GoogleFonts.poppins(
                                      color: AppColors.getTextTitle(context),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AllDoctorsScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 8,
                            shadowColor: AppColors.primary.withValues(alpha: 0.4),
                          ),
                          child: Text(
                            'Find ${data['specialist']} Now',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWikiSection(BuildContext context, String title, String content, IconData icon, {Color? color}) {
    final themeColor = color ?? AppColors.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: themeColor),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.getTextTitle(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 48),
          child: Text(
            content,
            style: GoogleFonts.poppins(
              color: AppColors.getTextSubtitle(context),
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarker(String title, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: () => _showMedicalWikiSheet(title),
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withValues(alpha: 0.3 + (_pulseController.value * 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withValues(alpha: 0.5 * _pulseController.value),
                    blurRadius: 15,
                    spreadRadius: 5 * _pulseController.value,
                  ),
                ],
              ),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.8),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We create a premium dark background for the 3D map
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark slate background for premium feel
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Interactive Body Map',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background ambient glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withValues(alpha: 0.15),
              ),
            ),
          ),
          
          // 3D Body Image
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // The generated 3D image
                      Center(
                        child: Image.asset(
                          'assets/images/3d_body.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      
                      // Markers
                      _buildMarker('Brain & Head', const Alignment(0.0, -0.75)),
                      _buildMarker('Chest & Heart', const Alignment(0.0, -0.45)),
                      _buildMarker('Stomach & Intestines', const Alignment(0.0, -0.15)),
                      _buildMarker('Arms', const Alignment(-0.5, -0.1)),
                      _buildMarker('Arms', const Alignment(0.5, -0.1)),
                      _buildMarker('Joints & Bones', const Alignment(-0.4, 0.4)),
                      _buildMarker('Joints & Bones', const Alignment(0.4, 0.4)),
                      _buildMarker('Legs', const Alignment(-0.2, 0.7)),
                      _buildMarker('Legs', const Alignment(0.2, 0.7)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Instruction Text
          PositionedDirectional(
            bottom: 40,
            start: 0,
            end: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.touch_app_rounded, size: 20, color: Colors.cyanAccent),
                      const SizedBox(width: 12),
                      Text(
                        'Tap a glowing point to learn more',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

