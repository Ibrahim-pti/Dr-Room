import re

with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

# Add imports for video player and youtube player
imports = """import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
"""
if "import 'package:video_player/video_player.dart';" not in content:
    content = content.replace("import 'package:easy_localization/easy_localization.dart';", "import 'package:easy_localization/easy_localization.dart';\n" + imports)

# We need to change the state to load data from API
state_code_new = """
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

  void _initializeVideoPlayer() {
    if (_doctorDetails == null) return;
    
    final videoType = _doctorDetails!['video_type'];
    final videoUrl = _doctorDetails!['video_url'];
    
    if (videoUrl != null && videoUrl.toString().isNotEmpty) {
      if (videoType == 'youtube') {
        final videoId = YoutubePlayer.convertUrlToId(videoUrl);
        if (videoId != null) {
          _youtubeController = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false),
          );
        }
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
    _youtubeController?.dispose();
    super.dispose();
  }
"""

content = re.sub(r'class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> \{.*?(?=  final List<Map<String, String>> _dates = \[)', 'class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {\n  int _selectedDateIndex = 0;\n  int _selectedTimeIndex = -1;\n  bool _isBooking = false;\n' + state_code_new + '\n', content, flags=re.DOTALL)

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
