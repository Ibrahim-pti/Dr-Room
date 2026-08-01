import 'package:dr_room/main.dart';
import 'package:flutter/material.dart';
import 'package:dr_room/core/theme/dr_room_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:convert';

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
  int _selectedServiceIndex = -1;
  bool _isBooking = false;
  List<Map<String, dynamic>> _dynamicDates = [];
  List<String> _dynamicTimes = [];
  List<dynamic> _services = [];

  Map<String, dynamic>? _doctorDetails;
  bool _isLoadingDetails = true;
  VideoPlayerController? _videoPlayerController;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      final response = await ApiClient.get('/doctors/${widget.doctorId}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            _doctorDetails = data;
            _isLoadingDetails = false;
            if (data['services'] != null) {
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
    
    // Create next 14 days
    _dynamicDates.clear();
    final now = DateTime.now();
    
    // Map of days available
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
        
        // Add 30 mins
        int newMin = current.minute + 30;
        int newHour = current.hour;
        if (newMin >= 60) {
          newHour += 1;
          newMin -= 60;
        }
        current = TimeOfDay(hour: newHour, minute: newMin);
      }
    } catch(e) {}
  }

  void _initializeVideoPlayer() {
    if (_doctorDetails == null) return;
    
    final videoType = _doctorDetails!['video_type'];
    final videoUrl = _doctorDetails!['video_url'];
    
    if (videoUrl != null && videoUrl.toString().isNotEmpty) {
      if (videoType == 'youtube') {
        _youtubeController = YoutubePlayerController.fromVideoId(
          videoId: videoUrl.split('v=')[1].split('&')[0],
          autoPlay: false,
          params: const YoutubePlayerParams(showFullscreenButton: true),
        );
      } else if (videoType == 'uploaded') {
        // Assuming videoUrl is a relative path like /storage/doctor_videos/xyz.mp4
        final fullUrl = 'http://127.0.0.1:8000$videoUrl'; // Use ApiClient base URL ideally, but 127.0.0.1 is safe for emulator
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(fullUrl))
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
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
      
      if (_selectedServiceIndex != -1) {
        body['service_id'] = _services[_selectedServiceIndex]['id'];
      }

      final response = await ApiClient.post(
        '/appointments',
        body: body,
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment booked successfully!'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        Navigator.pop(context); // Go back after booking
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book appointment: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
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
            color: AppColors.getTextTitle(context),
          ),
        ),
        content: Text(
          'بۆ وەرگرتنی کات لای دکتۆر پێویستە سەرەتا خۆت تۆمار بکەیت یان چوونەژوورەوە بکەیت.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.getTextSubtitle(context),
            height: 1.5,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'دواتر',
              style: GoogleFonts.poppins(
                color: AppColors.getTextSubtitle(context),
              ),
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
              backgroundColor: const Color(0xFF3B82F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'چوونەژوورەوە',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'detail_doctor'.tr(), // Needs translation or fallback
          style: GoogleFonts.poppins(
            color: AppColors.getTextTitle(context),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.getTextTitle(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final isFavorite = favoriteProvider.isFavorite(widget.doctorId);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Iconsax.heart,
                  color: isFavorite
                      ? const Color(0xFFEF4444)
                      : AppColors.getTextTitle(context),
                ),
                onPressed: () {
                  favoriteProvider.toggleFavorite({
                    'id': widget.doctorId,
                    'doctor': widget.name,
                    'specialty': widget.specialty,
                    'image': widget.image,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Removed from favorites'
                            : 'Added to favorites',
                      ),
                      backgroundColor: isFavorite
                          ? Colors.red
                          : const Color(0xFF10B981),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsetsDirectional.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Hero Image ──
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Hero(
                    tag: widget.name,
                    child: Container(
                      width: double.infinity,
                      height: 220, // Shorter height for a more beautiful look
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF), // Soft blue background
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          widget.image,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.contain, // Prevents cropping
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ).animate().slideY(begin: -0.1, end: 0).fadeIn(duration: 400.ms),

                // ── Doctor Info Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: GoogleFonts.poppins(
                                color: AppColors.getTextTitle(context),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.specialty,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF64748B),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFF59E0B),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.9',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD97706),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: 0.1, end: 0).fadeIn(duration: 400.ms),

                const SizedBox(height: 24),


                // ── Video Section ──
                if (_isLoadingDetails)
                  const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                else if (_youtubeController != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: YoutubePlayer(
                        controller: _youtubeController!,
                      ),
                    ),
                  )
                else if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            VideoPlayer(_videoPlayerController!),
                            VideoProgressIndicator(_videoPlayerController!, allowScrubbing: true),
                            Center(
                              child: IconButton(
                                icon: Icon(
                                  _videoPlayerController!.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _videoPlayerController!.value.isPlaying
                                        ? _videoPlayerController!.pause()
                                        : _videoPlayerController!.play();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── About Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'about_doctor'.tr(),
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextTitle(context),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'doctor_desc'.tr(args: [widget.name, widget.specialty]),
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextSubtitle(context),
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.1, end: 0),

                const SizedBox(height: 20),

                // ── Reviews Section ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Iconsax.star_1,
                            color: Color(0xFFF59E0B),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '4.9 (124 reviews)',
                            style: GoogleFonts.poppins(
                              color: AppColors.getTextTitle(context),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorReviewsScreen(
                                doctorName: widget.name,
                                rating: '4.9',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'see_all'.tr(),
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF3B82F6),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 250.ms).fadeIn(),

                const SizedBox(height: 24),

                // ── Services Section ──
                if (_services.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'جۆری سەردان (خزمەتگوزاری)',
                      style: GoogleFonts.poppins(
                        color: AppColors.getTextTitle(context),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 50,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: _services.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedServiceIndex == index;
                        final service = _services[index];
                        // Try to get locale based name, fallback to ckb
                        String name = service['name_ckb'] ?? '';
                        final locale = context.locale.languageCode;
                        if (locale == 'en') name = service['name_en'] ?? name;
                        if (locale == 'ar') name = service['name_ar'] ?? name;
                        
                        return GestureDetector(
                          onTap: () => setState(() => _selectedServiceIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.getSurface(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF3B82F6)
                                    : AppColors.getBorder(context),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ]
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              name,
                              style: GoogleFonts.poppins(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.getTextTitle(context),
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                // ── Calendar Selection ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'select_date'.tr(),
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextTitle(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate(delay: 300.ms).fadeIn(),
                const SizedBox(height: 12),
                SizedBox(
                  height: 76,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _dynamicDates.length,
                    itemBuilder: (context, index) {
                      if (_dynamicDates.isEmpty) {
                         return Center(child: Text("ببوورە کات بەردەست نییە", style: TextStyle(color: Colors.red)));
                      }
                      final isSelected = _selectedDateIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDateIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 60,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : AppColors.getSurface(context),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.getBorder(context),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _dynamicDates[index]['day'],
                                style: GoogleFonts.poppins(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.8)
                                      : AppColors.getTextSubtitle(context),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _dynamicDates[index]['date'],
                                style: GoogleFonts.poppins(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.getTextTitle(context),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ).animate(delay: 400.ms).fadeIn().slideX(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // ── Time Slots ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'available_time'.tr(),
                    style: GoogleFonts.poppins(
                      color: AppColors.getTextTitle(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate(delay: 500.ms).fadeIn(),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: List.generate(_dynamicTimes.length, (index) {
                      final isSelected = _selectedTimeIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTimeIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF3B82F6).withValues(alpha: 0.1)
                                : AppColors.getSurface(context),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.getBorder(context),
                            ),
                          ),
                          child: Text(
                            _dynamicTimes[index],
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? const Color(0xFF3B82F6)
                                  : AppColors.getTextTitle(context),
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.1, end: 0),
              ],
            ),
          ),

          // ── Bottom Action Bar ──
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.getSurface(context),
                border: Border(
                  top: BorderSide(
                    color: AppColors.getBorder(context).withValues(alpha: 0.5),
                  ),
                ),
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
                        '\$15.00',
                        style: GoogleFonts.poppins(
                          color: AppColors.getTextTitle(context),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: (_selectedTimeIndex != -1 && !_isBooking)
                            ? _bookAppointment
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          disabledBackgroundColor: const Color(
                            0xFF3B82F6,
                          ).withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
