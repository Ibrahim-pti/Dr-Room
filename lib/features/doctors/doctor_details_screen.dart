import 'package:dr_room/main.dart';
import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:convert';
import 'dart:ui';

import '../../core/providers/favorite_provider.dart';
import '../../core/utils/api_client.dart';
import 'doctor_reviews_screen.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final int doctorId;
  final String name;
  final String specialty;
  final String image;

  const DoctorDetailsScreen({
    super.key,
    required this.doctorId,
    required this.name,
    required this.specialty,
    required this.image,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  int _selectedServiceIndex = 0;
  int _selectedTabIndex = 0;
  int _currentImageIndex = 0;
  final PageController _imagePageController = PageController();
  bool _isBooking = false;
  final List<Map<String, dynamic>> _dynamicDates = [];
  final List<String> _dynamicTimes = [];
  List<dynamic> _services = [];

  Map<String, dynamic>? _doctorDetails;
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youtubeController;
  String? _initializedVideoUrl;
  bool _isLoadingDetails = true;

  @override
  void initState() {
    super.initState();
    _loadCachedDoctorDetails();
    _fetchDoctorDetails();
  }

  Future<void> _loadCachedDoctorDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedStr = prefs.getString('cached_doctor_details_${widget.doctorId}');
      if (cachedStr != null && cachedStr.isNotEmpty && mounted) {
        final data = jsonDecode(cachedStr);
        setState(() {
          _doctorDetails = data;
          _isLoadingDetails = false;
          if (data['services'] != null && (data['services'] as List).isNotEmpty) {
            _services = data['services'];
          }
          _generateDynamicSchedules(data['schedules']);
        });
        _initializeVideoPlayer();
      }
    } catch (_) {}
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      final response = await ApiClient.get('/doctors/${widget.doctorId}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_doctor_details_${widget.doctorId}', response.body);

        if (mounted) {
          setState(() {
            _doctorDetails = data;
            _isLoadingDetails = false;
            if (data['services'] != null && (data['services'] as List).isNotEmpty) {
              _services = data['services'];
            }
            _generateDynamicSchedules(data['schedules']);
          });
          _initializeVideoPlayer();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDetails = false;
        });
      }
    }
  }

  void _generateDynamicSchedules(List<dynamic>? schedules) {
    if (schedules == null || schedules.isEmpty) return;
    
    _dynamicDates.clear();
    final now = DateTime.now();
    
    Map<String, dynamic> daysMap = {};
    for (var s in schedules) {
      daysMap[s['day_of_week']] = s;
    }
    
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      final dayName = daysOfWeek[date.weekday - 1];
      
      if (daysMap.containsKey(dayName)) {
        final schedule = daysMap[dayName];
        _dynamicDates.add({
          'day': DateFormat('E').format(date),
          'date': DateFormat('dd').format(date),
          'month': DateFormat('MMM').format(date),
          'full_date': DateFormat('yyyy-MM-dd').format(date),
          'start_time': schedule['start_time'],
          'end_time': schedule['end_time'],
          'schedule_id': schedule['id'],
        });
      }
    }
    
    if (_dynamicDates.isNotEmpty) {
      _selectedDateIndex = 0;
      _updateDynamicTimes();
    }
  }

  void _updateDynamicTimes() {
    _dynamicTimes.clear();
    _selectedTimeIndex = -1;
    if (_dynamicDates.isEmpty) return;
    
    final selectedDate = _dynamicDates[_selectedDateIndex];
    final startStr = selectedDate['start_time'].toString();
    final endStr = selectedDate['end_time'].toString();
    
    try {
      var startParts = startStr.split(':');
      var endParts = endStr.split(':');
      
      var start = TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
      var end = TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));
      
      var current = start;
      while (current.hour < end.hour || (current.hour == end.hour && current.minute <= end.minute)) {
        final period = current.hour >= 12 ? 'PM' : 'AM';
        int h = current.hour > 12 ? current.hour - 12 : (current.hour == 0 ? 12 : current.hour);
        final m = current.minute.toString().padLeft(2, '0');
        _dynamicTimes.add('${h.toString().padLeft(2, '0')}:$m $period');
        
        int newMin = current.minute + 30;
        int newHour = current.hour;
        if (newMin >= 60) {
          newHour += 1;
          newMin -= 60;
        }
        current = TimeOfDay(hour: newHour, minute: newMin);
      }
    } catch (_) {}
  }

  void _initializeVideoPlayer() {
    if (_doctorDetails == null) return;
    
    final videoType = _doctorDetails!['video_type'];
    final videoUrl = _doctorDetails!['video_url'];
    
    if (videoUrl != null && videoUrl.toString().isNotEmpty) {
      final String urlStr = videoUrl.toString();
      if (_initializedVideoUrl == urlStr) return;
      _initializedVideoUrl = urlStr;
      
      if (videoType == 'youtube' || urlStr.contains('youtube.com') || urlStr.contains('youtu.be')) {
        String videoId = '';
        if (urlStr.contains('v=')) {
          videoId = urlStr.split('v=')[1].split('&')[0];
        } else if (urlStr.contains('youtu.be/')) {
          videoId = urlStr.split('youtu.be/')[1].split('?')[0];
        } else {
          videoId = urlStr;
        }
        
        if (videoId.isNotEmpty) {
          _youtubeController = YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: true,
            params: const YoutubePlayerParams(
              showControls: true,
              showFullscreenButton: true,
              showVideoAnnotations: false,
              strictRelatedVideos: true,
            ),
          );
          if (mounted) setState(() {});
        }
      } else {
        final fullUrl = urlStr.startsWith('http') ? urlStr : ApiClient.getImageUrl(urlStr);
        _videoPlayerController?.dispose();
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(fullUrl))
          ..initialize().then((_) {
            _videoPlayerController!.setLooping(true);
            _videoPlayerController!.play();
            if (mounted) setState(() {});
          }).catchError((_) {});
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _youtubeController?.close();
    super.dispose();
  }

  Future<void> _bookAppointment() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      if (!mounted) return;
      _showLoginPrompt();
      return;
    }

    setState(() {
      _isBooking = true;
    });

    try {
      if (_dynamicDates.isEmpty || _selectedTimeIndex == -1) {
        throw Exception('Please select date and time');
      }
      
      final date = _dynamicDates[_selectedDateIndex]['full_date'];
      final timeStr = _dynamicTimes[_selectedTimeIndex];
      
      final isPM = timeStr.contains('PM');
      var hour = int.parse(timeStr.split(':')[0]);
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      final minute = timeStr.split(':')[1].substring(0, 2);
      final formattedDate = '$date ${hour.toString().padLeft(2, '0')}:$minute:00';

      Map<String, dynamic> body = {
        'doctor_id': widget.doctorId,
        'appointment_date': formattedDate,
        'type': 'in_person',
      };
      
      if (_selectedServiceIndex != -1 && _services.isNotEmpty) {
        body['service_id'] = _services[_selectedServiceIndex]['id'];
      }

      final response = await ApiClient.post('/appointments', body: body);

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('نۆرەکە بە سەرکەوتوویی تۆمارکرا!'),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('داواکارییەکە سەرکەوتوو نەبوو: ${response.body}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('کێشەیەک ڕوویدا. تکایە دووبارە تاقی بکەرەوە.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }

  void _showLoginPrompt() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'پێویستە چوونەژوورەوە بکەیت',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        content: Text(
          'بۆ وەرگرتنی کات لای دکتۆر پێویستە سەرەتا خۆت تۆمار بکەیت یان چوونەژوورەوە بکەیت.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF475569),
            height: 1.5,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'دواتر',
              style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AppFlow(startAtLogin: true),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D4ED8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'چوونەژوورەوە',
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getDoctorImages() {
    List<String> list = [];
    if (widget.image.isNotEmpty) {
      list.add(widget.image);
    }
    // Add additional gallery photos if present in _doctorDetails or fallbacks
    if (_doctorDetails != null && _doctorDetails!['gallery'] != null && (_doctorDetails!['gallery'] as List).isNotEmpty) {
      for (var img in _doctorDetails!['gallery']) {
        list.add(ApiClient.getImageUrl(img.toString()));
      }
    } else {
      // Add tasteful fallback gallery images for carousel experience
      list.addAll([
        'assets/images/doctor1.png',
        'assets/images/doctor2.png',
      ]);
    }
    return list.toSet().toList(); // Unique
  }

  String _getDoctorName() {
    if (_doctorDetails != null && _doctorDetails!['user'] != null && _doctorDetails!['user']['name'] != null) {
      return _doctorDetails!['user']['name'];
    }
    return widget.name;
  }

  String _getDoctorSpecialty() {
    final locale = context.locale.languageCode;
    if (_doctorDetails != null) {
      if (locale == 'en' && _doctorDetails!['specialty_en'] != null && _doctorDetails!['specialty_en'].toString().isNotEmpty) {
        return _doctorDetails!['specialty_en'];
      }
      if (locale == 'ar' && _doctorDetails!['specialty_ar'] != null && _doctorDetails!['specialty_ar'].toString().isNotEmpty) {
        return _doctorDetails!['specialty_ar'];
      }
      if (_doctorDetails!['specialty'] != null && _doctorDetails!['specialty'].toString().isNotEmpty) {
        return _doctorDetails!['specialty'];
      }
    }
    return widget.specialty;
  }

  String _getDoctorBio() {
    final locale = context.locale.languageCode;
    if (_doctorDetails != null) {
      if (locale == 'en' && _doctorDetails!['bio_en'] != null && _doctorDetails!['bio_en'].toString().isNotEmpty) {
        return _doctorDetails!['bio_en'];
      }
      if (locale == 'ar' && _doctorDetails!['bio_ar'] != null && _doctorDetails!['bio_ar'].toString().isNotEmpty) {
        return _doctorDetails!['bio_ar'];
      }
      if (_doctorDetails!['bio'] != null && _doctorDetails!['bio'].toString().isNotEmpty) {
        return _doctorDetails!['bio'];
      }
    }
    return 'doctor_desc'.tr(args: [_getDoctorName(), _getDoctorSpecialty()]);
  }

  String _getCurrentPrice() {
    if (_selectedServiceIndex != -1 && _services.isNotEmpty) {
      final price = _services[_selectedServiceIndex]['price'];
      if (price != null) return '\$$price';
    }
    if (_doctorDetails != null && _doctorDetails!['consultation_fee'] != null) {
      return '\$${_doctorDetails!['consultation_fee']}';
    }
    return '\$15.00';
  }

  @override
  Widget build(BuildContext context) {
    final doctorName = _getDoctorName();
    final doctorSpecialty = _getDoctorSpecialty();
    final doctorBio = _getDoctorBio();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Ultra Modern Flexible Hero Header (Curved Carousel) ──
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                stretch: true,
                backgroundColor: const Color(0xFFF1F5F9),
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      final isFavorite = favoriteProvider.isFavorite(widget.doctorId);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withValues(alpha: 0.3),
                              child: IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite_rounded : Iconsax.heart,
                                  color: isFavorite ? const Color(0xFFEF4444) : Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  favoriteProvider.toggleFavorite({
                                    'id': widget.doctorId,
                                    'doctor': doctorName,
                                    'specialty': doctorSpecialty,
                                    'image': widget.image,
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [StretchMode.zoomBackground, StretchMode.blurBackground],
                  background: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Carousel Image PageView
                        Builder(
                          builder: (context) {
                            final images = _getDoctorImages();
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                PageView.builder(
                                  controller: _imagePageController,
                                  itemCount: images.length,
                                  onPageChanged: (idx) {
                                    setState(() {
                                      _currentImageIndex = idx;
                                    });
                                  },
                                  itemBuilder: (context, idx) {
                                    final img = images[idx];
                                    return Hero(
                                      tag: idx == 0 ? widget.name : 'doctor_img_$idx',
                                      child: img.startsWith('http')
                                          ? Image.network(img, fit: BoxFit.cover, alignment: Alignment.topCenter)
                                          : Image.asset(img, fit: BoxFit.cover, alignment: Alignment.topCenter),
                                    );
                                  },
                                ),
                                // Carousel Indicator Dots Pill
                                if (images.length > 1)
                                  Positioned(
                                    top: 55,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            color: Colors.black.withValues(alpha: 0.3),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(images.length, (idx) {
                                                final isSelected = _currentImageIndex == idx;
                                                return AnimatedContainer(
                                                  duration: const Duration(milliseconds: 300),
                                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                                  width: isSelected ? 20 : 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.4),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        // Vignette / Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.45),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.82),
                              ],
                              stops: const [0.0, 0.45, 1.0],
                            ),
                          ),
                        ),
                        // Header Info Title overlay
                        Positioned(
                          bottom: 24,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      doctorName,
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2563EB),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                doctorSpecialty,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF60A5FA),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Main Body Content ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 160),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // ── Quick Info Stats Bar (Floating Pills) ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF64748B).withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                icon: Iconsax.star_1,
                                iconColor: const Color(0xFFF59E0B),
                                title: _doctorDetails?['rating']?.toString() ?? '4.9',
                                subtitle: '124 reviews',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorReviewsScreen(
                                        doctorName: doctorName,
                                        rating: '4.9',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              _buildDivider(),
                              _buildStatItem(
                                icon: Iconsax.award,
                                iconColor: const Color(0xFF2563EB),
                                title: '10+ Yrs',
                                subtitle: 'Experience',
                              ),
                              _buildDivider(),
                              _buildStatItem(
                                icon: Iconsax.people,
                                iconColor: const Color(0xFF10B981),
                                title: '1.2k+',
                                subtitle: 'Patients',
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

                      const SizedBox(height: 24),

                      // ── Segmented Tab Switcher Bar (ناساندن / خزمەتگوزارییەکان) ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF64748B).withValues(alpha: 0.06),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Tab 0: ناساندن
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedTabIndex = 0),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      gradient: _selectedTabIndex == 0
                                          ? const LinearGradient(
                                              colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color: _selectedTabIndex == 0 ? null : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: _selectedTabIndex == 0
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Iconsax.user_tag,
                                          size: 20,
                                          color: _selectedTabIndex == 0 ? Colors.white : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'ناساندن',
                                          style: GoogleFonts.poppins(
                                            color: _selectedTabIndex == 0 ? Colors.white : const Color(0xFF64748B),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Tab 1: خزمەتگوزارییەکان
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedTabIndex = 1),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      gradient: _selectedTabIndex == 1
                                          ? const LinearGradient(
                                              colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            )
                                          : null,
                                      color: _selectedTabIndex == 1 ? null : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: _selectedTabIndex == 1
                                          ? [
                                              BoxShadow(
                                                color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Iconsax.health,
                                          size: 20,
                                          color: _selectedTabIndex == 1 ? Colors.white : const Color(0xFF64748B),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'خزمەتگوزارییەکان',
                                          style: GoogleFonts.poppins(
                                            color: _selectedTabIndex == 1 ? Colors.white : const Color(0xFF64748B),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 20),

                      // ── Tab 0: ناساندن (Intro Video & About Doctor) ──
                      if (_selectedTabIndex == 0) ...[
                        if (_isLoadingDetails && _doctorDetails == null) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                              ),
                            ),
                          ),
                        ] else ...[
                          // Intro Video Player Card
                          if (_youtubeController != null || (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) || (_doctorDetails != null && _doctorDetails!['video_url'] != null && _doctorDetails!['video_url'].toString().isNotEmpty)) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2563EB).withValues(alpha: 0.08),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFF6FF),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(Iconsax.video_play, color: Color(0xFF2563EB), size: 20),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'ڤیدیۆی ناساندنی دکتۆر',
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF0F172A),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: _youtubeController != null
                                            ? YoutubePlayer(controller: _youtubeController!)
                                            : (_videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                                                ? Stack(
                                                    alignment: Alignment.bottomCenter,
                                                    children: [
                                                      VideoPlayer(_videoPlayerController!),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        right: 0,
                                                        child: VideoProgressIndicator(
                                                          _videoPlayerController!,
                                                          allowScrubbing: true,
                                                          colors: const VideoProgressColors(
                                                            playedColor: Color(0xFF2563EB),
                                                            bufferedColor: Color(0xFF94A3B8),
                                                            backgroundColor: Color(0xFFCBD5E1),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(duration: 300.ms),
                            const SizedBox(height: 20),
                          ],

                          // About Doctor Card
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF64748B).withValues(alpha: 0.06),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Iconsax.user_tag, color: Color(0xFF2563EB), size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'about_doctor'.tr(),
                                        style: GoogleFonts.poppins(
                                          color: const Color(0xFF0F172A),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    doctorBio,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF475569),
                                      fontSize: 14,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animate().fadeIn(duration: 300.ms),
                        ],
                      ],

                      // ── Tab 1: خزمەتگوزارییەکان (Services List) ──
                      if (_selectedTabIndex == 1) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Iconsax.health, color: Color(0xFF2563EB), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'جۆری سەردان (خزمەتگوزاری)',
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _services.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'هیچ خزمەتگوزارییەک لەم بەشەدا بەردەست نییە',
                                          style: GoogleFonts.poppins(
                                            color: const Color(0xFF64748B),
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    )
                                  : ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: _services.length,
                                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                                      itemBuilder: (context, index) {
                                        final isSelected = _selectedServiceIndex == index;
                                        final service = _services[index];
                                        final locale = context.locale.languageCode;
                                        
                                        String name = service['name_ckb'] ?? service['name'] ?? '';
                                        if (locale == 'en' && service['name_en'] != null) name = service['name_en'];
                                        if (locale == 'ar' && service['name_ar'] != null) name = service['name_ar'];

                                        String desc = service['description_ckb'] ?? service['description'] ?? '';
                                        if (locale == 'en' && service['description_en'] != null) desc = service['description_en'];
                                        if (locale == 'ar' && service['description_ar'] != null) desc = service['description_ar'];

                                        return GestureDetector(
                                          onTap: () => setState(() => _selectedServiceIndex = index),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 250),
                                            padding: const EdgeInsets.all(18),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(
                                                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                                width: isSelected ? 2 : 1,
                                              ),
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color: const Color(0xFF2563EB).withValues(alpha: 0.14),
                                                        blurRadius: 16,
                                                        offset: const Offset(0, 6),
                                                      )
                                                    ]
                                                  : [
                                                      BoxShadow(
                                                        color: const Color(0xFF64748B).withValues(alpha: 0.04),
                                                        blurRadius: 10,
                                                        offset: const Offset(0, 4),
                                                      )
                                                    ],
                                            ),
                                            child: Row(
                                              children: [
                                                AnimatedContainer(
                                                  duration: const Duration(milliseconds: 200),
                                                  padding: const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    isSelected ? Icons.check_rounded : Iconsax.hospital,
                                                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        name,
                                                        style: GoogleFonts.poppins(
                                                          color: const Color(0xFF0F172A),
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      if (desc.isNotEmpty) ...[
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          desc,
                                                          style: GoogleFonts.poppins(
                                                            color: const Color(0xFF64748B),
                                                            fontSize: 12,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF8FAFC),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(
                                                    '\$${service['price']}',
                                                    style: GoogleFonts.poppins(
                                                      color: isSelected ? Colors.white : const Color(0xFF2563EB),
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 300.ms),
                        const SizedBox(height: 24),

                        // ── Schedule Calendar Section ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Iconsax.calendar_1, color: Color(0xFF2563EB), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'select_date'.tr(),
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                height: 90,
                                child: _dynamicDates.isEmpty
                                    ? Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF2F2),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "ببوورە کاتی بەردەست دیاری نەکراوە",
                                            style: GoogleFonts.poppins(color: const Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _dynamicDates.length,
                                        itemBuilder: (context, index) {
                                          final isSelected = _selectedDateIndex == index;
                                          final item = _dynamicDates[index];
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedDateIndex = index;
                                                _updateDynamicTimes();
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 250),
                                              margin: const EdgeInsets.only(right: 10),
                                              width: 72,
                                              decoration: BoxDecoration(
                                                color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                                                borderRadius: BorderRadius.circular(22),
                                                border: Border.all(
                                                  color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                                  width: isSelected ? 2 : 1,
                                                ),
                                                boxShadow: isSelected
                                                    ? [
                                                        BoxShadow(
                                                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                                                          blurRadius: 12,
                                                          offset: const Offset(0, 6),
                                                        )
                                                      ]
                                                    : [
                                                        BoxShadow(
                                                          color: const Color(0xFF64748B).withValues(alpha: 0.04),
                                                          blurRadius: 8,
                                                          offset: const Offset(0, 4),
                                                        )
                                                      ],
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    item['day'],
                                                    style: GoogleFonts.poppins(
                                                      color: isSelected ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF64748B),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    item['date'],
                                                    style: GoogleFonts.poppins(
                                                      color: isSelected ? Colors.white : const Color(0xFF0F172A),
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    item['month'],
                                                    style: GoogleFonts.poppins(
                                                      color: isSelected ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF94A3B8),
                                                      fontSize: 11,
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
                        ).animate(delay: 250.ms).fadeIn(),

                        const SizedBox(height: 24),

                        // ── Available Time Slots Section ──
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Iconsax.clock, color: Color(0xFF2563EB), size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'available_time'.tr(),
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              _dynamicTimes.isEmpty
                                  ? Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF2F2),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        'تکایە کاتژمێری دیاریکراو لەم بەشەدا بەردەست نییە',
                                        style: GoogleFonts.poppins(color: const Color(0xFF991B1B), fontSize: 13, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  : Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: List.generate(_dynamicTimes.length, (index) {
                                        final isSelected = _selectedTimeIndex == index;
                                        return GestureDetector(
                                          onTap: () => setState(() => _selectedTimeIndex = index),
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 200),
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
                                              ),
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                                                        blurRadius: 10,
                                                        offset: const Offset(0, 4),
                                                      )
                                                    ]
                                                  : [
                                                      BoxShadow(
                                                        color: const Color(0xFF64748B).withValues(alpha: 0.03),
                                                        blurRadius: 6,
                                                        offset: const Offset(0, 2),
                                                      )
                                                    ],
                                            ),
                                            child: Text(
                                              _dynamicTimes[index],
                                              style: GoogleFonts.poppins(
                                                color: isSelected ? Colors.white : const Color(0xFF0F172A),
                                                fontSize: 14,
                                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                            ],
                          ),
                        ).animate(delay: 300.ms).fadeIn(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Ultra Floating Bottom Action Bar ──
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.12),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'consultation_price'.tr(),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF64748B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getCurrentPrice(),
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF1D4ED8),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                  blurRadius: 14,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: (_selectedTimeIndex != -1 && !_isBooking)
                                  ? _bookAppointment
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                disabledBackgroundColor: const Color(0xFF94A3B8).withValues(alpha: 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: _isBooking
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      'book_appointment'.tr(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
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

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF0F172A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                color: const Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 28,
      width: 1,
      color: const Color(0xFFE2E8F0),
    );
  }
}
