import 'package:dr_room/main.dart';
import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:convert';

import '../../core/providers/favorite_provider.dart';
import '../../core/utils/api_client.dart';

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
  bool _isBooking = false;
  final List<Map<String, dynamic>> _dynamicDates = [];
  final List<String> _dynamicTimes = [];
  List<dynamic> _services = [];

  Map<String, dynamic>? _doctorDetails;
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youtubeController;
  String? _initializedVideoUrl;

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
            if (data['services'] != null && (data['services'] as List).isNotEmpty) {
              _services = data['services'];
            }
            _generateDynamicSchedules(data['schedules']);
          });
          _initializeVideoPlayer();
        }
      }
    } catch (e) {
      // Intentionally left empty if it fails we have cache
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
        Navigator.pop(context); // Close bottom sheet
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
    if (_doctorDetails != null && _doctorDetails!['gallery'] != null && (_doctorDetails!['gallery'] as List).isNotEmpty) {
      for (var img in _doctorDetails!['gallery']) {
        list.add(ApiClient.getImageUrl(img.toString()));
      }
    } else {
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

  @override
  Widget build(BuildContext context) {
    final doctorName = _getDoctorName();
    final doctorSpecialty = _getDoctorSpecialty();
    final rating = _doctorDetails?['rating']?.toString() ?? '5.0';
    final images = _getDoctorImages();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER SECTION ---
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Light Blue Curved Background with Premium Shadow
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE0F2FE), Color(0xFFF1F5F9)], // Very soft sky blue to slate
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            )
                          ],
                        ),
                      ),
                      
                      // App Bar row
                      SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Color(0xFF0F172A)),
                                ),
                              ),
                              Consumer<FavoriteProvider>(
                                builder: (context, favoriteProvider, child) {
                                  final isFavorite = favoriteProvider.isFavorite(widget.doctorId);
                                  return GestureDetector(
                                    onTap: () {
                                      favoriteProvider.toggleFavorite({
                                        'id': widget.doctorId,
                                        'doctor': doctorName,
                                        'specialty': doctorSpecialty,
                                        'image': widget.image,
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isFavorite ? Icons.favorite_rounded : Iconsax.heart,
                                        size: 20,
                                        color: isFavorite ? const Color(0xFFEF4444) : const Color(0xFF0F172A),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Doctor Info & Avatar
                      Positioned(
                        top: 100,
                        left: 20,
                        right: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          children: [
                            // Avatar on Right
                            Container(
                              width: 85,
                              height: 85,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: widget.image.startsWith('http') 
                                    ? NetworkImage(widget.image) 
                                    : AssetImage(widget.image) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Info on Left
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                textDirection: TextDirection.rtl,
                                children: [
                                  Text(
                                    doctorName,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doctorSpecialty,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Text(
                                        rating,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
                    ],
                  ),

                  const SizedBox(height: 10), // Reduced gap for overlap feel

                  // --- VIDEO CARD SECTION ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A), // Slate 900
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F172A).withValues(alpha: 0.15),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Video Background
                            if (_youtubeController != null)
                              YoutubePlayer(
                                controller: _youtubeController!,
                                backgroundColor: Colors.transparent,
                              )
                            else if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                              FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: _videoPlayerController!.value.size.width,
                                  height: _videoPlayerController!.value.size.height,
                                  child: VideoPlayer(_videoPlayerController!),
                                ),
                              )
                            else
                              Container(
                                color: const Color(0xFF1E3A8A),
                                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                              ),

                            // Overlay Gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    const Color(0xFF1E3A8A).withValues(alpha: 0.8),
                                    const Color(0xFF1E3A8A).withValues(alpha: 0.3),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Left Decoration Tag (using Blue instead of Green)
                            Positioned(
                              left: 0,
                              top: 20,
                              bottom: 20,
                              child: Container(
                                width: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF3B82F6),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Text & Play Button
                            Positioned(
                              right: 20,
                              top: 0,
                              bottom: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'ناساندنی دکتۆر',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ببینە چۆن یارمەتیت دەدەم',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Center Play Button Overlay (Glassmorphism)
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                                    ),
                                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
                                  ),
                                ),
                              ),
                            ),
                            
                            // Duration Badge
                            Positioned(
                              left: 20,
                              bottom: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '0:45',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: 100.ms),

                  const SizedBox(height: 32),

                  // --- SERVICES SECTION ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'خزمەتگوزارییەکان و داشکانەکان',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    height: 200,
                    child: _services.isEmpty
                      ? Center(
                          child: Text(
                            'هیچ خزمەتگوزارییەک نەدۆزرایەوە',
                            style: GoogleFonts.poppins(color: const Color(0xFF64748B)),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _services.length,
                          itemBuilder: (context, index) {
                            final service = _services[index];
                            final isSelected = _selectedServiceIndex == index;
                            
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedServiceIndex = index;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 160,
                                margin: const EdgeInsets.only(left: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFF1F5F9), // Slate 100
                                    width: isSelected ? 2.5 : 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                                      blurRadius: 25,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Discount Badge & Icon
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Pink/Red badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEE2E2), // Red-100
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'داشکانی تایبەت',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFFEF4444), // Red-500
                                              fontSize: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // Icon with blue background instead of green
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFDBEAFE), // Blue-100
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Iconsax.magic_star, color: Color(0xFF2563EB), size: 18),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      service['name'] ?? 'خزمەتگوزاری',
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Prices
                                    Text(
                                      '~${(service['price'] * 1.5).toStringAsFixed(0)} د.ع~', // Mocked old price for visual
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: const Color(0xFF94A3B8),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      '${service['price']} د.ع',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: const Color(0xFF2563EB), // Primary Blue
                                      ),
                                    ),
                                    Text(
                                      '(30% داشکان)', // Mocked discount text for visual
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        color: const Color(0xFF475569),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: 200.ms),

                  const SizedBox(height: 32),

                  // --- CLINIC IMAGES SECTION ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end, // Align text RTL
                      children: [
                        Text(
                          'وێنەی کلینیکەکە',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'تیمێکی کارامە و کەرەستەی سەردەمیانە',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 120,
                          margin: const EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            image: DecorationImage(
                              image: images[index].startsWith('http')
                                ? NetworkImage(images[index])
                                : AssetImage(images[index]) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn().slideY(begin: 0.2, end: 0, delay: 300.ms),

                  const SizedBox(height: 40), // Spacing for bottom button
                ],
              ),
            ),
          ),
          
          // --- FIXED BOTTOM BOOKING BUTTON ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Blue-500 to Blue-700
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Open Bottom Sheet for Calendar and Time
                    _showBookingBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'گرتنی نۆرەیەک',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
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
    );
  }

  // --- BOTTOM SHEET FOR CALENDAR AND TIME ---
  void _showBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Handle indicator
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
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
                                  'هەڵبژاردنی بەروار',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF0F172A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 90,
                            child: _dynamicDates.isEmpty
                                ? Center(
                                    child: Text(
                                      "ببوورە کاتی بەردەست دیاری نەکراوە",
                                      style: GoogleFonts.poppins(color: const Color(0xFFEF4444), fontSize: 13, fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _dynamicDates.length,
                                    itemBuilder: (context, index) {
                                      final isSelected = _selectedDateIndex == index;
                                      final item = _dynamicDates[index];
                                      return GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            _selectedDateIndex = index;
                                            _updateDynamicTimes();
                                          });
                                          // also update parent state
                                          setState(() {});
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 250),
                                          margin: const EdgeInsets.only(left: 10),
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
                                                : [],
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
                          const SizedBox(height: 32),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
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
                                  'کاتژمێرە بەردەستەکان',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF0F172A),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _dynamicTimes.isEmpty
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
                                    alignment: WrapAlignment.start,
                                    children: List.generate(_dynamicTimes.length, (index) {
                                      final isSelected = _selectedTimeIndex == index;
                                      return GestureDetector(
                                        onTap: () {
                                          setModalState(() => _selectedTimeIndex = index);
                                          setState(() {});
                                        },
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
                                                : [],
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
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isBooking ? null : () {
                            if (_selectedTimeIndex != -1) {
                              _bookAppointment();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تکایە کاتژمێرێک هەڵبژێرە'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isBooking
                              ? const SizedBox(
                                  width: 24, height: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                )
                              : Text(
                                  'تەواوکردنی نۆرە',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
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
            );
          },
        );
      },
    );
  }
}
