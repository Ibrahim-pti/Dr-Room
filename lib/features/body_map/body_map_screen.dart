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
      'name': 'Hepatic',
      'icon': Icons.opacity,
      'color': const Color(0xFFD97706),
    },
    {
      'name': 'Renal/Urinary',
      'icon': Icons.water_drop,
      'color': const Color(0xFF3B82F6),
    },
    {'name': 'Endocrine', 'icon': Icons.hub, 'color': const Color(0xFFA855F7)},
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
  ];

  // Complete Doctor-Grade Anatomical Organs & Systems Data
  final Map<String, Map<String, dynamic>> organQuickData = {
    'head': {
      'title': 'Brain & Central Nervous System',
      'imageUrl': 'https://pngimg.com/d/brain_PNG20.png',
      'description':
          'The master control organ regulating cognition, sensory interpretation, memory storage, and involuntary autonomic controls.',
      'latin': 'Encephalon & Systema Nervosum Centralis',
      'stats': [
        {
          'value': '1.4 kg',
          'label': 'Avg Weight',
          'icon': Icons.scale_outlined,
        },
        {'value': '86 Billion', 'label': 'Neurons', 'icon': Icons.psychology},
        {'value': '20%', 'label': 'Body Energy', 'icon': Icons.bolt},
        {'value': 'Central', 'label': 'Command', 'icon': Icons.hub},
      ],
      'functions': [
        'Regulates cognitive processing & memory retention',
        'Controls sensory perception & motor nerve output',
        'Manages involuntary autonomic nervous functions',
        'Coordinates body balance & neuromuscular feedback',
      ],
      'fact':
          'Your brain generates about 20 watts of electrical power—enough to power a small LED light bulb!',
      'specialist': 'Neurologist / Neurosurgeon',
    },
    'eyes': {
      'title': 'Ocular & Sensory Visual Pathway',
      'imageUrl': 'https://pngimg.com/d/eye_PNG35661.png',
      'description':
          'Focuses light through cornea and lens onto 107 million photoreceptors, transmitting high-speed optic signals.',
      'latin': 'Organum Visum & Nervus Opticus',
      'stats': [
        {
          'value': '576 MP',
          'label': 'Resolution',
          'icon': Icons.remove_red_eye,
        },
        {
          'value': '107 Million',
          'label': 'Photoreceptors',
          'icon': Icons.grain,
        },
        {'value': '2 Million', 'label': 'Working Parts', 'icon': Icons.build},
        {
          'value': 'Retina',
          'label': 'Neural Tissue',
          'icon': Icons.center_focus_strong,
        },
      ],
      'functions': [
        'Converts photons into high-resolution neural impulses',
        'Regulates pupil dilation for ambient light control',
        'Provides stereoscopic 3D depth perception',
        'Maintains ocular fluid pressure & corneal hydration',
      ],
      'fact':
          'The eye muscles are the most active muscles in your body, moving over 100,000 times a day!',
      'specialist': 'Ophthalmologist',
    },
    'neck': {
      'title': 'Cervical Spine & Pharyngeal Pathway',
      'imageUrl': 'https://pngimg.com/d/skeleton_PNG18.png',
      'description':
          'Houses 7 cervical vertebrae (C1-C7), carotid arteries, jugular veins, and the respiratory larynx assembly.',
      'latin': 'Vertebrae Cervicales & Larynx',
      'stats': [
        {
          'value': '7 Vertebrae',
          'label': 'C1 to C7',
          'icon': Icons.view_headline,
        },
        {'value': 'Carotid', 'label': 'Arterial Blood', 'icon': Icons.favorite},
        {
          'value': 'Larynx',
          'label': 'Vocal Cords',
          'icon': Icons.record_voice_over,
        },
        {
          'value': 'Spinal Cord',
          'label': 'Nerve Trunk',
          'icon': Icons.alt_route,
        },
      ],
      'functions': [
        'Supports head weight & multidirectional cervical rotation',
        'Protects upper spinal cord nerve pathways',
        'Facilitates arterial blood flow to the brain',
        'Enables vocal phonation via larynx & vocal cords',
      ],
      'fact':
          'The first cervical vertebra (C1) is named "Atlas" after the Greek titan who held up the sky!',
      'specialist': 'ENT Specialist / Orthopedic Spine Surgeon',
    },
    'thyroid': {
      'title': 'Thyroid & Endocrine System',
      'imageUrl': 'https://pngimg.com/d/throat_PNG14.png',
      'description':
          'Butterfly-shaped gland producing T3/T4 hormones regulating systemic basal metabolic rate and calcium balance.',
      'latin': 'Glandula Thyroidea & Systema Endocrinum',
      'stats': [
        {'value': 'T3 & T4', 'label': 'Hormones', 'icon': Icons.science},
        {
          'value': '20 grams',
          'label': 'Gland Weight',
          'icon': Icons.scale_outlined,
        },
        {'value': 'Metabolic', 'label': 'Regulation', 'icon': Icons.speed},
        {
          'value': 'Calcitonin',
          'label': 'Calcium Control',
          'icon': Icons.shield_outlined,
        },
      ],
      'functions': [
        'Secretes Thyroxine (T4) & Triiodothyronine (T3)',
        'Controls systemic oxygen consumption & heat production',
        'Regulates heart rate & gastrointestinal motility',
        'Balances bone calcium via calcitonin secretion',
      ],
      'fact':
          'Every single cell in the human body depends upon thyroid hormones for metabolic regulation!',
      'specialist': 'Endocrinologist',
    },
    'lungs': {
      'title': 'Lungs & Alveolar Respiratory Tree',
      'imageUrl': 'https://pngimg.com/d/lungs_PNG10.png',
      'description':
          'Facilitates continuous gas exchange across 300 million alveoli, oxygenating blood and removing carbon dioxide.',
      'latin': 'Pulmones & Systema Respiratorium',
      'stats': [
        {
          'value': '300 Million',
          'label': 'Alveoli',
          'icon': Icons.bubble_chart,
        },
        {'value': '11,000 L', 'label': 'Air / Day', 'icon': Icons.air},
        {'value': '70 m²', 'label': 'Surface Area', 'icon': Icons.aspect_ratio},
        {
          'value': 'O₂ & CO₂',
          'label': 'Gas Exchange',
          'icon': Icons.swap_horiz,
        },
      ],
      'functions': [
        'Absorbs atmospheric oxygen into pulmonary capillaries',
        'Excretes carbon dioxide gas produced by metabolism',
        'Regulates systemic arterial blood pH balance',
        'Filters micro-emboli from venous circulation',
      ],
      'fact':
          'Your lungs contain roughly 2,400 kilometers of airways and a surface area equal to a tennis court!',
      'specialist': 'Pulmonologist / Chest Physician',
    },
    'chest': {
      'title': 'Heart & Cardiovascular Circulatory System',
      'imageUrl': 'https://pngimg.com/d/heart_PNG51334.png',
      'description':
          'Four-chambered muscular pump circulating 7,500 liters of blood daily through a 100,000 km vascular network.',
      'latin': 'Cor & Systema Cardiovasculare',
      'stats': [
        {
          'value': '70-100',
          'label': 'Beats / Min',
          'icon': Icons.favorite_border,
        },
        {'value': '7,500 L', 'label': 'Pumped / Day', 'icon': Icons.water_drop},
        {
          'value': '4 Chambers',
          'label': 'Atria & Ventricles',
          'icon': Icons.grid_view,
        },
        {'value': '100k km', 'label': 'Vessels', 'icon': Icons.alt_route},
      ],
      'functions': [
        'Propels oxygenated blood to systemic body tissues',
        'Drives deoxygenated blood to pulmonary capillaries',
        'Maintains arterial blood pressure & tissue perfusion',
        'Delivers nutrients, hormones & immune antibodies',
      ],
      'fact':
          'Your heart beats over 2.5 billion times in an average human lifetime without a single rest!',
      'specialist': 'Cardiologist / Cardiothoracic Surgeon',
    },
    'liver': {
      'title': 'Liver & Hepato-Biliary Filtration System',
      'imageUrl': 'https://pngimg.com/d/liver_PNG16.png',
      'description':
          'Primary metabolic power-factory performing 500 vital biological functions including detoxification, bile production, and glycogen storage.',
      'latin': 'Hepar & Vesica Biliaris',
      'stats': [
        {'value': '500+', 'label': 'Functions', 'icon': Icons.auto_awesome},
        {
          'value': '1.5 kg',
          'label': 'Organ Weight',
          'icon': Icons.scale_outlined,
        },
        {
          'value': 'Bile',
          'label': 'Fat Digestion',
          'icon': Icons.water_drop_outlined,
        },
        {
          'value': 'Glycogen',
          'label': 'Energy Bank',
          'icon': Icons.battery_charging_full,
        },
      ],
      'functions': [
        'Detoxifies pharmaceutical drugs & metabolic toxins',
        'Synthesizes essential plasma proteins & clotting factors',
        'Produces bile for intestinal lipid emulsification',
        'Stores glucose as glycogen for emergency energy',
      ],
      'fact':
          'The liver is the only organ in the human body that can fully regenerate itself from just 25% of remaining tissue!',
      'specialist': 'Hepatologist / Gastroenterologist',
    },
    'abdomen': {
      'title': 'Stomach & Gastrointestinal Digestive Tract',
      'imageUrl': 'https://pngimg.com/d/stomach_PNG34.png',
      'description':
          'Breaks down complex nutrients via gastric acids and digestive enzymes while absorbing essential vitamins and minerals.',
      'latin': 'Gaster & Intestinum Tenue / Crassum',
      'stats': [
        {
          'value': 'pH 1.5 - 3.5',
          'label': 'Gastric Acid',
          'icon': Icons.science_outlined,
        },
        {
          'value': '9 Meters',
          'label': 'Tract Length',
          'icon': Icons.straighten,
        },
        {
          'value': '100 Trillion',
          'label': 'Gut Microbiome',
          'icon': Icons.bug_report_outlined,
        },
        {'value': 'Peristalsis', 'label': 'Motility', 'icon': Icons.sync},
      ],
      'functions': [
        'Digests proteins & food matrices via Hydrochloric Acid (HCl)',
        'Absorbs amino acids, fatty acids, and glucose',
        'Hosts 70% of the systemic mucosal immune system',
        'Eliminates unabsorbed metabolic digestive waste',
      ],
      'fact':
          'The digestive tract contains its own nervous system with over 500 million neurons—often called the second brain!',
      'specialist': 'Gastroenterologist',
    },
    'kidneys': {
      'title': 'Kidneys & Renal Excretory System',
      'imageUrl': 'https://pngimg.com/d/kidney_PNG28.png',
      'description':
          'Filters 180 liters of blood daily through 2 million microscopic nephrons to regulate fluid, electrolyte, and blood pressure equilibrium.',
      'latin': 'Renes & Systema Uropoeticum',
      'stats': [
        {
          'value': '2 Million',
          'label': 'Nephrons',
          'icon': Icons.filter_alt_outlined,
        },
        {
          'value': '180 Liters',
          'label': 'Filtered / Day',
          'icon': Icons.water_drop,
        },
        {'value': 'Renin', 'label': 'BP Control', 'icon': Icons.speed},
        {
          'value': 'Erythropoietin',
          'label': 'RBC Booster',
          'icon': Icons.invert_colors,
        },
      ],
      'functions': [
        'Filters metabolic urea & creatinine from blood',
        'Balances systemic sodium, potassium, and pH levels',
        'Secretes Renin enzyme to regulate blood pressure',
        'Produces Erythropoietin to stimulate red blood cell production',
      ],
      'fact':
          'Your kidneys filter your entire blood volume over 40 times every single day!',
      'specialist': 'Nephrologist / Urologist',
    },
    'arms': {
      'title': 'Upper Extremity Musculoskeletal Assembly',
      'imageUrl': 'https://pngimg.com/d/muscle_PNG35.png',
      'description':
          'Composed of humerus, radius, ulna, and 30+ rotator cuff and forearm muscles supporting high precision grip and lifting force.',
      'latin': 'Humerus, Radius, Ulna & Musculi',
      'stats': [
        {
          'value': '30+ Muscles',
          'label': 'Arm & Forearm',
          'icon': Icons.fitness_center,
        },
        {'value': 'Humerus', 'label': 'Long Bone', 'icon': Icons.accessibility},
        {
          'value': 'Full 360°',
          'label': 'Rotator Cuff',
          'icon': Icons.rotate_right,
        },
        {'value': 'Motor Power', 'label': 'Dexterity', 'icon': Icons.pan_tool},
      ],
      'functions': [
        'Drives upper extremity flexion, extension & rotation',
        'Enables fine motor finger dexterity & grip strength',
        'Stabilizes shoulder girdle articulation',
        'Facilitates kinetic force transmission in upper limbs',
      ],
      'fact':
          'The forearm contains 20 separate muscles that control every subtle articulation of your fingers!',
      'specialist': 'Orthopedic Surgeon / Physical Therapist',
    },
    'legs': {
      'title': 'Lower Extremity Femur & Knee Joint Complex',
      'imageUrl': 'https://pngimg.com/d/skeleton_PNG18.png',
      'description':
          'Femur, tibia, patella, and cruciate cartilage providing primary bipedal locomotion, body weight bearing, and ground impact absorption.',
      'latin': 'Femur, Tibia, Patella & Articulatio Genus',
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
        'Bears complete body mass during standing, walking & running',
        'Absorbs ground kinetic shock forces through knee cartilage',
        'Maintains bipedal balance & posture equilibrium',
        'Drives explosive lower body stride propulsion',
      ],
      'fact':
          'The femur bone in your thigh is stronger than concrete and can support up to 30 times your total body weight!',
      'specialist': 'Rheumatologist / Orthopedic Surgeon',
    },
    'feet': {
      'title': 'Lower Leg, Ankle & Foot Skeleton',
      'imageUrl': 'https://pngimg.com/d/skeleton_PNG18.png',
      'description':
          'Composed of tibia, fibula, tarsals, metatarsals, and plantaris muscles forming dynamic arch spring mechanics.',
      'latin': 'Tibia, Fibula, Tarsus & Musculi Pedis',
      'stats': [
        {'value': '26 Bones', 'label': 'Per Foot', 'icon': Icons.grid_view},
        {'value': '33 Joints', 'label': 'Articulation', 'icon': Icons.grain},
        {
          'value': '100+ Tendons',
          'label': 'Ligaments',
          'icon': Icons.linear_scale,
        },
        {'value': 'Plantaris', 'label': 'Arch Spring', 'icon': Icons.speed},
      ],
      'functions': [
        'Acts as dynamic lever arm for standing stride propulsion',
        'Absorbs kinetic impact forces upon heel strike',
        'Adapts to uneven ground surfaces via subtalar articulation',
        'Maintains upright posture balance feedback loop',
      ],
      'fact':
          'One quarter of all bones in the human body are located in your feet!',
      'specialist': 'Podiatrist / Orthopedic Foot Specialist',
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
          selectedOrgan = 'chest';
          break;
        case 'Respiratory':
          selectedOrgan = 'lungs';
          break;
        case 'Digestive':
          selectedOrgan = 'abdomen';
          break;
        case 'Hepatic':
          selectedOrgan = 'liver';
          break;
        case 'Renal/Urinary':
          selectedOrgan = 'kidneys';
          break;
        case 'Endocrine':
          selectedOrgan = 'thyroid';
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

    final isAllSelected = selectedSystem == 'All';

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

                                // Doctor Diagram Style Anatomical Pointer Lines (12 Medical Callouts)

                                // LEFT CALLOUT 1: Brain & Nervous
                                if (isAllSelected || selectedOrgan == 'head')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.01,
                                    left: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'head',
                                      label: 'Brain & Nervous',
                                      icon: Icons.psychology,
                                      isRightSide: false,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'head',
                                      ),
                                    ),
                                  ),

                                // RIGHT CALLOUT 1: Eyes & Vision
                                if (isAllSelected || selectedOrgan == 'eyes')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.05,
                                    right: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'eyes',
                                      label: 'Eyes & Vision',
                                      icon: Icons.remove_red_eye,
                                      isRightSide: true,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'eyes',
                                      ),
                                    ),
                                  ),

                                // LEFT CALLOUT 2: Neck & Spine
                                if (isAllSelected || selectedOrgan == 'neck')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.09,
                                    left: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'neck',
                                      label: 'Neck & Spine',
                                      icon: Icons.view_headline,
                                      isRightSide: false,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'neck',
                                      ),
                                    ),
                                  ),

                                // RIGHT CALLOUT 2: Thyroid Gland
                                if (isAllSelected || selectedOrgan == 'thyroid')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.13,
                                    right: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'thyroid',
                                      label: 'Thyroid Gland',
                                      icon: Icons.hub,
                                      isRightSide: true,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'thyroid',
                                      ),
                                    ),
                                  ),

                                // LEFT CALLOUT 3: Lungs & Airways
                                if (isAllSelected || selectedOrgan == 'lungs')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.17,
                                    left: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'lungs',
                                      label: 'Lungs & Airways',
                                      icon: Icons.air,
                                      isRightSide: false,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'lungs',
                                      ),
                                    ),
                                  ),

                                // RIGHT CALLOUT 3: Heart & Circulation
                                if (isAllSelected || selectedOrgan == 'chest')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.21,
                                    right: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'chest',
                                      label: 'Heart & Circulation',
                                      icon: Icons.favorite,
                                      isRightSide: true,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'chest',
                                      ),
                                    ),
                                  ),

                                // LEFT CALLOUT 4: Liver & Biliary
                                if (isAllSelected || selectedOrgan == 'liver')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.25,
                                    left: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'liver',
                                      label: 'Liver & Biliary',
                                      icon: Icons.opacity,
                                      isRightSide: false,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'liver',
                                      ),
                                    ),
                                  ),

                                // RIGHT CALLOUT 4: Stomach & Digestive
                                if (isAllSelected || selectedOrgan == 'abdomen')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.29,
                                    right: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'abdomen',
                                      label: 'Stomach & Digestive',
                                      icon: Icons.restaurant,
                                      isRightSide: true,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'abdomen',
                                      ),
                                    ),
                                  ),

                                // LEFT CALLOUT 5: Kidneys & Renal
                                if (isAllSelected || selectedOrgan == 'kidneys')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.33,
                                    left: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'kidneys',
                                      label: 'Kidneys & Renal',
                                      icon: Icons.water_drop,
                                      isRightSide: false,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'kidneys',
                                      ),
                                    ),
                                  ),

                                // RIGHT CALLOUT 5: Arm Musculature
                                if (isAllSelected || selectedOrgan == 'arms')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.37,
                                    right: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'arms',
                                      label: 'Arm Musculature',
                                      icon: Icons.fitness_center,
                                      isRightSide: true,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'arms',
                                      ),
                                    ),
                                  ),

                                // LEFT CALLOUT 6: Knee & Femur Joint
                                if (isAllSelected || selectedOrgan == 'legs')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.44,
                                    left: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'legs',
                                      label: 'Knee & Femur',
                                      icon: Icons.accessibility_new,
                                      isRightSide: false,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'legs',
                                      ),
                                    ),
                                  ),

                                // RIGHT CALLOUT 6: Leg & Ankle
                                if (isAllSelected || selectedOrgan == 'feet')
                                  Positioned(
                                    top:
                                        MediaQuery.of(context).size.height *
                                        0.50,
                                    right: 10,
                                    child: _buildPointerLineLabel(
                                      organKey: 'feet',
                                      label: 'Leg & Ankle',
                                      icon: Icons.directions_walk,
                                      isRightSide: true,
                                      onTap: () => setState(
                                        () => selectedOrgan = 'feet',
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
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
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

  // Doctor Diagram Style Anatomical Pointer Line & Label Chip
  Widget _buildPointerLineLabel({
    required String organKey,
    required String label,
    required IconData icon,
    required bool isRightSide,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedOrgan == organKey;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isRightSide) ...[
            // Glowing Target Dot on Body Part
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.6),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            // Precise Horizontal Pointer Line
            Container(
              width: 20,
              height: 1.2,
              color: primaryColor.withValues(alpha: 0.5),
            ),
          ],

          // Compact Doctor Callout Chip
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey.shade200,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? primaryColor.withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 11,
                  color: isSelected ? Colors.white : primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          if (!isRightSide) ...[
            // Precise Horizontal Pointer Line
            Container(
              width: 20,
              height: 1.2,
              color: primaryColor.withValues(alpha: 0.5),
            ),
            // Glowing Target Dot on Body Part
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.6),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      organData['description'],
                      style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: Colors.grey.shade700,
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _openOrganDetails(organData),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
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
                                fontSize: 11.5,
                              ),
                            ),
                            const SizedBox(width: 5),
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
