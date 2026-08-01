with open('lib/features/doctors/doctor_details_screen.dart', 'r') as f:
    content = f.read()

old_video = """  void _initializeVideoPlayer() {
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
  }"""

new_video = """  void _initializeVideoPlayer() {
    if (_doctorDetails == null) return;
    
    final videoType = _doctorDetails!['video_type'];
    final videoUrl = _doctorDetails!['video_url'];
    
    if (videoUrl != null && videoUrl.toString().isNotEmpty) {
      if (videoType == 'youtube') {
        String videoId = '';
        if (videoUrl.contains('v=')) {
          videoId = videoUrl.split('v=')[1].split('&')[0];
        } else if (videoUrl.contains('youtu.be/')) {
          videoId = videoUrl.split('youtu.be/')[1].split('?')[0];
        } else {
          videoId = videoUrl; // fallback
        }
        
        if (videoId.isNotEmpty) {
          _youtubeController = YoutubePlayerController.fromVideoId(
            videoId: videoId,
            autoPlay: false,
            params: const YoutubePlayerParams(showFullscreenButton: true),
          );
        }
      } else if (videoType == 'uploaded') {
        final fullUrl = ApiClient.getImageUrl(videoUrl);
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(fullUrl))
          ..initialize().then((_) {
            if (mounted) setState(() {});
          });
      }
    }
  }"""

content = content.replace(old_video, new_video)

with open('lib/features/doctors/doctor_details_screen.dart', 'w') as f:
    f.write(content)
