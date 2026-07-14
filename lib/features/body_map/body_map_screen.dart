import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../doctors/all_doctors_screen.dart';

class BodyMapScreen extends StatefulWidget {
  const BodyMapScreen({super.key});

  @override
  State<BodyMapScreen> createState() => _BodyMapScreenState();
}

class _BodyMapScreenState extends State<BodyMapScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

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

  String _mapIdToBodyPart(String id) {
    switch (id) {
      case '1':
      case '2':
      case '3':
      case '19': return 'Brain & Head';
      case '4': return 'Chest & Heart';
      case '10':
      case '9': return 'Stomach & Intestines';
      case '20':
      case '26':
      case '32':
      case '40':
      case '22':
      case '29':
      case '23':
      case '28':
      case '24':
      case '31':
      case '25':
      case '30':
      case '8':
      case '11':
      case '17':
      case '18': return 'Arms';
      case '7':
      case '12':
      case '14':
      case '15':
      case '27':
      case '21':
      case '39':
      case '33':
      case '34':
      case '38':
      case '42':
      case '35':
      case '36':
      case '37': return 'Legs';
      case '41':
      case '5': return 'Spine';
      default: return 'Joints & Bones';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final regionId = message.message;
          final organName = _mapIdToBodyPart(regionId);
          _showMedicalWikiSheet(organName);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // Center the body map and make it fit the screen
            _controller.runJavaScript('''
              document.body.style.zoom = "0.6";
              document.body.style.display = "flex";
              document.body.style.justifyContent = "center";
              document.body.style.alignItems = "center";
              document.body.style.height = "100vh";
              document.body.style.overflow = "hidden";
            ''');
          },
        ),
      )
      ..loadFlutterAsset('assets/bodyMap/index.html');
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
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
                            color: const Color(0xFF3B82F6),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          organ,
                          style: GoogleFonts.poppins(
                            color: AppColors.getTextTitle(context),
                            fontSize: 24,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWikiSection(context, 'Biological Function', data['function'], Icons.science),
                      const SizedBox(height: 24),
                      _buildWikiSection(context, 'Common Diseases', data['diseases'], Icons.coronavirus),
                      const SizedBox(height: 24),
                      _buildWikiSection(context, 'Warning Symptoms', data['symptoms'], Icons.warning_amber_rounded, color: const Color(0xFFEF4444)),
                      const SizedBox(height: 32),
                      
                      // Specialist Box
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Iconsax.verify, color: Color(0xFF10B981), size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Required Specialist',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF10B981),
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
                            backgroundColor: const Color(0xFF3B82F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
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
    final themeColor = color ?? const Color(0xFF8B5CF6);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: themeColor),
            const SizedBox(width: 8),
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
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 28),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Interactive Body Map',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
            ),
        ],
      ),
    );
  }
}
